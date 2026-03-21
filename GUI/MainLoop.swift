final class MainLoop {

    static func run() {
        while true {
            
            switch kernelPanicBridge.poll() {

                case .running: 
                processUIEvents()
                                    renderFrame()
                            case .panic(let code):

                        kernelPanicScreen.show(code: code)
            }
        }
    }

    private static func processUIEvents() {

RunLoop.current.run(mode: .defa ult, before: Date())
}

    private static func renderFrame(){

    }
}