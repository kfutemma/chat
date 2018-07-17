//
//  LoginController+Handlers.swift
//  Chat
//
//  Created by Kaique Futemma on 14/07/18.
//  Copyright © 2018 Kaique Futemma. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func handleSelectProfileImageView(){
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }

        
        if let selectedImage = selectedImageFromPicker {
            
            guard let uid = Auth.auth().currentUser?.uid else{
                return
            }
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            let databaseRef = Database.database().reference()
            let userRef = databaseRef.root.child("users")
            
            if let uploadData = UIImageJPEGRepresentation(selectedImage, 0.25) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    storageRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        if url != nil {
                            let profilePicUrl = url?.absoluteString
                            
                            userRef.child("\(uid)/profileImageUrl").setValue(profilePicUrl!)
                            print("Profile Image successfully updated into storage with url: \(String(describing: profilePicUrl))")
                        }
                        
                    })
                })
                
                profileImage.image = selectedImage
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleLogout(_ sender: AnyObject?){
        do{
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
}
