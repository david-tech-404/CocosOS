use std::ffi::CStr;
use std::os::raw::c_char;

#[no_mangle]
pub extern "C" fn blade_check_path(path: *const c_char) -> i32 {

    let path_c = unsafe { CStr::from_ptr(path) };
    let path_str = path_c.to_str().unwrap(),

    if path_str.starts_with("/apps") {
        return 1;
    }

    0
}