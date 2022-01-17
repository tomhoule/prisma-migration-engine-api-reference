use crate::{Api, CrateResult};
use heck::{CamelCase, SnakeCase};
use std::{borrow::Cow, fs::File, io::Write as _, path::Path};

pub(crate) fn generate_rust_crate(out_dir: &Path, api: &Api) -> CrateResult {
    let src_dir = out_dir.join("src");
    std::fs::create_dir(&src_dir)?;
    generate_librs(&src_dir, api)?;
    generate_typesrs(&src_dir, api)?;
    write_cargo_toml(&out_dir)?;
    Ok(())
}

fn generate_librs(src_dir: &Path, api: &Api) -> CrateResult {
    let librs = src_dir.join("lib.rs");
    let mut librs = File::create(&librs)?;
    let mut method_names: Vec<&str> = api.methods.keys().map(String::as_str).collect();
    method_names.sort();

    librs.write_all(b"/// API type definitions\npub mod types;")?;

    librs.write_all(b"/// The JSON-RPC methods.\npub mod methods {\n\n")?;

    for method_name in &method_names {
        writeln!(
            librs,
            "/// The `{method_name}` method.",
            method_name = method_name
        )?;

        let method = &api.methods[*method_name];

        if let Some(description) = &method.description {
            for line in description.lines() {
                writeln!(librs, "/// {}", line)?;
            }
        }

        writeln!(
            librs,
            "///\n/// ## Types\n/// \n/// - Request type: [{request_shape}](../../types/struct.{request_shape}.html)",
            request_shape = rustify_type_name(&method.request_shape),
        )?;
        writeln!(
            librs,
            "/// - Response type: [{response_shape}](../../types/struct.{response_shape}.html)",
            response_shape = rustify_type_name(&method.response_shape),
        )?;

        writeln!(
            librs,
            "pub mod {mod_name} {{}}",
            mod_name = method_name.to_snake_case()
        )?;
    }

    writeln!(librs, "\n}}\n\npub const METHOD_NAMES: &[&str] = &[")?;

    for method_name in &method_names {
        writeln!(librs, "    \"{}\",", method_name)?;
    }

    writeln!(librs, "];")?;

    Ok(())
}

fn generate_typesrs(src_dir: &Path, api: &Api) -> CrateResult {
    let typesrs = src_dir.join("types.rs");
    let mut typesrs = File::create(&typesrs)?;

    typesrs.write_all(b"use serde::{Serialize, Deserialize};\n")?;

    for (type_name, record_type) in &api.record_shapes {
        if let Some(description) = &record_type.description {
            for line in description.lines() {
                writeln!(typesrs, "/// {}", line)?;
            }
        }

        writeln!(
            typesrs,
            "#[derive(Serialize, Deserialize)]\npub struct {} {{",
            rustify_type_name(type_name)
        )?;
        for (field_name, field) in &record_type.fields {
            if let Some(description) = &field.description {
                for line in description.lines() {
                    writeln!(typesrs, "    /// {}", line)?;
                }
            }
            let type_name = rustify_type_name(&field.shape);
            let type_name: Cow<'static, str> = match (field.is_list, field.is_nullable) {
                (true, true) => format!("Option<Vec<{}>>", type_name).into(),
                (false, true) => format!("Option<{}>", type_name).into(),
                (true, false) => format!("Vec<{}>", type_name).into(),
                (false, false) => type_name,
            };
            let field_name_sc = field_name.to_snake_case();
            if &field_name_sc != field_name {
                writeln!(typesrs, "    ///\n    /// JSON name: {}", field_name)?;
                writeln!(typesrs, "    #[serde(rename = \"{}\")]", field_name)?;
            }

            writeln!(typesrs, "    pub {}: {},", field_name_sc, type_name)?;
        }
        writeln!(typesrs, "}}\n")?;
    }

    for (type_name, variants) in &api.enum_shapes {
        if let Some(description) = &variants.description {
            for line in description.lines() {
                writeln!(typesrs, "/// {}", line)?;
            }
        }
        writeln!(
            typesrs,
            "#[derive(Serialize, Deserialize)]\n#[serde(tag = \"tag\")]\npub enum {} {{",
            rustify_type_name(type_name)
        )?;

        for (variant_name, variant) in &variants.variants {
            if let Some(description) = &variant.description {
                for line in description.lines() {
                    writeln!(typesrs, "    /// {}", line)?;
                }

                let cc_variant_name = variant_name.to_camel_case();

                if cc_variant_name.as_str() != variant_name {
                    writeln!(typesrs, "///\n/// JSON name: {}", variant_name)?;
                    writeln!(typesrs, "#[serde(rename = \"{}\")]", variant_name)?;
                }

                if let Some(shape) = &variant.shape {
                    writeln!(
                        typesrs,
                        "    {}({}),",
                        cc_variant_name,
                        rustify_type_name(shape)
                    )?;
                } else {
                    writeln!(typesrs, "    {},", cc_variant_name)?;
                }
            }
        }

        writeln!(typesrs, "}}\n")?;
    }

    Ok(())
}

const CARGO_TOML: &str = r#"
[package]
name = "migration-engine-json-rpc-api-reference"
version = "0.1.0"
edition = "2021"

[dependencies]
serde = { version = "1", default_features = false, features = ["derive"] }
serde_json = { version = "1", features = ["std"], default_features = false }
"#;

fn write_cargo_toml(out_dir: &Path) -> CrateResult {
    let cargo_toml = out_dir.join("Cargo.toml");
    let mut cargo_toml = File::create(&cargo_toml)?;

    cargo_toml.write_all(CARGO_TOML.as_bytes())?;

    Ok(())
}

fn rustify_type_name(name: &str) -> Cow<'static, str> {
    match name {
        "bool" => Cow::Borrowed("bool"),
        "u32" => Cow::Borrowed("u32"),
        "string" => Cow::Borrowed("String"),
        other => other.to_camel_case().into(),
    }
}
