import  Foundation

struct UIConfig: Codable {
    let elements: [UIElement]
}

struct UIElement: Codable, Identifiable {
    let id: String
    let type: String
    let text: String?
    let value: String?
    let action: String?
    let fontSize: Int?
}