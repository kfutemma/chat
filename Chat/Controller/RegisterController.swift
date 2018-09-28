//
//  RegistrarController.swift
//  Chat
//
//  Created by Kaique Futemma on 02/07/18.
//  Copyright © 2018 Kaique Futemma. All rights reserved.
//

import UIKit
import Firebase

class RegisterController: UIViewController {
    
    //_______ Layer dos textFields _______
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    // _______ BOTAO DE REGISTRAR _______
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = UIColor(r: 80, g:101, b:161)
        button.setTitle("Registrar", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        return button
    }()
    
    // _______ CAMPO E SEPARADOR DE NOME _______
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Nome"
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g:220, b:220)
        view.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    // _______ CAMPO E SEPARADOR DE TELEFONE _______
    let telephoneTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Telefone"
        tf.keyboardType = .phonePad
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    let telephoneSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g:220, b:220)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // _______ CAMPOAS DE SENHAS _______
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Senha"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    let passwordSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g:220, b:220)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let password2TextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Confirmar Senha"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    // _______ IMAGEM DA TELA INICIAL_______
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kaique")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5.0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // _______ JA TENHO UMA CONTA LABEL,SEPARADOR E BOTAO_______
    lazy var haveAccountButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Já possui uma conta?", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        
        button.addTarget(self, action: #selector(haveAccountBtn), for: .touchUpInside)
        
        return button
    }()
    
    @objc func haveAccountBtn(){
        dismiss(animated: true, completion: nil)
    }
    
    let haveAccountSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g:220, b:220)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let alertCreateAccount: UIAlertController = {
        let emailSendAlert = UIAlertController(title: "Confirmar conta", message: "Uma mensagem de confirmarmação foi enviada ao email cadastrado.", preferredStyle: .alert)
        emailSendAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    
        return emailSendAlert
    }()
    // ______________________________________________________________________________________________
    // ______________________________________________________________________________________________
    // ______________________________________________________________________________________________
    // ______________________________________________________________________________________________
    // ______________________________________________________________________________________________
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 61, g:91, b:151)
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        //view.addSubview(profileImageView)
        view.addSubview(haveAccountSeparatorView)
        view.addSubview(haveAccountButton)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        //setupProfileImageView()
        setupAccountButton()
        self.hideKeyboardWhenTappedAround()
    }
    
    func setupAccountButton(){
        //Constraints (Direito, esquerd, superior e inferior)
        
        haveAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        haveAccountButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
        haveAccountButton.widthAnchor.constraint(equalTo: haveAccountSeparatorView.widthAnchor).isActive = true
        haveAccountButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        haveAccountSeparatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        haveAccountSeparatorView.bottomAnchor.constraint(equalTo: haveAccountButton.topAnchor, constant: -12).isActive = true
        haveAccountSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        haveAccountSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func setupInputsContainerView(){
        //Constraints (Direito, esquerd, superior e inferior)
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        // _______ CAMPO DE NOME _______
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // _______ CAMPO DE EMAIL _______
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // _______ CAMPO DE TELEFONE _______
        inputsContainerView.addSubview(telephoneTextField)
        inputsContainerView.addSubview(telephoneSeparatorView)
        
        telephoneTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        telephoneTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        telephoneTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        telephoneTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
        telephoneSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        telephoneSeparatorView.topAnchor.constraint(equalTo: telephoneTextField.bottomAnchor).isActive = true
        telephoneSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        telephoneSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // _______ CAMPOS DE SENHAS _______
        inputsContainerView.addSubview(passwordTextField)
        inputsContainerView.addSubview(passwordSeparatorView)
        inputsContainerView.addSubview(password2TextField)
        
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: telephoneSeparatorView.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
        passwordSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        passwordSeparatorView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        passwordSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        password2TextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        password2TextField.topAnchor.constraint(equalTo: passwordSeparatorView.bottomAnchor).isActive = true
        password2TextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        password2TextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
    }
    
    func setupLoginRegisterButton(){
        //Constraints (Direito, esquerd, superior e inferior)
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupProfileImageView(){
        //Constraints (Direito, esquerd, superior e inferior)
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    @objc func handleRegister(){
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let password2 = password2TextField.text,let name = nameTextField.text, let telephone = telephoneTextField.text else {
            print("Form is not valid")
            return
        }
        
        if (password == password2) {
            Auth.auth().createUser(withEmail: email, password: password, completion: {
                (user , error) in
                
                if error != nil {
                    let registrarErroAlerta = UIAlertController(title: "Algo deu errado no registro", message: "\(String(describing: error?.localizedDescription)) Tente novamente.", preferredStyle: .alert)
                    registrarErroAlerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(registrarErroAlerta, animated: true, completion: nil)
                    return
                }
                
                guard let uid = user?.user.uid else{
                    return
                }
                
                self.registerUserIntoDatabaseWithUID(uid: uid, name: name, email: email, telephone: telephone)
                
                self.enviarEmail()
                self.present(self.alertCreateAccount, animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
            })
        }
        else {
            let pswNotMatchAlert = UIAlertController(title: "Opa!", message: "As senhas não são iguais. Digite-as novamente!", preferredStyle: .alert)
            pswNotMatchAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                self.passwordTextField.text = ""
                self.password2TextField.text = ""
            }))
            present(pswNotMatchAlert, animated: true, completion: nil)
        }
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, name: String, email: String, telephone: String){
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        let values = ["name": name, "email": email, "telephone": telephone, "profileImageUrl": "https://firebasestorage.googleapis.com/v0/b/chat-22387.appspot.com/o/default-picture_0_0.png?alt=media&token=014adb7d-eb81-4972-a944-f8716343ab9e"];
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
            
            print("salvou usuario o banco de dados")
        })
    }
    
    func enviarEmail(){
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
            if error != nil {
                print("Erro: \(error!.localizedDescription)")
                
                return
            }
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                
                if error != nil {
                    let emailNotSendAlert = UIAlertController(title: "Algo deu errado com o Email", message: "\(String(describing: error?.localizedDescription)) Tente novamente.", preferredStyle: .alert)
                    emailNotSendAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(emailNotSendAlert, animated: true, completion: nil)
                }
                do {
                    try Auth.auth().signOut()
                }
                catch {
                    // ERROR HANDLING
                }
                
            })
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}




