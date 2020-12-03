use std::io::Read;
use std::fs::File;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut input = String::new();
    let mut res  = (0, 0);

    file.read_to_string(&mut input).unwrap();
    for line in input.lines(){
        let split:  Vec<&str> = line.split(":").collect();
        let rules:  Vec<&str> = split[0].split(" ").collect();
        let values: Vec<usize> = rules[0].split("-").map(|c| c.parse().unwrap()).collect();
        let pass = split[1].trim();

        let the_char = rules[1].chars().nth(0).unwrap();
        let count = pass.chars().filter(|c| *c == the_char).count();
        if count >= values[0] && count <= values[1] {
           res.0 += 1;
        }

        let mut enc = false;
        for c in [pass.chars().nth(values[0] -1).unwrap(), pass.chars().nth(values[1] -1).unwrap()].iter() {
            if *c == the_char {
                enc = !enc;
            }
        }
        res.1 += enc as u32;
    }
    println!("{} valid", res.0);
    println!("{} real valid", res.1);
}
