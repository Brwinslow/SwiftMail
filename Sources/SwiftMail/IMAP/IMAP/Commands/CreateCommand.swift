import Foundation
import NIOIMAP
import NIO

/// Command to create a new mailbox
struct CreateCommand: IMAPCommand {
    typealias ResultType = Void
    typealias HandlerType = CreateCommandHandler
    
    let mailboxName: String
    let timeoutSeconds: Int = 30
    
    init(mailboxName: String) {
        self.mailboxName = mailboxName
    }
    
    func validate() throws {
        guard !mailboxName.isEmpty else {
            throw IMAPError.invalidArgument("Mailbox name cannot be empty")
        }
    }
    
    func toTaggedCommand(tag: String) -> TaggedCommand {
        return TaggedCommand(tag: tag, command: .create(MailboxName(ByteBuffer(string: mailboxName)), []))
    }
}