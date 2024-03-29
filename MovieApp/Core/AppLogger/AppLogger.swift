import os.log
import OSLog

/// Logger
public struct AppLogger {
    
    /// LogLevel
    public enum LogLevel {
        case debug
        case info
        case warn
        case error
        case fault
        
        @inlinable
        var category: String {
            switch self {
            case .debug:    return "Debug"
            case .info:     return "Info"
            case .warn:     return "Warning"
            case .error:    return "Error"
            case .fault:    return "Fault"
            }
        }
        
        @inlinable
        var emoji: String {
            switch self {
            case .debug:    return "[🟢]"
            case .info:     return "[🔵]"
            case .warn:     return "[🟡]"
            case .error:    return "[🔴]"
            case .fault:    return "[❌]"
            }
        }
    }
    
    @inlinable static func subsystem() -> String {
        return Bundle.main.bundleIdentifier ?? ""
    }
    
    @discardableResult
    @inlinable static func log(
        _ items: Any ...,
        tag: Any? = nil,
        level: LogLevel,
        file: String,
        function: String,
        line: Int
    ) -> String {
        let fileName: String = URL(fileURLWithPath: file).lastPathComponent
        let items = items.map({ String(describing: $0) }).joined(separator: " ")
        let message: String = [
            level.emoji,
            "[\(fileName) \(function) (\(line))]",
            "\(items)"
        ].joined(separator: " ")
        
        if isConsolLog, #available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *) {
            let logger = Logger(subsystem: subsystem(), category: level.category)
            
            #if RELEASE
            switch level {
            case .debug:
                logger.debug("\(message)")
                
            case .info:
                logger.info("\(message)")
                
            case .warn:
                logger.warning("\(message)")
                
            case .error:
                logger.error("\(message)")
                
            case .fault:
                logger.fault("\(message)")
            }
            #else
            switch level {
            case .debug:
                logger.debug("\(message, privacy: .public)")
                
            case .info:
                logger.info("\(message, privacy: .public)")
                
            case .warn:
                logger.warning("\(message, privacy: .public)")
                
            case .error:
                logger.error("\(message, privacy: .public)")
                
            case .fault:
                logger.fault("\(message, privacy: .public)")
            }
            #endif
        } else if isConsolLog, #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
            switch level {
            case .debug:
                os_log("%@", type: .debug, message)
                
            case .info:
                os_log("%@", type: .info, message)
                
            case .warn:
                os_log("%@", type: .info, message)
                
            case .error:
                os_log("%@", type: .error, message)
                
            case .fault:
                os_log("%@", type: .fault, message)
            }
            
        } else {
            print(message)
        }
        
        return message
    }
    
    // MARK: - Public
    
    /// 콘솔 로그 여부
    ///
    /// *) isConsolLog = true 인 경우, Release 에서 콘솔에 로그 확인 가능
#if RELEASE
    public static var isConsolLog: Bool = false
#else
    public static var isConsolLog: Bool = true
#endif
    
    /// Debug log
    ///
    /// - Parameters:
    ///   - items: messages
    @inlinable public static func debug(
        _ items: Any ...,
        tag: Any? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(
            items,
            tag: tag,
            level: .debug,
            file: file,
            function: function,
            line: line
        )
    }
    
    /// Info log
    ///
    /// - Parameters:
    ///   - items: messages
    @inlinable public static func info(
        _ items: Any ...,
        tag: Any? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(
            items,
            tag: tag,
            level: .info,
            file: file,
            function: function,
            line: line
        )
    }
    
    /// Warning log
    ///
    /// - Parameters:
    ///   - items: messages
    @inlinable public static func warn(
        _ items: Any ...,
        tag: Any? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(
            items,
            tag: tag,
            level: .warn,
            file: file,
            function: function,
            line: line
        )
    }
    
    /// Error log
    ///
    /// - Parameters:
    ///   - items: messages
    @inlinable public static func error(
        _ items: Any ...,
        tag: Any? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(
            items,
            tag: tag,
            level: .error,
            file: file,
            function: function,
            line: line
        )
    }
    
    /// Fatal log
    ///
    /// - Parameters:
    ///   - items: messages
    @inlinable public static func fault(
        _ items: Any ...,
        tag: Any? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let message = log(
            items,
            tag: tag,
            level: .fault,
            file: file,
            function: function,
            line: line
        )
        // fatalError
        fatalError(message)
    }
}
