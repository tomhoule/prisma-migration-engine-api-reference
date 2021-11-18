use super::{Api, RecordShape};
use std::{fmt::Write as _, fs::File, io::Write as _, path::Path};

pub(crate) fn generate_md_docs(out_dir: &Path, api: &Api) {
    let engine_methods_out_dir = out_dir.join("engine-methods");
    std::fs::create_dir(&engine_methods_out_dir).unwrap();
    generate_engine_method_docs(&engine_methods_out_dir, api);
    let shapes_out_dir = out_dir.join("shapes");
    std::fs::create_dir(&shapes_out_dir).unwrap();
    generate_shape_docs(&shapes_out_dir, api);
}

fn generate_engine_method_docs(out_dir: &Path, api: &Api) {
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
        )
        .unwrap();

        writeln!(
            md_contents,
            "## Request shape\n\nName: {input_type}\n",
            input_type = method.request_shape,
        )
        .unwrap();

        let input_shape = &api.record_shapes[&method.request_shape];

        render_record_fields(input_shape, &mut md_contents, api);

        writeln!(
            md_contents,
            "## Response shape\n\nName: {output_type}\n",
            output_type = method.response_shape,
        )
        .unwrap();

        let output_shape = &api.record_shapes[&method.response_shape];

        render_record_fields(output_shape, &mut md_contents, api);

        file_name.push_str(method_name);
        file_name.push_str(".md");
        let mut file = File::create(out_dir.join(&file_name)).unwrap();
        file.write_all(md_contents.as_bytes()).unwrap();
        md_contents.clear();
        file_name.clear();
    }
}

fn generate_shape_docs(out_dir: &Path, api: &Api) {
    let mut md_contents = String::with_capacity(1000);
    let mut file_name = String::with_capacity(50);

    for (record_name, record_shape) in &api.record_shapes {
        writeln!(md_contents, "# {record_name}", record_name = record_name).unwrap();

        render_record_fields(&record_shape, &mut md_contents, api);

        let mut file_path = out_dir.join(record_name);
        file_path.set_extension("md");
        let mut file = File::create(&file_path).unwrap();
        file.write_all(md_contents.as_bytes()).unwrap();
        file_name.clear();
        md_contents.clear();
    }

    for (enum_name, enum_shape) in &api.enum_shapes {
        let mut file_path = out_dir.join(enum_name);
        file_path.set_extension("md");

        file_name.clear();
        md_contents.clear();
    }
}

fn render_record_fields(shape: &RecordShape, md_contents: &mut String, api: &Api) {
    for (field_name, field) in &shape.fields {
        writeln!(
            md_contents,
            "- {}: [{}](../shapes/{}.md)\n",
            field_name, field.shape, field.shape
        )
        .unwrap();

        if let Some(description) = &field.description {
            for line in description.lines() {
                md_contents.push_str("  ");
                md_contents.push_str(line);
                md_contents.push('\n');
            }
        }

        md_contents.push_str("\n\n");
    }
}
