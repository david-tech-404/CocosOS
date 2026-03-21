import Foundation

func loadUI(from path: String) -> UIConfig {
    let URL(fileURLWithPath: path)
    let data = try!
Data(contentsOF: url)
    return try!
    JSONDecoder().decode(UIConfig.self, from: data)
}