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
            //self.profileImage.image = selectedImage
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
     @objc func handleLogout(){
        do{
            try Auth.auth().signOut()
            MessageController.messages.removeAll()
            MessageController.messagesDictionary.removeAll()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
     }
    
    @objc func handleChangeName(){
        print("clicou")
        let changeName = UIAlertController(title: "Mudar nome", message: "", preferredStyle: .alert)
        changeName.addTextField { (nameChange) in
            nameChange.text = self.nameLabel.text
        }
        
        changeName.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        changeName.addAction(UIAlertAction(title: "Mudar nome", style: .default, handler: { (action) in
    
            guard let uid = Auth.auth().currentUser?.uid else{
                return
            }
            
            let newName = changeName.textFields?.first?.text
            let databaseRef = Database.database().reference()
            let userRef = databaseRef.root.child("users")
            
            userRef.child("\(uid)/name").setValue(newName!)
            self.nameLabel.text = newName
        }))
        self.present(changeName, animated: true, completion: nil)
    }
    
    @objc func handleChangeTelephone(){
        print("clicou")
        let telephoneChange = UIAlertController(title: "Mudar número de telefone", message: "", preferredStyle: .alert)
        telephoneChange.addTextField { (telephoneChange) in
            telephoneChange.text = self.telephoneLabel.text
            telephoneChange.keyboardType = .phonePad
        }
        
        telephoneChange.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        telephoneChange.addAction(UIAlertAction(title: "Mudar número", style: .default, handler: { (action) in
            
            guard let uid = Auth.auth().currentUser?.uid else{
                return
            }
            
            let newTel = telephoneChange.textFields?.first?.text
            let databaseRef = Database.database().reference()
            let userRef = databaseRef.root.child("users")
            
            userRef.child("\(uid)/telephone").setValue(newTel!)
            self.telephoneLabel.text = newTel
        }))
        self.present(telephoneChange, animated: true, completion: nil)
    }
}
