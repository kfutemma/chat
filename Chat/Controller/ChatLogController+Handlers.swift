//
//  ChatLogController+Handlers.swift
//  Chat
//
//  Created by Kaique Futemma on 24/07/18.
//  Copyright © 2018 Kaique Futemma. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

extension ChatLogController {

    
    @objc func handleUploadTap() {
        let imagePickerControler = UIImagePickerController()
        imagePickerControler.allowsEditing = true
        imagePickerControler.delegate = self
        
        present(imagePickerControler, animated: true, completion: nil)
    }
    
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.inputView?.alpha = 1
            }) { (isCompleted) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            }
        }
    }
    
    @objc func handleKeyboardDidShow() {
        
        if messages.count > 0 {
            let indexPath = NSIndexPath(item: messages.count - 1 , section: 0)
            collectionView?.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
        }
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            
            let keyboardDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
            
            bottomConstraint?.constant = -keyboardFrame!.height
            
            UIView.animate(withDuration: keyboardDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        
        let keyboardDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        bottomConstraint?.constant = 0
        
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleSend() {
        
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        
        let toId = user!.id!
        let fromId = Auth.auth().currentUser!.uid
        let timeStamp = NSDate().timeIntervalSince1970
        
        if let inputTextField = inputTextField.text {
            if inputTextField != "" {
                let values = ["text": inputTextField, "toId": toId, "fromId": fromId, "timestamp": timeStamp] as [String : Any]
                childRef.updateChildValues(values) { (error, ref) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    let userMessagesRef = Database.database().reference().child("user-messages/\(fromId)/\(toId)")
                    
                    let messageId = childRef.key
                    userMessagesRef.updateChildValues([messageId: 1])
                    
                    let recipienteUserMessagesRef = Database.database().reference().child("user-messages/\(toId)/\(fromId)")
                    recipienteUserMessagesRef.updateChildValues([messageId: 1])
                    
                    self.inputTextField.text = nil
                }
            }
        }
    }
}
