import Foundation
import NIOIMAPCore

/**
 Command to unselect the currently selected mailbox without expunging deleted messages
 
 The UNSELECT command is an extension to the core IMAP protocol defined in RFC 3691.
 It allows a client to deselect the current mailbox without implicitly causing an expunge 
 of messages marked for deletion, as the CLOSE command does.
 */
public struct UnselectCommand: IMAPCommand {
    public typealias ResultType = Void
    public typealias HandlerType = UnselectHandler
    
    public var handlerType: HandlerType.Type {
        return UnselectHandler.self
    }
    
    public init() {}
    
    public func validate() throws {
        // No validation needed for UNSELECT command
    }
    
    public func toTaggedCommand(tag: String) -> TaggedCommand {
        // Using a raw string command since UNSELECT is not in the standard Command enum
        // The UNSELECT command takes no parameters
		return TaggedCommand(tag: tag, command: .unselect)
    }
} 
