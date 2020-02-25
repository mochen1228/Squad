//
//  PrivateMessageViewController.swift
//  TripPlanner
//
//  Created by Hamster on 2/24/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit
import MessageKit
import MessageInputBar


class PrivateMessageViewController: MessagesViewController {
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var currentContact = ""
    
    private var messages: [Message] = []
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.title = currentContact
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }

}

extension PrivateMessageViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return User(senderId: "1", displayName: "")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func cellTopLabelAttributedText(for message: MessageType,
      at indexPath: IndexPath) -> NSAttributedString? {

      let name = message.sender.displayName
      return NSAttributedString(
        string: name,
        attributes: [
          .font: UIFont.preferredFont(forTextStyle: .caption1),
          .foregroundColor: UIColor(white: 0.3, alpha: 1)
        ]
      )
    }
}

extension PrivateMessageViewController: MessagesLayoutDelegate {

  func avatarSize(for message: MessageType, at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView) -> CGSize {
    return .zero
  }

  func footerViewSize(for message: MessageType, at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView) -> CGSize {
    return CGSize(width: 0, height: 8)
  }

  func heightForLocation(message: MessageType, at indexPath: IndexPath,
    with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    return 0
  }
}

extension PrivateMessageViewController: MessagesDisplayDelegate {
  
  func backgroundColor(for message: MessageType, at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView) -> UIColor {
    
    // 1
    return isFromCurrentSender(message: message) ? .blue : .green
  }

  func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView) -> Bool {

    // 2
    return false
  }

  func messageStyle(for message: MessageType, at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView) -> MessageStyle {

    let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft

    // 3
    return .bubbleTail(corner, .curved)
  }
}

extension PrivateMessageViewController: MessageInputBarDelegate {
  func messageInputBar(
    _ inputBar: MessageInputBar,
    didPressSendButtonWith text: String) {
    
    let newMessage = Message(
        text: text,
        user: User,
        messageId: UUID().uuidString, date: Date())
      
    messages.append(newMessage)
    inputBar.inputTextView.text = ""
    messagesCollectionView.reloadData()
    messagesCollectionView.scrollToBottom(animated: true)
  }
}
