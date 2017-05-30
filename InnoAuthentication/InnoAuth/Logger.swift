// /Utils/Logger.swift

// This class handles oAuth authentication based on the required implementation.

import Foundation


/// Log levels for the logging
///
/// - verbose: Verbose
/// - info: Information
/// - debug: Debug
/// - error: Error
public enum LogLevel: Int {
    
    /// Verbose logging
    case verbose = 0
    /// Info
    case info
    /// Debug
    case debug
    /// Error
    case error
}

/// Handle logging of information.
public class Logger {
    
    /// Level of logging required for the logger.
    /// Defaults to `debug`
    public var level: LogLevel = .debug

    
    /// Shared instance of logger
    public static let shared: Logger = {
        return Logger() // Lazy loading of singleton object.
    }()

    private init() {} // Make init as private

    
    /// Log Info
    ///
    /// - Parameter items: Any
    public func info(_ items: Any...) {
        self.log(inLevel: .info, items: items)
    }
    
    /// Log Debug information
    ///
    /// - Parameter items: Any
    public func debug(_ items: Any...) {
        self.log(inLevel: .debug, items: items)
    }
    
    /// Log Verbose information
    ///
    /// - Parameter items: Any
    public func verbose(_ items: Any...) {
        self.log(inLevel: .verbose, items: items)
    }
    
    /// Log error information
    ///
    /// - Parameter items: Any
    public func error(_ items: Any...) {
        self.log(inLevel: .error, items: items)
    }

    func log(inLevel: LogLevel, items: Any...) {
        if inLevel.rawValue >= self.level.rawValue {
            print(items)
        }
    }

}
