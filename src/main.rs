#[derive(Debug, serde::Deserialize)]
struct Row {
    time: f32,
    _a: u8,
    _b: f32,
    _c: f32,
    displacement: f32,
    _d: f32,
    force: f32,
    _e: f32,
    _f: f32,
    _g: f32,
}

fn main() {
    let dir = rfd::FileDialog::new().pick_folder().unwrap();
    let mut builder = csv::ReaderBuilder::new();
    builder.delimiter(b'\t');
    let mut writer =
        csv::Writer::from_writer(std::fs::File::create(dir.join("hold times.csv")).unwrap());
    writer.write_record(&["var", "hold time"]).unwrap();
    for entry in std::fs::read_dir(dir).unwrap() {
        let entry = entry.unwrap();
        let path = entry.path();
        let stem = path.file_stem().unwrap().to_str().unwrap().to_owned();
        if !stem.starts_with("2013") {
            continue;
        }
        let prehold = stem.split(' ').last().unwrap();
        let mut reader = builder.from_reader(std::fs::File::open(path).unwrap());
        let data: Vec<Row> = reader
            .records()
            .map(|rec| rec.unwrap().deserialize(None).unwrap())
            .collect();
        // for constant force where peaks aren't obvious (and time was recorded)
        // let time = 11.0 + dbg!(prehold).parse::<f32>().unwrap();
        // for differing constant force
        /*
        let mut lookup = std::collections::BTreeMap::new();
        // non-rough
        // lookup.insert("2", 1.3);
        // lookup.insert("4", 1.8);
        // rough
        lookup.insert("1", 1.0);
        lookup.insert("2", 1.2);
        lookup.insert("4", 1.7);

        lookup.insert("6", 2.3);
        lookup.insert("8", 3.0);
        lookup.insert("10", 3.7);
        lookup.insert("12", 4.8);
        let time = 11.5 + lookup[dbg!(prehold)];
        let (pos, max) = data
            .iter()
            .enumerate()
            .find(|(_, row)| row.time > time)
            .unwrap();
        */
        let (pos, max) = data
            .iter()
            .enumerate()
            .max_by_key(|(_, row)| ordered_float::OrderedFloat(row.force))
            .unwrap();
        let Some(end) = (data[pos..]).iter().find(|rec| rec.force < 150.0) else {
            println!(
                "lowest force found for {:?} was {}",
                stem,
                data[pos..]
                    .iter()
                    .min_by_key(|rec| ordered_float::OrderedFloat(rec.force))
                    .unwrap()
                    .force
            );
            continue;
        };
        let hold = end.time - max.time;
        writer.write_record(&[prehold, &hold.to_string()]).unwrap();
    }
    writer.flush().unwrap();
}
