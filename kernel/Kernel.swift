import Foundation
import CommonCrypto

final class Kernel {
    static let shared = Kernel()
    
    private let processManager: ProcessManager
    private let memoryManager: MemoryManager
    private let deviceManager: DeviceManager
    private let fileSystem: FileSystem
    private let ipcManager: IPCManager
    private let encryptionManager: EncryptionManager
    
    private init() {
        self.processManager = ProcessManager()
        self.memoryManager = MemoryManager()
        self.deviceManager = DeviceManager()
        self.fileSystem = FileSystem()
        self.ipcManager = IPCManager()
        self.encryptionManager = EncryptionManager()
        initializeSubsystems()
    }
    
    private func initializeSubsystems() {
        print("Inicializando kernel...")
        deviceManager.registerStandardDevices()
        
        let mainProcess = Process(
            pid: ProcessId.current,
            name: "kernel_gui",
            state: .running,
            memoryUsage: memoryManager.getProcessMemoryUsage(),
            createTime: Date()
        )
        processManager.registerProcess(mainProcess)
        print("Kernel inicializado exitosamente")
    }
    
    func createProcess(_ name: String, _ entryPoint: @escaping () -> Void) -> Process? {
        return processManager.createProcess(name: name, entryPoint: entryPoint)
    }
    
    func terminateProcess(_ pid: Int32) -> Bool {
        return processManager.terminateProcess(pid: pid)
    }
    
    func listProcesses() -> [Process] {
        return processManager.listProcesses()
    }
    
    func getCurrentProcess() -> Process? {
        return processManager.getProcess(pid: ProcessId.current)
    }
    
    func allocateMemory(_ size: Int) -> UnsafeMutableRawPointer? {
        return memoryManager.allocate(size: size)
    }
    
    func deallocateMemory(_ pointer: UnsafeMutableRawPointer) {
        memoryManager.deallocate(pointer: pointer)
    }
    
    func getMemoryUsage() -> MemoryUsage {
        return memoryManager.getUsage()
    }
    
    func registerDevice(_ device: Device) -> Bool {
        return deviceManager.register(device: device)
    }
    
    func getDevice(_ name: String) -> Device? {
        return deviceManager.getDevice(name: name)
    }
    
    func listDevices() -> [Device] {
        return deviceManager.listDevices()
    }
    
    func createFile(_ path: String, _ content: Data) -> Bool {
        return fileSystem.createFile(path: path, content: content)
    }
    
    func readFile(_ path: String) -> Data? {
        return fileSystem.readFile(path: path)
    }
    
    func deleteFile(_ path: String) -> Bool {
        return fileSystem.deleteFile(path: path)
    }
    
    func listDirectory(_ path: String) -> [String] {
        return fileSystem.listDirectory(path: path)
    }
    
    func fileExists(_ path: String) -> Bool {
        return fileSystem.fileExists(path: path)
    }
    
    func sendMessage(_ from: Int32, _ to: Int32, _ message: IPCMessage) -> Bool {
        return ipcManager.sendMessage(from: from, to: to, message: message)
    }
    
    func receiveMessage(_ pid: Int32) -> IPCMessage? {
        return ipcManager.receiveMessage(pid: pid)
    }
    
    func checkPermission(_ pid: Int32, _ resource: String, _ operation: String) -> Bool {
        guard let process = processManager.getProcess(pid: pid) else { return false }
        if pid == ProcessId.current { return true }
        
        switch resource {
        case "filesystem":
            return operation == "read" || process.name.hasPrefix("app_")
        case "device":
            return operation == "read"
        case "memory":
            return true
        default:
            return false
        }
    }
    
