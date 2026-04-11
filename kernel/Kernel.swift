import Foundation

final class Kernel {
    static let shared = Kernel()
    
    private var processManager: ProcessManager?
    private var memoryManager: MemoryManager?
    private var deviceManager: DeviceManager?
    private var fileSystem: FileSystem?
    
    private init() {
        initializeSubsystems()
    }
    
    private func initializeSubsystems() {
        print("Inicializando kernel...")
        
        memoryManager = MemoryManager()
        deviceManager = DeviceManager()
        fileSystem = FileSystem()
        processManager = ProcessManager()
        
        print("Kernel inicializado exitosamente")
    }
    
    func createProcess(_ name: String, _ entryPoint: @escaping () -> Void) -> Process? {
        return processManager?.createProcess(name: name, entryPoint: entryPoint)
    }
    
    func terminateProcess(_ pid: Int) -> Bool {
        return processManager?.terminateProcess(pid: pid) ?? false
    }
    
    func listProcesses() -> [Process] {
        return processManager?.listProcesses() ?? []
    }
    
    func allocateMemory(_ size: Int) -> UnsafeMutableRawPointer? {
        return memoryManager?.allocate(size: size)
    }
    
    func deallocateMemory(_ pointer: UnsafeMutableRawPointer) {
        memoryManager?.deallocate(pointer: pointer)
    }
    
    func getMemoryUsage() -> MemoryUsage {
        return memoryManager?.getUsage() ?? MemoryUsage(total: 0, used: 0, free: 0)
    }
    
    func registerDevice(_ device: Device) -> Bool {
        return deviceManager?.register(device: device) ?? false
    }
    
    func getDevice(_ name: String) -> Device? {
        return deviceManager?.getDevice(name: name)
    }
    
    func listDevices() -> [Device] {
        return deviceManager?.listDevices() ?? []
    }
    
    func createFile(_ path: String, _ content: Data) -> Bool {
        return fileSystem?.createFile(path: path, content: content) ?? false
    }
    
    func readFile(_ path: String) -> Data? {
        return fileSystem?.readFile(path: path)
    }
    
    func deleteFile(_ path: String) -> Bool {
        return fileSystem?.deleteFile(path: path) ?? false
    }
    
    func listDirectory(_ path: String) -> [String] {
        return fileSystem?.listDirectory(path: path) ?? []
    }
    
    func sendMessage(_ from: Int, _ to: Int, _ message: String) -> Bool {
        return processManager?.sendMessage(from: from, to: to, message: message) ?? false
    }
    
    func receiveMessage(_ pid: Int) -> String? {
        return processManager?.receiveMessage(from: pid)
    }
    
    func checkPermission(_ pid: Int, _ resource: String, _ operation: String) -> Bool {
        return processManager?.checkPermission(pid: pid, resource: resource, operation: operation) ?? false
    }
    
    func installApp() {
        print("Instalando aplicación...")
    }
    
    func handleKernelPanic(_ message: String) {
        print("KERNEL PANIC: \(message)")
        fatalError("Kernel panic occurred")
    }
    
    func getSystemStats() -> SystemStats {
        let processes = processManager?.listProcesses() ?? []
        let memory = memoryManager?.getUsage() ?? MemoryUsage(total: 0, used: 0, free: 0)
        let devices = deviceManager?.listDevices() ?? []
        
        return SystemStats(
            uptime: Date().timeIntervalSince1970,
            processCount: processes.count,
            memoryUsage: memory,
            deviceCount: devices.count
        )
    }
}

struct Process {
    let pid: Int
    let name: String
    let state: ProcessState
    let memoryUsage: Int
    let createTime: Date
}

enum ProcessState {
    case running
    case waiting
    case terminated
}

struct MemoryUsage {
    let total: Int
    let used: Int
    let free: Int
}

protocol Device {
    var name: String { get }
    var type: DeviceType { get }
    func read() -> Data?
    func write(_ data: Data) -> Bool
}

enum DeviceType {
    case storage
    case network
    case input
    case output
}

struct SystemStats {
    let uptime: TimeInterval
    let processCount: Int
    let memoryUsage: MemoryUsage
    let deviceCount: Int
}

class ProcessManager {
    private var processes: [Int: Process] = [:]
    private var nextPid = 1
    
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
        return process
    }
    
    func terminateProcess(pid: Int) -> Bool {
        guard let _ = processes[pid] else { return false }
        processes[pid]?.state = .terminated
        return true
    }
    
    func listProcesses() -> [Process] {
        return Array(processes.values)
    }
    
    func sendMessage(from: Int, to: Int, message: String) -> Bool {
        return true
    }
    
    func receiveMessage(from: Int) -> String? {
        return nil
    }
    
    func checkPermission(pid: Int, resource: String, operation: String) -> Bool {
        return true
    }
}

class MemoryManager {
    private var allocatedBlocks: [UnsafeMutableRawPointer: Int] = [:]
    
    func allocate(size: Int) -> UnsafeMutableRawPointer? {
        let pointer = UnsafeMutableRawPointer.allocate(byteCount: size, alignment: 1)
        allocatedBlocks[pointer] = size
        return pointer
    }
    
    func deallocate(pointer: UnsafeMutableRawPointer) {
        allocatedBlocks[pointer] = nil
        pointer.deallocate()
    }
    
    func getUsage() -> MemoryUsage {
        let total = 1024 * 1024 * 100
        let used = allocatedBlocks.values.reduce(0, +)
        return MemoryUsage(total: total, used: used, free: total - used)
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
}

class FileSystem {
    private var files: [String: Data] = [:]
    
    func createFile(path: String, content: Data) -> Bool {
        files[path] = content
        return true
    }
    
    func readFile(path: String) -> Data? {
        return files[path]
    }
    
    func deleteFile(path: String) -> Bool {
        files[path] = nil
        return true
    }
    
    func listDirectory(path: String) -> [String] {
        return files.keys.filter { $0.hasPrefix(path) }.map { $0.replacingOccurrences(of: path, with: "") }
    }
}
