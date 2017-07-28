//
//  ChatViewController.swift
//  Tifosi
//
//  Created by COBE Osijek on 27/07/2017.
//  Copyright © 2017 Daniel Pavlekovic. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import JSQMessagesViewController
import Photos
import Firebase

class ChatViewController: JSQMessagesViewController {
    
    private var chatMessages = [JSQMessage]()
    private var photoMessageMap = [String: JSQPhotoMediaItem]()
    private let imageURLNotSetKey = "NOTSET"
    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleRed())
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }()
    
    @IBAction func dismissChat(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshChat(_ sender: Any) {
        chatMessages = []
        loadMessages()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        senderId = FacebookUser.fbUser?.eMail
        if let userFirstName = FacebookUser.fbUser?.firstName {
            if let userLastName = FacebookUser.fbUser?.lastName {
                senderDisplayName = userFirstName + " " + userLastName
            }
        }
        
        title = "F1 Chat"
        
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        loadMessages()
    }
    
    private func loadMessages() {
        
        let query = Constants.refs.databaseChats.queryLimited(toLast: 10)
        
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            if let data = snapshot.value as? [String: String],
                let id = data["sender_id"],
                let name = data["name"],
                let text = data["text"],
                !text.isEmpty {
                if let message = JSQMessage(senderId: id, displayName: name, text: text) {
                    self?.chatMessages.append(message)
                    
                    self?.finishReceivingMessage()
                }
            }
        })
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return chatMessages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        return chatMessages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        return chatMessages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: chatMessages[indexPath.item].senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return chatMessages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let ref = Constants.refs.databaseChats.childByAutoId()
        
        let message = [
            "sender_id": senderId,
            "name": senderDisplayName,
            "text": text,
        ]
        
        ref.setValue(message)
        
        finishSendingMessage()
    }
    
    func sendPhotoMessage() -> String? {
        let itemRef = Constants.refs.databaseChats.childByAutoId()
        
        let messageItem = [
            "photoURL": imageURLNotSetKey,
            "senderID": senderId,
        ]
        
        itemRef.setValue(messageItem)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage(animated: true)
        return itemRef.key
    }
    
    func setImageUrl(_ url: String, forPhotoMessageWithKey key: String) {
        let itemRef = Constants.refs.databaseChats.child(key)
        itemRef.updateChildValues(["photoURL": url])
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.camera
        
        present(picker, animated: true, completion: nil)
    }
    
    private func addPhotoMessage(withId id: String, key: String, mediaItem: JSQPhotoMediaItem) {
        if let message = JSQMessage(senderId: id, displayName: "", media: mediaItem) {
            chatMessages.append(message)
            
            if mediaItem.image == nil {
                photoMessageMap[key] = mediaItem
            }
            
            collectionView.reloadData()
        }
    }
    
    private func fetchImageDataAtURL(_ photoURL: String, forMediaItem mediaItem: JSQPhotoMediaItem, clearsPhotoMessageMapOnSuccessForKey key: String?){
        let storageRef = Storage.storage().reference(forURL: photoURL)
        
        storageRef.getData(maxSize: INT64_MAX) { (data, error) in
            if let error = error {
                print("Error downloading image data: \(error)")
                return
            }
            
            storageRef.getMetadata(completion: { (metadata, metadataErr) in
                if let error = metadataErr{
                    print("Error downloading metadata: \(error)")
                    return
                }
                
                if(metadata?.contentType == "image/gif"){
                    mediaItem.image = UIImage.init(data: data!)
                }
                else{
                    mediaItem.image = UIImage.init
                }
            })
        }
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        //        MARK: Code for loading from local phone storage. Not used right now.
        //        if let photoReferenceUrl = info[UIImagePickerControllerReferenceURL] as? URL{
        //            let assets = PHAsset.fetchAssets(withALAssetURLs: [photoReferenceUrl], options: nil)
        //            let asset = assets.firstObject
        //
        //            if let key = sendPhotoMessage(){
        //                asset?.requestContentEditingInput(with: nil, completionHandler: { (contentEditingInput, info) in
        //                    let imageFileUrl = contentEditingInput?.fullSizeImageURL
        //                    //TO-DO: Check "describing"
        //                    let path = "\(String(describing: Auth.auth().currentUser?.uid))/\(Int(Date.timeIntervalSinceReferenceDate * 1000))/\(photoReferenceUrl.lastPathComponent)"
        //
        //                    Constants.refs.storage.child(path).putFile(from: imageFileUrl!, metadata: nil){ (metadata,error) in
        //                        if let error = error{
        //                            print("Error uploading photo: \(error.localizedDescription)")
        //                            return
        //                        }
        //
        //                        self.setImageUrl(Constants.refs.storage.child((metadata?.path)!).description, forPhotoMessageWithKey: key)
        //                    }
        //                })
        //            }
        //        }
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if let key = sendPhotoMessage() {
            let imageData = UIImageJPEGRepresentation(image, 1.0)
            
            let imagePath = Auth.auth().currentUser!.uid + "/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            Constants.refs.storage.child(imagePath).putData(imageData!, metadata: metadata) { metadata, error in
                if let error = error {
                    print("Error uploading photo: \(error)")
                    return
                }
                self.setImageUrl(Constants.refs.storage.child((metadata?.path)!).description, forPhotoMessageWithKey: key)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