    func installApp(from path: String) -> Bool {
        guard let appData = readFile(path) else { return false }
        let appName = (path as NSString).lastPathComponent
        let appDir = "/apps/\(appName)"
        
        if !fileExists(appDir) {
            _ = createFile("\(appDir)/.dir", Data())
        }
        
        if createFile("\(appDir)/main.lua", appData) {
            let appProcess = Process(
                pid: Int32.random(in: 1000...9999),
                name: "app_\(appName)",
                state: .waiting,
                memoryUsage: appData.count,
                createTime: Date()
            )
            processManager.registerProcess(appProcess)
            return true
        }
        return false
    }
    
    func installApp() {
        print("Instalando aplicación...")
        let currentPath = FileManager.default.currentDirectoryPath
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: currentPath)
            let luaFiles = files.filter { $0.hasSuffix(".lua") }
            for luaFile in luaFiles {
                let fullPath = "\(currentPath)/\(luaFile)"
                if installApp(from: fullPath) {
                    print("Aplicación \(luaFile) instalada")
                }
            }
        } catch {
            print("Error al buscar aplicaciones: \(error)")
        }
    }
    
    func getSystemStats() -> SystemStats {
        let processes = processManager.listProcesses()
        let memory = memoryManager.getUsage()
        let devices = deviceManager.listDevices()
        let activeProcesses = processes.filter { $0.state == .running }
        
        return SystemStats(
            uptime: Date().timeIntervalSince1970,
            processCount: processes.count,
            memoryUsage: memory,
            deviceCount: devices.count,
            cpuUsage: min(Double(activeProcesses.count) * 15.0, 100.0)
        )
    }
    
    func handleKernelPanic(_ message: String) {
        print("KERNEL PANIC: \(message)")
        encryptionManager.secureWipeMemory()
        saveSystemState()
        fatalError("Kernel panic occurred: \(message)")
    }
    
    private func saveSystemState() {
        let state: [String: Any] = [
            "timestamp": Date().timeIntervalSince1970,
            "processes": processManager.listProcesses().map { $0.toDictionary() },
            "memory": memoryManager.getUsage().toDictionary(),
            "devices": deviceManager.listDevices().map { $0.name }
        ]
        if let data = try? JSONSerialization.data(withJSONObject: state, options: .prettyPrinted) {
            _ = createFile("/var/log/kernel_state.json", data)
        }
    }
}

struct Process {
    let pid: Int32
    let name: String
    var state: ProcessState
    let memoryUsage: Int
    let createTime: Date
    
    func toDictionary() -> [String: Any] {
        return [
            "pid": pid,
            "name": name,
            "state": "\(state)",
            "memoryUsage": memoryUsage,
            "createTime": createTime.timeIntervalSince1970
        ]
    }
}

enum ProcessState {
    case running
    case waiting
    case terminated
    case zombie
}

struct MemoryUsage {
    let total: Int
    let used: Int
    let free: Int
    
    func toDictionary() -> [String: Any] {
        return [
            "total": total,
            "used": used,
            "free": free,
            "usagePercent": Double(used) / Double(total) * 100.0
        ]
    }
}

protocol Device {
    var name: String { get }
    var type: DeviceType { get }
    func read() -> Data?
    func write(_ data: Data) -> Bool
    func getStatus() -> DeviceStatus
}

enum DeviceType {
    case storage
    case network
    case input
    case output
    case display
    case audio
}

enum DeviceStatus {
    case online
    case offline
    case error(String)
}

struct SystemStats {
    let uptime: TimeInterval
    let processCount: Int
    let memoryUsage: MemoryUsage
    let deviceCount: Int
    let cpuUsage: Double
}

struct IPCMessage {
    let id: String
    let payload: Data
    let timestamp: Date
}

enum ProcessId {
    static var current: Int32 {
        return Int32(ProcessInfo.processInfo.processIdentifier)
    }
}

class ProcessManager {
    private var processes: [Int32: Process] = [:]
    private var nextPid: Int32 = 1000
    
