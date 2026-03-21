import SwiftUI

struct EngineView: View {
    let ui = loadUI(from: "ui.json")

    var body: some View {
        VStack {

ForEach(ui.elements) {
el in translate(el)    


            }
        }
    }
}