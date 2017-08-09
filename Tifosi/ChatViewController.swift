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
    
    private let chatObject = Chat()
    private let raceCalendar = RaceCalendar()
    private let locationManager = CustomLocationManager()
    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleRed())
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        senderId = FacebookUser.fbUser?.eMail
        if let userFirstName = FacebookUser.fbUser?.firstName {
            if let userLastName = FacebookUser.fbUser?.lastName {
                senderDisplayName = userFirstName + " " + userLastName
            }
        }
        
        checkIfNearTrack()
        title = "F1 Chat"
        
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        chatObject.loadMessages(senderID: senderId) { [weak self] _ in
            self?.finishReceivingMessage()
        }
    }
    
    private func checkIfNearTrack() {
        raceCalendar.fetchRaces { [weak self] race in
            let raceLocation = CLLocation(latitude: race.position.latitude, longitude: race.position.longitude)
            if let distance = self?.locationManager.getDistanceFromCurrent(location: raceLocation) {
                if distance > 15 {
                    DispatchQueue.main.async {
                        self?.inputToolbar.contentView.leftBarButtonItem = nil
                    }
                }
            }
            self?.locationManager.stopUpdatingLocation()
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return chatObject.returnMessages()[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatObject.returnMessages().count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        return chatObject.returnMessages()[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        return chatObject.returnMessages()[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: chatObject.returnMessages()[indexPath.item].senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return chatObject.returnMessages()[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        chatObject.sendMessage(senderID: senderId, displayName: senderDisplayName, text: text)
        finishSendingMessage()
    }
    
    func sendPhotoMessage() -> String? {
        
        let refKey = chatObject.sendPhotoMessage(senderID: senderId)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage(animated: true)
        return refKey
    }
    
    func setImageUrl(_ url: String, forPhotoMessageWithKey key: String) {
        let itemRef = Constants.Refs.databaseChats.child(key)
        itemRef.updateChildValues(["photoURL": url])
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.camera
        
        present(picker, animated: true, completion: nil)
    }
    
    private func addPhotoMessage(withId id: String, key: String, mediaItem: JSQPhotoMediaItem) {
        chatObject.addPhotoMessage(withId: id, displayName: "", mediaItem: mediaItem, key: key) { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
    
    private func fetchImageDataAtURL(_ photoURL: String, forMediaItem mediaItem: JSQPhotoMediaItem, clearsPhotoMessageMapOnSuccessForKey key: String?) {
        chatObject.fetchImageData(photoURL: photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: key) { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if let key = sendPhotoMessage(), let image = image {
            let imageData = UIImageJPEGRepresentation(image, 0.05)
            
            let imagePath = Auth.auth().currentUser!.uid + "/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            Constants.Refs.storage.child(imagePath).putData(imageData!, metadata: metadata) { [weak self] metadata, error in
                if let error = error {
                    print("Error uploading photo: \(error)")
                    return
                }
                self?.setImageUrl(Constants.Refs.storage.child((metadata?.path)!).description, forPhotoMessageWithKey: key)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
