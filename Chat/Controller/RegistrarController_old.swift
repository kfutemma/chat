//
//  RegistrarController.swift
//  Chat
//
//  Created by Kaique Futemma on 24/05/18.
//  Copyright © 2018 Kaique Futemma. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class RegistrarController_old: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    @IBOutlet weak var senha2TextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        senhaTextField.delegate = self
        senha2TextField.delegate = self
        
        senhaTextField.isSecureTextEntry = true
        senha2TextField.isSecureTextEntry = true
        
        self.hideKeyBoardWhenTapped()
        
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            senhaTextField.becomeFirstResponder()
        }
        else if textField == senhaTextField
        {
            senha2TextField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }

    @IBAction func botaoCancelarClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func botaoAvancarClick(_ sender: UIButton) {
        if(senha2TextField.text == senhaTextField.text){
            Auth.auth().createUser(withEmail: emailTextField.text!, password: senhaTextField.text!, completion: {(user, error) in
                
                if error != nil {
                    let registrarErroAlerta = UIAlertController(title: "Algo deu errado no registro", message: "\(String(describing: error?.localizedDescription)) Tente novamente.", preferredStyle: .alert)
                    registrarErroAlerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(registrarErroAlerta, animated: true, completion: nil)
                    return
                }
                self.enviarEmail()
                self.dismiss(animated: true, completion: nil)
            })
        }
        else {
            let pswNotMatchAlert = UIAlertController(title: "Opa!", message: "As senhas não são iguais. Digite-as novamente!", preferredStyle: .alert)
            pswNotMatchAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                    self.senhaTextField.text = ""
                    self.senha2TextField.text = ""
            }))
            present(pswNotMatchAlert, animated: true, completion: nil)
        }
    }
    
    
    func enviarEmail(){
        Auth.auth().signIn(withEmail: emailTextField.text!, password: senhaTextField.text!, completion: {(user, error) in
            if error != nil {
                print("Erro: \(error!.localizedDescription)")

                return
            }
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                if error != nil{
                    let emailNaoEnviadoAlert = UIAlertController(title: "Algo deu errado com o Email", message: "\(String(describing: error?.localizedDescription)) Tente novamente.", preferredStyle: .alert)
                emailNaoEnviadoAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(emailNaoEnviadoAlert, animated: true, completion: nil)
                }
                else {
                    let emailEnviadoAlert = UIAlertController(title: "Verificar Email", message: "Um email de verificação foi enviado na sua conta. Por favor clique no link da mensagem para concluir o registro!", preferredStyle: .alert)
                    emailEnviadoAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(emailEnviadoAlert, animated: true, completion: {
                        self.dismiss(animated: true, completion: nil)
                    })
                }
                do {
                    try Auth.auth().signOut()
                } catch {
                    // ERRO HANDLING
                }
            
         })
        }
        )
    }

}

extension UIViewController {
    func hideKeyBoardWhenTapped(){
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
}




