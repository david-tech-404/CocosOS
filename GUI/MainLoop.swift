final class MainLoop {

    static func run() {
        while true {
            switch KernelPanicBridge.poll() {
                case .running:
                    processUIEvents()
                    renderFrame()
                case .panic(let code):
                    KernelPanicScreen.show(code: code)
            }
        }
    }

    private static func processUIEvents() {
        RunLoop.current.run(mode: .default, before: Date())
    }

    private static func renderFrame() {
        // Render frame logic
    }
}
