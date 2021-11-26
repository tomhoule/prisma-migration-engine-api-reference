mod error;
mod markdown;
mod rust_crate;

use error::CrateResult;
use serde::Deserialize;
use std::{
    collections::{BTreeMap, HashMap},
    path::Path,
};

fn main() {
    let out_dir = std::env::var("out").expect("Expected the $out env var to be defined");
    let api_json = std::env::var("API_JSON").expect("Expected $API_JSON env var to be defined");

    let api: Api = serde_json::from_str(&api_json).unwrap();

    let out_dir = Path::new(&out_dir);
    let rust_crate_out_dir = out_dir.join("prism-migration-engine-api-rs");
    let md_docs_out_dir = out_dir.join("md_docs");
    std::fs::create_dir(&rust_crate_out_dir).unwrap();
    std::fs::create_dir(&md_docs_out_dir).unwrap();
    rust_crate::generate_rust_crate(&rust_crate_out_dir, &api);
    markdown::generate_md_docs(&md_docs_out_dir, &api).unwrap();
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
    fields: BTreeMap<String, RecordField>,
}

#[derive(Debug, Deserialize)]
struct RecordField {
    description: Option<String>,
    #[serde(rename = "isList")]
    is_list: bool,
    #[serde(rename = "isNullable")]
    is_nullable: bool,
    shape: String,
}

#[derive(Debug, Deserialize)]
struct EnumVariant {
    description: Option<String>,
    shape: String,
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
