//
//  LoginController_old.swift
//  Chat
//
//  Created by Kaique Futemma on 23/05/18.
//  Copyright © 2018 Kaique Futemma. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class LoginController_old: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTexField: UITextField!
    
    var userID:Any!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        senhaTexField.delegate = self
        
        senhaTexField.isSecureTextEntry = true
        
        self.hideKeyBoardWhenTapped()
    }
    
    
    @IBAction func btnEntrarClick(_ sender: UIButton) {
        print("Clicou")
        Auth.auth().signIn(withEmail: emailTextField.text!, password: senhaTexField.text!) { (user, error) in
            if error != nil {
                let loginErrorAlert = UIAlertController(title: "Erro de Login...", message: "\(error!.localizedDescription) Por favior, tente novamente.", preferredStyle: .alert)
                loginErrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(loginErrorAlert, animated: true, completion: nil)
                return
            }
            
            
            if  user?.user.isEmailVerified == true{
                self.userID = Auth.auth().currentUser?.uid
                self.performSegue(withIdentifier: "emailLoggedIn", sender: self)
            }
            else {
                let notVerifiedAlert = UIAlertController(title: "Erro de Verificaçào", message: "Sua conta precisa ser verificada. Acesse seu email e verifique sua conta.", preferredStyle: .alert)
                notVerifiedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(notVerifiedAlert, animated: true, completion: nil)
                
                do{
                    try Auth.auth().signOut()
                } catch {
                    //handle error
                }
            }
        }
    }
    
    
    @IBAction func forgotPswClick(_ sender: UIButton) {
        print("clicado!")
        let forgotPswAlert = UIAlertController(title: "Esqueci minha senha", message: "Não se preocupe, vamos criar uma senha nova!", preferredStyle: .alert)
        forgotPswAlert.addTextField { (textField) in
            textField.placeholder = "Entre com seu endereço de email"
        }
        forgotPswAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        forgotPswAlert.addAction(UIAlertAction(title: "Criar nova senha", style: .default, handler: { (action) in
            let resetEmail = forgotPswAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                if error != nil {
                    let resetFailedAlert = UIAlertController(title: "Erro de recuperação de senha", message: "\(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                }
                else{
                    let resetEmailSentAlert = UIAlertController(title: "Email de nova senha enviado", message: "Um email para a criação de uma nova senha foi enviado para a conta registrada! Siga as instruções do email para saber como criar uma nova senha.", preferredStyle: .alert)
                    resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetEmailSentAlert, animated: true, completion: nil)
                    
                }
            })
        }))
        self.present(forgotPswAlert, animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (emailTextField) != nil{
            senhaTexField.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        return true
    }
}
