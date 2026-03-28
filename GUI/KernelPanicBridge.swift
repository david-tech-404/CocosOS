@_silgen_name("kernel_panic_state")
var kernelPanicState: Int32

@_silgen_name("kernel_panic_code")
var kernelPanicCode: Int32

enum KernelState {
    case running
    case panic(Int)
}

final class KernelPanicBridge {

    static func poll() -> KernelState {
        if kernelPanicState != 0 {
            return .panic(Int(kernelPanicCode))
        }
        return .running
    }
}
