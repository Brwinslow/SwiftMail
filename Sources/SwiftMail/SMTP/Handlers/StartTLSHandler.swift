import Foundation
import NIO
import Logging


/**
 Handler for SMTP STARTTLS command responses
 */
public final class StartTLSHandler: BaseSMTPHandler<Bool> {
    /**
     Process a response from the server
     - Parameter response: The response to process
     - Returns: Whether the handler is complete
     */
    override public func processResponse(_ response: SMTPResponse) -> Bool {
        if response.code == 220 {
            // 220 Ready to start TLS
            promise.succeed(true)
            return true
        } else if response.code >= 400 {
            // Error response
            promise.fail(SMTPError.tlsFailed("STARTTLS failed: \(response.message)"))
            return true
        }
        
        return false // Not complete yet
    }
    
    /**
     Handle a successful response
     - Parameter response: The parsed SMTP response
     */
    override public func handleSuccess(response: SMTPResponse) {
        promise.succeed(true)
    }
    
    /**
     Handle an error response
     - Parameter response: The parsed SMTP response
     */
    override public func handleError(response: SMTPResponse) {
        promise.fail(SMTPError.tlsFailed("STARTTLS failed: \(response.message)"))
    }
} 
