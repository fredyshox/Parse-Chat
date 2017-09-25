//
//  ViewController.swift
//  ParseTest
//
//  Created by Kacper Raczy on 21.09.2017.
//  Copyright © 2017 Kacper Raczy. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Parse
import ParseLiveQuery

class ChatViewController: JSQMessagesViewController {
    
    var conversationId: String!
    var messages = [Message]()
    var conversation_query: PFQuery<PFObject>!
    var subscriber: Client!
    var subscription: Subscription<PFObject>!

    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUserData()
        initializeChat()
        print(conversationId)
        
        let predicate = NSPredicate(format: "conversation_id == %@", conversationId)
        self.conversation_query = Message.query(with: predicate)?.order(byAscending: "createdAt")
        self.conversation_query.findObjectsInBackground { (objects, err) in
            if err==nil {
                if let messages = objects as? [Message] {
                    self.messages = messages
                    self.collectionView.reloadData()
                }
            }
        }
        
        self.subscriber = Client(server: "ws://partygoer.org:8080/parse")
        self.subscription = subscriber.subscribe(conversation_query)
        self.subscription.handle(Event.created, { (query, object) in
            print("Item created")
            if let message = object as? Message {
                self.messages.append(message)
                DispatchQueue.main.async {
                    self.finishReceivingMessage(animated: true)
                }
            }
        })
        
        
 
    }
    
    func initUserData() {
        self.senderId = PFUser.current()!.objectId!
        self.senderDisplayName = PFUser.current()!.username!
    }
    
    func initializeChat() {
        collectionView.collectionViewLayout.incomingAvatarViewSize = .zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = .zero
        
        incomingBubble = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets: .zero).incomingMessagesBubbleImage(with: UIColor.blue)
        outgoingBubble = JSQMessagesBubbleImageFactory(bubble: UIImage.jsq_bubbleCompactTailless(), capInsets: .zero).outgoingMessagesBubbleImage(with: UIColor.black)
        
        automaticallyScrollsToMostRecentMessage = true
        
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Client.shared.unsubscribe(self.conversation_query)
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let message = Message()
        message.body_text = text
        message.sender_id = senderId
        message.display_name = senderDisplayName
        message.conversation_id = conversationId
        message.saveInBackground { (saved, err) in
            if saved {
                print("Message sent")
            }else {
                if let error = err {
                    print(error.localizedDescription)
                }
            }
        }
        finishSendingMessage()
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 0.0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        return messages[indexPath.item].senderId() == self.senderId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource? {
        return nil
    }
    


}

