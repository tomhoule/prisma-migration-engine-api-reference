mod error;
mod markdown;
mod rust_crate;

use error::CrateResult;
use serde::Deserialize;
use std::{
    collections::{BTreeMap, HashMap},
    path::Path,
};

fn main() -> CrateResult {
    let out_dir = std::env::var("out").expect("Expected the $out env var to be defined");
    let api_json_path = std::path::Path::new(&out_dir).join("api.json");
    let api_json = std::fs::read_to_string(api_json_path)?;

    let api: Api = serde_json::from_str(&api_json)?;
    validate(&api);

    let out_dir = Path::new(&out_dir);
    let rust_crate_out_dir = out_dir.join("prisma-migration-engine-api-rs");
    let md_docs_out_dir = out_dir.join("md_docs");
    std::fs::create_dir(&rust_crate_out_dir)?;
    std::fs::create_dir(&md_docs_out_dir)?;
    rust_crate::generate_rust_crate(&rust_crate_out_dir, &api)?;
    markdown::generate_md_docs(&md_docs_out_dir, &api)?;

    eprintln!("ok: definitions generated");

    Ok(())
}

fn validate(api: &Api) {
    let mut errs: Vec<String> = Vec::new();

    for (method_name, method) in &api.methods {
        if !shape_exists(&method.request_shape, api) {
            errs.push(format!("Request shape for {} does not exist", method_name))
        }

        if !shape_exists(&method.response_shape, api) {
            errs.push(format!("Response shape for {} does not exist", method_name))
        }
    }

    for (record_name, record_shape) in &api.record_shapes {
        for (field_name, field) in &record_shape.fields {
            if !shape_exists(&field.shape, api) {
                errs.push(format!(
                    "Field shape for {}.{} does not exist.",
                    record_name, field_name
                ))
            }
        }
    }

    for (enum_name, enum_shape) in &api.enum_shapes {
        for (variant_name, variant) in &enum_shape.variants {
            if let Some(shape) = variant.shape.as_ref() {
                if !shape_exists(shape, api) {
                    errs.push(format!(
                        "Enum variant shape for {}.{} does not exist.",
                        enum_name, variant_name
                    ))
                }
            }
        }
    }

    if !errs.is_empty() {
        for err in errs {
            eprintln!("{}", err);
        }
        std::process::exit(1);
    }
}

fn shape_exists(shape: &str, api: &Api) -> bool {
    let builtin_scalars = ["string", "bool", "u32"];

    if builtin_scalars.contains(&shape) {
        return true;
    }

    if api.enum_shapes.contains_key(shape) {
        return true;
    }

    if api.record_shapes.contains_key(shape) {
        return true;
    }

    return false;
}

// Make sure #[serde(deny_unknown_fields)] is on all struct types here.
#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct Api {
    #[serde(rename = "recordShapes")]
    record_shapes: HashMap<String, RecordShape>,
    #[serde(rename = "enumShapes")]
    enum_shapes: HashMap<String, EnumShape>,
    methods: HashMap<String, Method>,
}

#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct RecordShape {
    description: Option<String>,
    #[serde(default)]
    fields: BTreeMap<String, RecordField>,
}

#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct RecordField {
    description: Option<String>,
    #[serde(rename = "isList", default)]
    is_list: bool,
    #[serde(rename = "isNullable", default)]
    is_nullable: bool,
    shape: String,
}

#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct EnumVariant {
    description: Option<String>,
    /// In cas there is no shape, it just means the variant has no associated data.
    shape: Option<String>,
}

#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct EnumShape {
    description: Option<String>,
    variants: HashMap<String, EnumVariant>,
}

#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
struct Method {
    description: Option<String>,
    #[serde(rename = "requestShape")]
    request_shape: String,
    #[serde(rename = "responseShape")]
    response_shape: String,
}
