// BaseMailCommandHandler.swift
// A base handler for mail commands that both IMAP and SMTP handlers can inherit from

import Foundation
import NIO
import Logging

/// Base class for mail command handlers that provides common functionality
open class BaseMailCommandHandler<T>: ChannelInboundHandler, RemovableChannelHandler, MailCommandHandler {
    public typealias InboundIn = Any
    public typealias InboundOut = Never
    public typealias ResultType = T
    
    /// The command tag (required for IMAP, optional for SMTP)
    public let commandTag: String?
    
    /// The promise that will be fulfilled when the command completes
    public let promise: EventLoopPromise<ResultType>
    
    /// Logger instance
    public let logger: Logger
    
    /// Initialize a new handler
    /// - Parameters:
    ///   - commandTag: Tag for the command (required for IMAP, optional for SMTP)
    ///   - promise: The promise to fulfill when the command completes
    ///   - logger: Optional logger to use
    public required init(commandTag: String?, promise: EventLoopPromise<ResultType>, logger: Logger? = nil) {
        self.commandTag = commandTag
        self.promise = promise
        self.logger = logger ?? Logger(label: "com.swiftmail.command")
    }
    
    /// Initialize with just the required parameters
    public required convenience init(commandTag: String?, promise: EventLoopPromise<ResultType>) {
        self.init(commandTag: commandTag, promise: promise, logger: nil)
    }
    
    /// Process a generic response (must be overridden by subclasses)
    /// - Parameter response: The response to process (any type)
    /// - Returns: Whether the handler is complete
    open func processResponse<R>(_ response: R) -> Bool {
        fatalError("Must be implemented by subclass: processResponse<\(R.self)>")
    }
    
    /// Handle command success
    /// - Parameter result: The result to complete the promise with
    open func handleSuccess(result: ResultType) {
        promise.succeed(result)
    }
    
    /// Handle command error
    /// - Parameter error: The error to fail the promise with
    open func handleError(error: Error) {
        promise.fail(error)
    }
    
    // MARK: - ChannelInboundHandler implementation
    
    /// Called when data is read from the channel
    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        // Process the incoming data (implementation will depend on the specific protocol)
        let isComplete = processResponse(unwrapInboundIn(data))
        
        // If processing is complete, remove this handler from the pipeline
        if isComplete {
            _ = context.pipeline.removeHandler(self)
        }
    }
    
    /// Called when an error occurs
    public func errorCaught(context: ChannelHandlerContext, error: Error) {
        logger.error("Error in handler: \(error)")
        handleError(error: error)
        _ = context.pipeline.removeHandler(self)
    }
    
    /// Unwrap the inbound data to the appropriate type (must be overridden by subclasses)
    open func unwrapInboundIn(_ data: NIOAny) -> Any {
        fatalError("Must be implemented by subclass")
    }
} 
