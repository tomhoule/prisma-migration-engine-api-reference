use super::{Api, RecordShape};
use crate::CrateResult;
use std::{borrow::Cow, fmt::Write as _, fs::File, io::Write as _, path::Path};

pub(crate) fn generate_md_docs(out_dir: &Path, api: &Api) -> CrateResult {
    let engine_methods_out_dir = out_dir.join("engine-methods");
    std::fs::create_dir(&engine_methods_out_dir)?;
    generate_engine_method_docs(&engine_methods_out_dir, api)?;
    let shapes_out_dir = out_dir.join("shapes");
    std::fs::create_dir(&shapes_out_dir)?;
    generate_shape_docs(&shapes_out_dir, api)
}

fn generate_engine_method_docs(out_dir: &Path, api: &Api) -> CrateResult {
    let mut md_contents = String::with_capacity(1000);
    let mut file_name = String::with_capacity(50);

    for (method_name, method) in &api.methods {
        let description = method
            .description
            .as_ref()
            .map(String::as_str)
            .unwrap_or("");

        writeln!(
            md_contents,
            "# {method_name}\n\n{description}\n\n",
            method_name = method_name,
            description = description,
        )?;

        writeln!(
            md_contents,
            "## Request shape\n\nName: {input_type}\n",
            input_type = method.request_shape,
        )?;

        let input_shape = &api.record_shapes[&method.request_shape];

        render_record_fields(input_shape, &mut md_contents)?;

        writeln!(
            md_contents,
            "## Response shape\n\nName: {output_type}\n",
            output_type = method.response_shape,
        )?;

        let output_shape = &api.record_shapes[&method.response_shape];

        render_record_fields(output_shape, &mut md_contents)?;

        file_name.push_str(method_name);
        file_name.push_str(".md");
        let mut file = File::create(out_dir.join(&file_name))?;
        file.write_all(md_contents.as_bytes())?;
        md_contents.clear();
        file_name.clear();
    }

    Ok(())
}

fn generate_shape_docs(out_dir: &Path, api: &Api) -> CrateResult {
    let mut md_contents = String::with_capacity(1000);
    let mut file_name = String::with_capacity(50);

    for (record_name, record_shape) in &api.record_shapes {
        writeln!(md_contents, "# {record_name}", record_name = record_name)?;
        render_record_fields(&record_shape, &mut md_contents)?;

        let mut file_path = out_dir.join(record_name);
        file_path.set_extension("md");
        let mut file = File::create(&file_path)?;
        file.write_all(md_contents.as_bytes())?;
        file_name.clear();
        md_contents.clear();
    }

    for (enum_name, enum_shape) in &api.enum_shapes {
        ["# ", enum_name.as_str(), "\n\n"]
            .iter()
            .for_each(|s| md_contents.push_str(s));

        render_enum_variants(enum_shape, &mut md_contents)?;

        let mut file_path = out_dir.join(enum_name);
        file_path.set_extension("md");
        let mut file = File::create(&file_path)?;
        file.write_all(md_contents.as_bytes())?;

        file_name.clear();
        md_contents.clear();
    }

    Ok(())
}

fn render_record_fields(shape: &RecordShape, md_contents: &mut String) -> CrateResult {
    for (field_name, field) in &shape.fields {
        writeln!(
            md_contents,
            "- {}: [{}](../shapes/{}.md)\n",
            field_name, field.shape, field.shape
        )?;

        if let Some(description) = &field.description {
            for line in description.lines() {
                md_contents.push_str("  ");
                md_contents.push_str(line);
                md_contents.push('\n');
            }
        }

        md_contents.push_str("\n\n");
    }

    Ok(())
}

fn render_enum_variants(variants: &crate::EnumShape, md_contents: &mut String) -> CrateResult {
    if let Some(description) = &variants.description {
        md_contents.push_str(&description);
        md_contents.push_str("\n\n");
    }

    for (variant_name, variant) in &variants.variants {
        match variant {
            Some(crate::EnumVariant { description, shape }) => {
                let description = description
                    .as_ref()
                    .map(|desc| {
                        desc.lines()
                            .map(|line| format!("  {}", line))
                            .collect::<String>()
                    })
                    .unwrap_or("".into());

                [
                    "- Variant __",
                    variant_name,
                    "__: [",
                    &shape,
                    "](../",
                    &shape,
                    ".md)\n\n",
                    &description,
                    "\n\n",
                ]
                .iter()
                .for_each(|fragment| md_contents.push_str(fragment))
            }
            None => ["- Variant __", variant_name, "__: <no data>\n\n"]
                .iter()
                .for_each(|fragment| md_contents.push_str(fragment)),
        }
    }

    Ok(())
}
