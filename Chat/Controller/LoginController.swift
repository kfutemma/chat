//
//  LoginController.swift
//  Chat
//
//  Created by Kaique Futemma on 02/07/18.
//  Copyright © 2018 Kaique Futemma. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    var userID:Any!
    //_______ Layer dos textFields _______
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        
        return view
    }()
    
    // _______ CAMPO E SEPARADOR DE EMAIL _______
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g:220, b:220)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // _______ CAMPO DE SENHA _______
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Senha"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    // _______ BOTAO DE ENTRAR _______
    lazy var loginButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = UIColor(r: 80, g:101, b:161)
        button.setTitle("Entrar", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return button
    }()
    
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
    
    // _______ JA TENHO UMA CONTA LABEL,SEPARADOR E BOTAO_______
    lazy var createAccountButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Criar uma conta!", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        
        button.addTarget(self, action: #selector(createAccountClick), for: .touchUpInside)
        
        return button
    }()
    
    @objc func createAccountClick(_ sender: AnyObject?){
        let registerController = RegisterController()
        present(registerController, animated: true, completion: nil)
    }
    
    let createAccountSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g:220, b:220)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // ______________________________________________
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 61, g:91, b:151)
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginButton)
        view.addSubview(createAccountSeparatorView)
        view.addSubview(createAccountButton)
        
        setupInputsContainerView()
        setupAccountButton()
        setupLoginRegisterButton()
        //self.hideKeyBoardWhenTapped()
        
    }
    
    func setupInputsContainerView(){
        //Constraints (Direito, esquerd, superior e inferior)
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // _______ CAMPO DE EMAIL _______
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // _______ CAMPO DE SENHA _______
        inputsContainerView.addSubview(passwordTextField)
        
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
    }
    
    func setupLoginRegisterButton(){
        //Constraints (Direito, esquerd, superior e inferior)
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupAccountButton(){
        //Constraints (Direito, esquerd, superior e inferior)
        
        createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createAccountButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
        createAccountButton.widthAnchor.constraint(equalTo: createAccountSeparatorView.widthAnchor).isActive = true
        createAccountButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        createAccountSeparatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createAccountSeparatorView.bottomAnchor.constraint(equalTo: createAccountButton.topAnchor, constant: -12).isActive = true
        createAccountSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        createAccountSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}




