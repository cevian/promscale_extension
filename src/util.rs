use pgx_macros::pg_extern;

#[pg_extern(immutable)]
pub fn num_cpus() -> i32 {
    num_cpus::get() as i32
}