    func createProcess(name: String, entryPoint: @escaping () -> Void) -> Process? {
        let pid = nextPid
        nextPid += 1
        
        let process = Process(
            pid: pid,
            name: name,
            state: .running,
            memoryUsage: 0,
            createTime: Date()
        )
        processes[pid] = process
        
        DispatchQueue.global(qos: .userInitiated).async {
            entryPoint()
            DispatchQueue.main.async {
                self.processes[pid]?.state = .terminated
            }
        }
        return process
    }
    
    func terminateProcess(pid: Int32) -> Bool {
        guard var process = processes[pid] else { return false }
        process.state = .terminated
        processes[pid] = process
        return true
    }
    
    func listProcesses() -> [Process] {
        return Array(processes.values)
    }
    
    func getProcess(pid: Int32) -> Process? {
        return processes[pid]
    }
    
    func registerProcess(_ process: Process) {
        processes[process.pid] = process
    }
}

class MemoryManager {
    private var allocatedBlocks: [UnsafeMutableRawPointer: Int] = [:]
    private let totalMemory: Int
    
    init() {
        let processInfo = ProcessInfo.processInfo
        self.totalMemory = processInfo.physicalMemory > 0 ? Int(processInfo.physicalMemory) : 1024 * 1024 * 1024
    }
    
    func allocate(size: Int) -> UnsafeMutableRawPointer? {
        guard size > 0 else { return nil }
        let pointer = UnsafeMutableRawPointer.allocate(byteCount: size, alignment: MemoryLayout<UInt8>.alignment)
        allocatedBlocks[pointer] = size
        return pointer
    }
    
    func deallocate(pointer: UnsafeMutableRawPointer) {
        allocatedBlocks.removeValue(forKey: pointer)
        pointer.deallocate()
    }
    
    func getUsage() -> MemoryUsage {
        let used = allocatedBlocks.values.reduce(0, +)
        return MemoryUsage(total: totalMemory, used: used, free: totalMemory - used)
    }
    
    func getProcessMemoryUsage() -> Int {
        return allocatedBlocks.values.reduce(0, +)
    }
}

class DeviceManager {
    private var devices: [String: Device] = [:]
    
    func register(device: Device) -> Bool {
        devices[device.name] = device
        return true
    }
    
    func getDevice(name: String) -> Device? {
        return devices[name]
    }
    
    func listDevices() -> [Device] {
        return Array(devices.values)
    }
    
    func registerStandardDevices() {
        register(device: HostStorageDevice(name: "sda", path: "/"))
        register(device: HostInputDevice(name: "stdin"))
        register(device: HostOutputDevice(name: "stdout"))
        register(device: HostDisplayDevice(name: "display0"))
    }
}

class FileSystem {
    private let fileManager = FileManager.default
    private var virtualFiles: [String: Data] = [:]
    
    func createFile(path: String, content: Data) -> Bool {
        if path.hasPrefix("/") {
            virtualFiles[path] = content
            return true
        }
        do {
            try content.write(to: URL(fileURLWithPath: path))
            return true
        } catch {
            return false
        }
    }
    
    func readFile(path: String) -> Data? {
        if path.hasPrefix("/") {
            return virtualFiles[path]
        }
        return fileManager.contents(atPath: path)
    }
    
