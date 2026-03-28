import SwiftUI

struct EngineView: View {
    let ui = loadUI(from: "UI.json")

    var body: some View {
        VStack {
            ForEach(ui.elements) { el in
                translate(el)
            }
        }
    }
}
