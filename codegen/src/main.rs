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

    let out_dir = Path::new(&out_dir);
    let rust_crate_out_dir = out_dir.join("prisma-migration-engine-api-rs");
    let md_docs_out_dir = out_dir.join("md_docs");
    std::fs::create_dir(&rust_crate_out_dir)?;
    std::fs::create_dir(&md_docs_out_dir)?;
    rust_crate::generate_rust_crate(&rust_crate_out_dir, &api)?;
    markdown::generate_md_docs(&md_docs_out_dir, &api)?;

    Ok(())
}

#[derive(Debug, Deserialize)]
struct Api {
    #[serde(rename = "recordShapes")]
    record_shapes: HashMap<String, RecordShape>,
    #[serde(rename = "enumShapes")]
    enum_shapes: HashMap<String, EnumShape>,
    methods: HashMap<String, Method>,
}

#[derive(Debug, Deserialize)]
struct RecordShape {
    description: Option<String>,
    #[serde(default)]
    fields: BTreeMap<String, RecordField>,
}

#[derive(Debug, Deserialize)]
struct RecordField {
    description: Option<String>,
    #[serde(rename = "isList", default)]
    is_list: bool,
    #[serde(rename = "isNullable", default)]
    is_nullable: bool,
    shape: String,
}

#[derive(Debug, Deserialize)]
struct EnumVariant {
    description: Option<String>,
    /// In cas there is no shape, it just means the variant has no associated data.
    shape: Option<String>,
}

#[derive(Debug, Deserialize)]
struct EnumShape {
    description: Option<String>,
    variants: HashMap<String, Option<EnumVariant>>,
}

#[derive(Debug, Deserialize)]
struct Method {
    description: Option<String>,
    #[serde(rename = "requestShape")]
    request_shape: String,
    #[serde(rename = "responseShape")]
    response_shape: String,
}
