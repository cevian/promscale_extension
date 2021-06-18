use std::ptr::null_mut;

use pgx::pg_sys;

// TODO move to func_utils once there are enough function to warrant one
#[allow(dead_code)]
pub unsafe fn get_collation(fcinfo: pg_sys::FunctionCallInfo) -> Option<pg_sys::Oid> {
    if (*fcinfo).fncollation == 0 {
        None
    } else {
        Some((*fcinfo).fncollation)
    }
}

pub unsafe fn in_aggregate_context<T, F: FnOnce() -> T>(
    fcinfo: pg_sys::FunctionCallInfo,
    f: F,
) -> T {
    let mctx =
        aggregate_mctx(fcinfo).unwrap_or_else(|| pgx::error!("cannot call as non-aggregate"));
    crate::palloc::in_memory_context(mctx, f)
}

pub fn aggregate_mctx(fcinfo: pg_sys::FunctionCallInfo) -> Option<pg_sys::MemoryContext> {
    let mut mctx = null_mut();
    let is_aggregate = unsafe { pg_sys::AggCheckCallContext(fcinfo, &mut mctx) };
    if is_aggregate == 0 {
        return None;
    } else {
        debug_assert!(!mctx.is_null());
        return Some(mctx);
    }
}
