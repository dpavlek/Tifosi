//
//  ChatViewModel.swift
//  Tifosi
//
//  Created by COBE Osijek on 09/08/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import Foundation
import JSQMessagesViewController
import Photos
import Firebase

class Chat {
    
    private var chatMessages: [JSQMessage] = []
    var photoMessageMap = [String: JSQPhotoMediaItem]()
    private var updatedMessageRefHandle: DatabaseHandle?
    private let imageURLNotSetKey = "NOTSET"
    
    func returnMessages() -> [JSQMessage] {
        return chatMessages
    }
    
    func appendMessage(message: JSQMessage) {
        chatMessages.append(message)
    }
    
    func loadMessages(senderID: String, onCompletion: @escaping ((Bool) -> Void)) {
        chatMessages = []
        loadMessagesFromDatabase(senderId: senderID) { _ in
            onCompletion(true)
        }
    }
    
    private func loadMessagesFromDatabase(senderId: String, onCompletion: @escaping ((Bool) -> Void)) {
        
        let query = Constants.Refs.databaseChats.queryLimited(toLast: 30)
        
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            if let data = snapshot.value as? [String: String] {
                if let id = data["sender_id"],
                    let name = data["name"],
                    let text = data["text"],
                    !text.isEmpty {
                    if let message = JSQMessage(senderId: id, displayName: name, text: text) {
                        self?.chatMessages.append(message)
                        onCompletion(true)
                    }
                } else if let id = data["senderID"],
                    let photoURL = data["photoURL"] {
                    if let mediaItem = JSQPhotoMediaItem(maskAsOutgoing: id == senderId) {
                        self?.addPhotoMessage(withId: id, displayName: "", mediaItem: mediaItem, key: snapshot.key) { _ in
                            onCompletion(true)
                        }
                        if photoURL.hasPrefix("gs://") {
                            self?.fetchImageData(photoURL: photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: nil) { _ in
                                onCompletion(true)
                            }
                        }
                    }
                }
            }
        })
        
        updatedMessageRefHandle = Constants.Refs.databaseChats.observe(.childChanged, with: { [weak self] snapshot in
            let key = snapshot.key
            let messageData = snapshot.value as? [String: String]
            
            if let photoURL = messageData?["photoURL"] as String! {
                if let mediaItem = self?.photoMessageMap[key] {
                    self?.fetchImageData(photoURL: photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: key) { _ in
                        onCompletion(true)
                    }
                }
            }
        })
    }
    
    func sendMessage(senderID: String, displayName: String, text: String) {
        let ref = Constants.Refs.databaseChats.childByAutoId()
        
        let message = [
            "sender_id": senderID,
            "name": displayName,
            "text": text
        ]
        
        ref.setValue(message)
    }
    
    func sendPhotoMessage(senderID: String) -> String {
        let itemRef = Constants.Refs.databaseChats.childByAutoId()
        
        let messageItem = [
            "photoURL": imageURLNotSetKey,
            "senderID": senderID
        ]
        
        itemRef.setValue(messageItem)
        return itemRef.key
    }
    
    func fetchImageData(photoURL: String, forMediaItem mediaItem: JSQPhotoMediaItem, clearsPhotoMessageMapOnSuccessForKey key: String?, onCompletion: @escaping ((Bool) -> Void)) {
        let storageRef = Storage.storage().reference(forURL: photoURL)
        
        storageRef.getData(maxSize: INT64_MAX) { [weak self] data, error in
            if let error = error {
                print("Error downloading image data: \(error)")
                return
            }
            
            storageRef.getMetadata(completion: { [weak self] _, metadataErr in
                if let error = metadataErr {
                    print("Error downloading metadata: \(error)")
                    return
                }
                
                mediaItem.image = UIImage(data: data!)
                onCompletion(true)
                
                guard key != nil else {
                    return
                }
                self?.photoMessageMap.removeValue(forKey: key!)
            })
        }
    }
    
    func addPhotoMessage(withId id: String, displayName: String, mediaItem: JSQPhotoMediaItem, key: String, onCompletion: ((Bool) -> Void)) {
        if let message = JSQMessage(senderId: id, displayName: "", media: mediaItem) {
            appendMessage(message: message)
            
            if mediaItem.image == nil {
                photoMessageMap[key] = mediaItem
            }
            
            onCompletion(true)
        }
    }
    
}
