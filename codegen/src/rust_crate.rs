use crate::{Api, CrateResult};
use heck::SnakeCase;
use std::{borrow::Cow, fs::File, io::Write as _, path::Path};

pub(crate) fn generate_rust_crate(out_dir: &Path, api: &Api) -> CrateResult {
    let src_dir = out_dir.join("src");
    std::fs::create_dir(&src_dir)?;
    generate_librs(&src_dir, api)?;
    generate_typesrs(&src_dir, api)?;
    Ok(())
}

fn generate_librs(src_dir: &Path, api: &Api) -> CrateResult {
    let librs = src_dir.join("lib.rs");
    let mut librs = File::create(&librs)?;
    let mut method_names: Vec<&str> = api.methods.keys().map(String::as_str).collect();
    method_names.sort();

    for method_name in &method_names {
        writeln!(librs, "mod {};", method_name)?;
    }

    writeln!(librs, "\n\nconst METHOD_NAMES: &[&str] = &[")?;

    for method_name in &method_names {
        writeln!(librs, "    \"{}\",", method_name)?;
    }

    writeln!(librs, "];")?;

    Ok(())
}

fn generate_typesrs(src_dir: &Path, api: &Api) -> CrateResult {
    let typesrs = src_dir.join("types.rs");
    let mut typesrs = File::create(&typesrs)?;

    for (type_name, record_type) in &api.record_shapes {
        if let Some(description) = &record_type.description {
            for line in description.lines() {
                writeln!(typesrs, "/// {}", line)?;
            }
        }

        writeln!(
            typesrs,
            "#[derive(Serialize, Deserialize])]\npub struct {} {{",
            rustify_type_name(type_name)
        )?;
        for (field_name, field) in &record_type.fields {
            if let Some(description) = &field.description {
                for line in description.lines() {
                    writeln!(typesrs, "    /// {}", line)?;
                }
            }
            let type_name = rustify_type_name(&field.shape);
            let field_name_sc = field_name.to_snake_case();
            if &field_name_sc != field_name {
                writeln!(typesrs, "    #[serde(rename = \"{}\")]", field_name)?;
            }

            // let type_name = match field.shape.as_str() {
            //     "U32" => "u32",
            //     "Bool" => "bool",
            //     other => other.to_snake_case(),
            // };

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

        for (variant_name, variant_type) in &variants.variants {
            match variant_type {
                Some(variant) => {
                    if let Some(description) = &variant.description {
                        for line in description.lines() {
                            writeln!(typesrs, "    /// {}", line)?;
                        }

                        if let Some(shape) = &variant.shape {
                            writeln!(
                                typesrs,
                                "    {}({}),",
                                variant_name,
                                rustify_type_name(shape)
                            )?;
                        } else {
                            writeln!(typesrs, "    {}", variant_name)?;
                        }
                    }
                }
                None => {
                    writeln!(typesrs, "    {},", variant_name)?;
                }
            };
        }

        writeln!(typesrs, "}}\n")?;
    }

    Ok(())
}

fn rustify_type_name(name: &str) -> Cow<'static, str> {
    use heck::CamelCase;

    match name {
        "U32" => "u32".into(),
        "Bool" => "bool".into(),
        other => other.to_camel_case().into(),
    }
}
