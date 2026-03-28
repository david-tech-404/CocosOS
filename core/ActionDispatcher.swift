enum ActionDispatcher {
    static func call(_ action: String?) {
        guard let action else { return }

        switch action {
            case "install_app":
                Kernel.shared.installApp()
            default:
                print("Acción desconocida:", action)
        }
    }
}
