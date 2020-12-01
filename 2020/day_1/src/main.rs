use std::io::Read;
use std::fs::File;

fn main() {
    let mut file = File::open("input.txt").unwrap();
    let mut input = String::new();
    let mut res = 0;

    file.read_to_string(&mut input).unwrap();
    let input: Vec<i32> = input.lines().map(|x| x.parse().unwrap()).collect();

    for i in &input {
        for j in &input {
            if i + j == 2020 {
                res = i * j;
            }
        }
    }
    println!("2 Sums: {}", res);

    for i in &input {
        for j in &input {
            for k in &input {
                if i + j + k == 2020 {
                    res = i * j * k;
                }
            }
        }
    }
    println!("3 Sums: {}", res);
}
