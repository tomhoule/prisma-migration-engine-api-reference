use crate::Api;
use std::{fs::File, io::Write as _, path::Path};

pub(crate) fn generate_rust_crate(out_dir: &Path, api: &Api) {
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

    // for (type_name, variants) in &api.enum_shapes {
    //     todo!()
    // }
}
