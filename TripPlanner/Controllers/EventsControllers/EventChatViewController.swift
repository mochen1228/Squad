//
//  EventChatViewController.swift
//  TripPlanner
//
//  Created by Hamster on 2/26/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class EventChatViewController: UIViewController {
    
    var messages: [Message] = []
    var member: Member!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configureInputBar()
    }
    
//    func configureInputBar() {
//        member = Member(name: "Chen Mo", color: .gray)
//        messagesCollectionView.messagesDataSource = self
//        messagesCollectionView.messagesLayoutDelegate = self
//        messageInputBar.delegate = self
//        messagesCollectionView.messagesDisplayDelegate = self
    // }
}
//
//extension EventChatViewController: MessagesDataSource {
//    func currentSender() -> SenderType {
//        return Sender(id: member.name, displayName: member.name)
//    }
//
//    func numberOfSections( in messagesCollectionView: MessagesCollectionView) -> Int {
//        return messages.count
//    }
//
//    func messageForItem(
//        at indexPath: IndexPath,
//        in messagesCollectionView: MessagesCollectionView) -> MessageType {
//
//        return messages[indexPath.section]
//    }
//
//    func messageTopLabelHeight(
//        for message: MessageType,
//        at indexPath: IndexPath,
//        in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//
//        return 12
//    }
//
//    func messageTopLabelAttributedText(
//        for message: MessageType,
//        at indexPath: IndexPath) -> NSAttributedString? {
//
//        return NSAttributedString(string: message.sender.displayName,
//                                  attributes: [.font: UIFont.systemFont(ofSize: 12)])
//    }
//}
//
//extension EventChatViewController: MessagesLayoutDelegate {
//    func heightForLocation(message: MessageType,
//                           at indexPath: IndexPath,
//                           with maxWidth: CGFloat,
//                           in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        return 0
//    }
//}
//
//extension EventChatViewController: MessagesDisplayDelegate {
//    func configureAvatarView(_ avatarView: AvatarView,for message: MessageType,at indexPath: IndexPath,in messagesCollectionView: MessagesCollectionView) {
//        let message = messages[indexPath.section]
//        let color = message.member.color
//        avatarView.backgroundColor = color
//  }
//}
//
//extension EventChatViewController: InputBarAccessoryViewDelegate {
//    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
//        let newMessage = Message(member: member, text: text, messageId: UUID().uuidString)
//          messages.append(newMessage)
//          inputBar.inputTextView.text = ""
//          messagesCollectionView.reloadData()
//          messagesCollectionView.scrollToBottom(animated: true)
//    }
//}
