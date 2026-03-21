final class KernelPanicScreen {

    static func show(code: Int)
{
    Screen.clear(.black)
    Screen.drawText("CRITICAL ERROR: KERNEL PANIC", color: .red)
    Screen.drawText("Code: \(code)")
    Screen.drawText("System halted.")

PanicSound.playMorseKernelPanic()

    freeze()
}

    private static func freeze() {
        while true {


RunLoop.current.run()
        }
    }
}