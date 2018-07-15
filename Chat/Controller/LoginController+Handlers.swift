//
//  LoginController+Handlers.swift
//  Chat
//
//  Created by Kaique Futemma on 14/07/18.
//  Copyright © 2018 Kaique Futemma. All rights reserved.
//

import UIKit
import Firebase

extension LoginController {
    
    @objc func handleLogin(){
        
        guard let email = emailTextField.text, let password = passwordTextField.text
            else {
                print("Form is not valid")
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                let loginErrorAlert = UIAlertController(title: "Erro de Login...", message: "\(error!.localizedDescription) Por favor, tente novamente.", preferredStyle: .alert)
                loginErrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(loginErrorAlert, animated: true, completion: nil)
                return
            }
            
            
            if  user?.user.isEmailVerified == true{
                self.userID = Auth.auth().currentUser?.uid
                self.dismiss(animated: true, completion: nil)
            }
            else {
                let notVerifiedAlert = UIAlertController(title: "Erro de Verificação", message: "Sua conta precisa ser verificada. Acesse seu email e verifique sua conta.", preferredStyle: .alert)
                notVerifiedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(notVerifiedAlert, animated: true, completion: nil)
                
                do{
                    try Auth.auth().signOut()
                } catch let errorVerification{
                    let errorVerifiedAlert = UIAlertController(title: "Erro de Verificação", message: "\(errorVerification).", preferredStyle: .alert)
                    errorVerifiedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(errorVerifiedAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func createAccountClick(_ sender: AnyObject?){
        let registerController = RegisterController()
        present(registerController, animated: true, completion: nil)
    }
}