    func deleteFile(path: String) -> Bool {
        if path.hasPrefix("/") {
            virtualFiles.removeValue(forKey: path)
            return true
        }
        do {
            try fileManager.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    
    func listDirectory(path: String) -> [String] {
        if path.hasPrefix("/") {
            return virtualFiles.keys
                .filter { $0.hasPrefix(path) && $0 != path }
                .map { String($0.dropFirst(path.count).split(separator: "/").first ?? "") }
                .filter { !$0.isEmpty }
                .unique()
        }
        do {
            return try fileManager.contentsOfDirectory(atPath: path)
        } catch {
            return []
        }
    }
    
    func fileExists(path: String) -> Bool {
        if path.hasPrefix("/") {
            return virtualFiles[path] != nil
        }
        return fileManager.fileExists(atPath: path)
    }
}

class IPCManager {
    private var messageQueues: [Int32: [IPCMessage]] = [:]
    private let queue = DispatchQueue(label: "ipc_manager", attributes: .concurrent)
    
    func sendMessage(from: Int32, to: Int32, message: IPCMessage) -> Bool {
        queue.async(flags: .barrier) {
            if self.messageQueues[to] == nil {
                self.messageQueues[to] = []
            }
            self.messageQueues[to]?.append(message)
        }
        return true
    }
    
    func receiveMessage(pid: Int32) -> IPCMessage? {
        var message: IPCMessage?
        queue.sync {
            message = messageQueues[pid]?.first
            if message != nil {
                messageQueues[pid]?.removeFirst()
            }
        }
        return message
    }
}

struct HostStorageDevice: Device {
    let name: String
    let path: String
    var type: DeviceType { .storage }
    
    func read() -> Data? {
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }
    
    func write(_ data: Data) -> Bool {
        do {
            try data.write(to: URL(fileURLWithPath: path))
            return true
        } catch {
            return false
        }
    }
    
    func getStatus() -> DeviceStatus {
        return FileManager.default.fileExists(atPath: path) ? .online : .offline
    }
}

struct HostInputDevice: Device {
    let name: String
    var type: DeviceType { .input }
    
    func read() -> Data? {
        return nil
    }
    
    func write(_ data: Data) -> Bool {
        return false
    }
    
    func getStatus() -> DeviceStatus {
        return .online
    }
}

struct HostOutputDevice: Device {
    let name: String
    var type: DeviceType { .output }
    
    func read() -> Data? {
        return nil
    }
    
    func write(_ data: Data) -> Bool {
        if let string = String(data: data, encoding: .utf8) {
            print(string, terminator: "")
            return true
        }
        return false
    }
    
    func getStatus() -> DeviceStatus {
        return .online
    }
}

struct HostDisplayDevice: Device {
    let name: String
    var type: DeviceType { .display }
    
    func read() -> Data? {
        return nil
    }
    
    func write(_ data: Data) -> Bool {
        return true
    }
    
    func getStatus() -> DeviceStatus {
        return .online
    }
}

extension Array where Element: Hashable {
    func unique() -> [Element] {
        return Array(Set(self))
    }
}

class EncryptionManager {
    private var masterKey: Data?
    private var encryptedVolumes: [String: EncryptedVolume] = [:]
    
    init() {
        generateMasterKey()
    }
    
    private func generateMasterKey() {
        var keyData = Data(count: 32)
        _ = keyData.withUnsafeMutableBytes { pointer in
            SecRandomCopyBytes(kSecRandomDefault, 32, pointer.baseAddress!)
        }
        self.masterKey = keyData
    }
    
    func encryptFile(_ path: String, _ data: Data) -> Data? {
        guard let key = masterKey else { return nil }
        
        var iv = Data(count: 16)
        _ = iv.withUnsafeMutableBytes { pointer in
            SecRandomCopyBytes(kSecRandomDefault, 16, pointer.baseAddress!)
        }
        
        let encrypted = encryptAES256(data, key: key, iv: iv)
        var result = iv
        result.append(encrypted)
        return result
    }
    
    func decryptFile(_ path: String, _ encryptedData: Data) -> Data? {
        guard let key = masterKey else { return nil }
        guard encryptedData.count > 16 else { return nil }
        
        let iv = encryptedData.prefix(16)
        let data = encryptedData.dropFirst(16)
        return decryptAES256(data, key: key, iv: iv)
    }
    
    func createEncryptedVolume(_ name: String, size: Int) -> Bool {
        let volume = EncryptedVolume(name: name, size: size)
        encryptedVolumes[name] = volume
        return true
    }
    
    func mountEncryptedVolume(_ name: String, password: String) -> Bool {
        guard var volume = encryptedVolumes[name] else { return false }
        return volume.unlock(password: password)
    }
    
    func unmountEncryptedVolume(_ name: String) -> Bool {
        guard var volume = encryptedVolumes[name] else { return false }
        volume.lock()
        return true
    }
    
    func secureWipeMemory() {
        guard let key = masterKey else { return }
        var zeroKey = Data(count: key.count)
        _ = zeroKey.withUnsafeMutableBytes { pointer in
            memset(pointer.baseAddress!, 0, key.count)
        }
        self.masterKey = zeroKey
    }
    
    private func encryptAES256(_ data: Data, key: Data, iv: Data) -> Data {
        let bufferSize = data.count + kCCBlockSizeAES128
        var buffer = Data(count: bufferSize)
        var numBytesEncrypted: size_t = 0
        
        let status = key.withUnsafeBytes { keyBytes in
            iv.withUnsafeBytes { ivBytes in
                data.withUnsafeBytes { dataBytes in
                    CCCrypt(
                        CCOperation(kCCEncrypt),
                        CCAlgorithm(kCCAlgorithmAES),
                        CCOptions(kCCOptionPKCS7Padding),
                        keyBytes.baseAddress!,
                        kCCKeySizeAES256,
                        ivBytes.baseAddress!,
                        dataBytes.baseAddress!,
                        data.count,
                        buffer.withUnsafeMutableBytes { $0.baseAddress! },
                        bufferSize,
                        &numBytesEncrypted
                    )
                }
            }
        }
        
        guard status == kCCSuccess else { return Data() }
        buffer.removeSubrange(numBytesEncrypted..<buffer.count)
        return buffer
    }
    
    private func decryptAES256(_ data: Data, key: Data, iv: Data) -> Data {
        let bufferSize = data.count + kCCBlockSizeAES128
        var buffer = Data(count: bufferSize)
        var numBytesDecrypted: size_t = 0
        
        let status = key.withUnsafeBytes { keyBytes in
            iv.withUnsafeBytes { ivBytes in
                data.withUnsafeBytes { dataBytes in
                    CCCrypt(
                        CCOperation(kCCDecrypt),
                        CCAlgorithm(kCCAlgorithmAES),
                        CCOptions(kCCOptionPKCS7Padding),
                        keyBytes.baseAddress!,
                        kCCKeySizeAES256,
                        ivBytes.baseAddress!,
                        dataBytes.baseAddress!,
                        data.count,
                        buffer.withUnsafeMutableBytes { $0.baseAddress! },
                        bufferSize,
                        &numBytesDecrypted
                    )
                }
            }
        }
        
        guard status == kCCSuccess else { return Data() }
        buffer.removeSubrange(numBytesDecrypted..<buffer.count)
        return buffer
    }
}

struct EncryptedVolume {
    let name: String
    let size: Int
    var isLocked: Bool = true
    var encryptionKey: Data?
    
    init(name: String, size: Int) {
        self.name = name
        self.size = size
    }
    
    mutating func unlock(password: String) -> Bool {
        let key = deriveKey(password: password)
        self.encryptionKey = key
        self.isLocked = false
        return true
    }
    
    mutating func lock() {
        self.encryptionKey = nil
        self.isLocked = true
    }
    
    private func deriveKey(password: String) -> Data {
        let salt = name.data(using: .utf8)!
        var derivedKey = Data(count: 32)
        
        _ = password.data(using: .utf8)!.withUnsafeBytes { passwordBytes in
            salt.withUnsafeBytes { saltBytes in
                derivedKey.withUnsafeMutableBytes { keyBytes in
                    CCKeyDerivationPBKDF(
                        CCPBKDFAlgorithm(kCCPBKDF2),
                        passwordBytes.baseAddress!,
                        password.count,
                        saltBytes.baseAddress!,
                        salt.count,
                        CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
                        10000,
                        keyBytes.baseAddress!,
                        32
                    )
                }
            }
        }
        
        return derivedKey
    }
}
