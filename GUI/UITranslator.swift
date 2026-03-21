import SwiftUI

@ViewBuilder
func translate(_ element: UIElemnt) -> some View {
    switch element.type {

        case "text":
        Button(element.text ?? "Button") {
            ActionDispatcher.call(element.action)
        }
        case "panel":
            VStack {
                Text(element.value ?? "")
            }
            .padding()

        default:
            EmptyView()
    }
}