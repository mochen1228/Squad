//
//  PrivateMessageViewController.swift
//  TripPlanner
//
//  Created by Hamster on 2/24/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
// import MessageInputBar


class PrivateMessageViewController: MessagesViewController {
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var currentContact = ""
    
    var messages: [Message] = []
    var member: Member!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.title = currentContact
        
        configureInputBar()
    }
    
    func configureInputBar() {
        member = Member(name: "bluemoon", color: .blue)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
}

extension PrivateMessageViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(id: member.name, displayName: member.name)
    }
    
    func numberOfSections( in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
      
    func messageForItem(
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
    }
      
    func messageTopLabelHeight(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 12
    }
      
    func messageTopLabelAttributedText(
        for message: MessageType,
        at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(string: message.sender.displayName,
                                  attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
}

extension PrivateMessageViewController: MessagesLayoutDelegate {
    func heightForLocation(message: MessageType,
                           at indexPath: IndexPath,
                           with maxWidth: CGFloat,
                           in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
}

extension PrivateMessageViewController: MessagesDisplayDelegate {
    func configureAvatarView(_ avatarView: AvatarView,for message: MessageType,at indexPath: IndexPath,in messagesCollectionView: MessagesCollectionView) {
        let message = messages[indexPath.section]
        let color = message.member.color
        avatarView.backgroundColor = color
  }
}

extension PrivateMessageViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let newMessage = Message(member: member, text: text, messageId: UUID().uuidString)
          messages.append(newMessage)
          inputBar.inputTextView.text = ""
          messagesCollectionView.reloadData()
          messagesCollectionView.scrollToBottom(animated: true)
    }
}
