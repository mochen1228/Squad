//
//  Message.swift
//  TripPlanner
//
//  Created by Hamster on 2/24/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import Foundation
import MessageKit


struct Message: MessageType {
    var sender: SenderType {
        return user
    }
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
    
    var user: User
    
    private init(kind: MessageKind, user: User, messageId: String, date: Date) {
        self.kind = kind
        self.user = user
        self.messageId = messageId
        self.sentDate = date
    }
    
    
    init(text: String, user: User, messageId: String, date: Date) {
        self.init(kind: .text(text), user: user, messageId: messageId, date: date)
    }
    
}
