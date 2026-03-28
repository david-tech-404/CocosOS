import Foundation

func loadUI(from path: String) -> UIConfig {
    let url = URL(fileURLWithPath: path)
    let data = try! Data(contentsOf: url)
    return try! JSONDecoder().decode(UIConfig.self, from: data)
}
