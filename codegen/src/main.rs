use serde::Deserialize;
use std::{
    collections::{BTreeMap, HashMap},
    fs::File,
    io::Write as _,
    path::Path,
};

fn main() {
    let out_dir = std::env::var("out").expect("Expected the $out env var to be defined");
    let api_json = std::env::var("API_JSON").expect("Expected $API_JSON env var to be defined");

    let api: Api = serde_json::from_str(&api_json).unwrap();

    let out_dir = Path::new(&out_dir);
    let librs = out_dir.join("lib.rs");
    let mut librs = File::create(&librs).unwrap();
    let mut method_names: Vec<&str> = api.methods.keys().map(String::as_str).collect();
    method_names.sort();

    for method_name in &method_names {
        writeln!(librs, "mod {};", method_name).unwrap();
    }

    writeln!(librs, "\n\nconst METHOD_NAMES: &[&str] = &[").unwrap();

    for method_name in &method_names {
        writeln!(librs, "    \"{}\",", method_name).unwrap();
    }

    writeln!(librs, "];").unwrap();

    let typesrs = out_dir.join("types.rs");
    let mut typesrs = File::create(&typesrs).unwrap();

    for (type_name, record_type) in &api.record_shapes {
        writeln!(typesrs, "struct {} {{", type_name).unwrap();
        for (field_name, field) in &record_type.fields {
            let type_name = match field.shape.as_str() {
                "U32" => "u32",
                other => other,
            };

            writeln!(typesrs, "    {}: {},", field_name, type_name).unwrap();
        }
        writeln!(typesrs, "}}").unwrap();
    }
}

// fn is_builtin_scalar(shape: &str) -> bool {
//     ["String", "U32", "I32", "Boolean"].contains(&shape)
// }

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
    fields: HashMap<String, RecordField>,
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
