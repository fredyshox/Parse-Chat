//
//  Message.swift
//  ParseTest
//
//  Created by Kacper Raczy on 24.09.2017.
//  Copyright © 2017 Kacper Raczy. All rights reserved.
//

import Foundation
import JSQMessagesViewController
import Parse

class Message: PFObject{

    @NSManaged var sender_id: String
    @NSManaged var display_name: String
    @NSManaged var body_text: String
    @NSManaged var conversation_id: String
}

extension Message: PFSubclassing {
    static func parseClassName() -> String {
        return "Message"
    }
    
    override class func query() -> PFQuery<PFObject>? {
        let query = PFQuery(className: Message.parseClassName())
        query.cachePolicy = .networkOnly
        return query
    }
}

extension Message: JSQMessageData {
    
    func date() -> Date! {
        return createdAt!
    }
    
    func messageHash() -> UInt {
        return UInt(self.hash)
    }
    
    func text() -> String! {
        return body_text
    }
    
    func isMediaMessage() -> Bool {
        return false
    }
    
    func senderId() -> String! {
        return sender_id
    }
    
    func senderDisplayName() -> String! {
        return display_name
    }
}
