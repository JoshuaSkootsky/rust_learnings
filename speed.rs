// speed converts from km / h to cm / s, rounded down

const CM_PER_KM: f64 = 100000.;
const SECONDS_PER_HOUR: f64 = 3600.;

fn speed(s: f64) -> i64 {
    let cm_per_s = s * CM_PER_KM / SECONDS_PER_HOUR;

    // Round down to the nearest integer
    cm_per_s.floor() as i64
}

use std::time::Instant;

fn main() {
    let start = Instant::now();
    let speed = speed(100.0);
    let duration = start.elapsed();
    println!("Time taken: {:?}", duration);
    println!("100 km/h is {} cm/s", speed);
}
