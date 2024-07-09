// divisors calculates the number of divisors of n
fn divisors(n: u32) -> u32 {
    let mut count = 0;
    for i in 1..=(n as f64).sqrt() as u32 {
        if n % i == 0 {
            if i * i == n {
                count += 1;
            } else {
                count += 2;
            }
        }
    }

    count
}

// divisors_simple is a simple, concise function
fn divisors_simple(n: u32) -> u32 {
    (1..=n).filter(|x| n % x == 0).count() as u32
}

use std::time::Instant;

fn main() {
    let n = 500000;
    let count = divisors(n);
    println!("The number of divisors of {} is {}", n, count);

    let mut start = Instant::now();

    let n = 500000;
    let _count = divisors(n);

    let duration = start.elapsed();
    println!("Time taken with divisors: {:?}", duration);

    start = Instant::now();

    let n = 500000;
    let _count = divisors_simple(n);

    let duration = start.elapsed();
    println!("Time taken with divisors_simple: {:?}", duration);
}
