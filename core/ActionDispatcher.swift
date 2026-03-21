enum ActionDispatcher {
    static func call(_ action: String?) {
        guard let action
        else { return }

            switch action {
                case "installl_app":

    Kernel.shared.installApp()
        default:
            print("Accion desconocida:", action)
            }
    }
}