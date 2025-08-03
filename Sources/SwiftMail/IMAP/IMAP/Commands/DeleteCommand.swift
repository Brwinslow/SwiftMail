import Foundation
import NIOIMAP
import NIO

/// Command to delete an existing mailbox
struct DeleteCommand: IMAPCommand {
    typealias ResultType = Void
    typealias HandlerType = DeleteCommandHandler
    
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
        return TaggedCommand(tag: tag, command: .delete(MailboxName(ByteBuffer(string: mailboxName))))
    }
}