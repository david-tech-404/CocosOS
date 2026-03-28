import Foundation

print("¿qué querés preguntar?")
if let userInput = readLine() {
    let command: [String: String] = ["command": userInput]
    if let jsonData = try? JSONSerialization.data(withJSONObject: command) {
        try? jsonData.write(to: URL(fileURLWithPath: "request.json"))
    }
}

if let data = try? Data(contentsOf: URL(fileURLWithPath: "response.json")),
   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
    if let result = json["result"] as? String {
        print("Swift recibe: \(result)")
    }
} else {
    print("ERROR 503: no se pudo leer el archivo response.json")
}
