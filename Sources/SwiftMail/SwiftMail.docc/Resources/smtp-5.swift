// Create sender and recipients
let sender = EmailAddress(name: "Test Sender", address: "sender@example.org")
let recipient = EmailAddress(name: "Test Recipient", address: "recipient@example.org") // Primary recipient

// Create an attachment
let attachment = Attachment(filename: "document.pdf",
                            data: documentData,
                            mimeType: "application/pdf"
                           )

// Create a new email message
let email = Email(sender: sender,
                  recipients: [recipient],
                  subject: "Hello from SwiftMail",
                  textBody: "This is a test email sent using SwiftMail.",
				  attachments: [attachment]
            )
