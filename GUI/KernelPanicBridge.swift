@_silgen_name("kernel_panic_state")
var KernelPanicState: Int32

@_silgen_name("kernel_panic_code")
var KernelPanicCode: Int32

enum KernelState {
    case running
    case panic(Int)
}

final class KernelPanicBridge {

    static func poll() -> KernelState {
        if KernelPanicState != 0 {
return .panic(Int(KernelPanicCode))
        }
        return .running
    }
}