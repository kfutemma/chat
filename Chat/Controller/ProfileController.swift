//
//  ProfileController.swift
//  Chat
//
//  Created by Kaique Futemma on 13/07/18.
//  Copyright © 2018 Kaique Futemma. All rights reserved.
//

import UIKit
import Firebase
import AMPopTip

class ProfileController: UIViewController {
    
    var messageController: MessageController? = MessageController()
    let popTip = PopTip()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize.height = UIScreen.main.bounds.height + 60
        view.backgroundColor = UIColor.white
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = false
        
        return view
    }()
    
    let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.init(r: 237, g: 237, b: 237)
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    
    lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "imagem_padrao")
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "email"
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let telephoneLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "11976140415"
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var logoutButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = UIColor.red
        button.setTitle("Sair da minha conta", for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        return button
    }()
    
    lazy var changeTelephoneButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(r: 0, g:122, b:255).cgColor
        button.layer.cornerRadius = 5
        button.setTitle("Mudar número de telefone", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(r: 0, g:122, b:255) , for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleChangeTelephone), for: .touchUpInside)
        
        return button
    }()
    
    let changePasswordSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(r: 0, g:122, b:255).cgColor
        button.layer.cornerRadius = 5
        button.setTitle("Trocar minha foto de perfil", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(r: 0, g:122, b:255) , for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleSelectProfileImageView), for: .touchUpInside)
        
        return button
    }()
    
    lazy var changeNameButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(r: 0, g:122, b:255).cgColor
        button.layer.cornerRadius = 5
        button.setTitle("Trocar meu nome de perfil", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(r: 0, g:122, b:255), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleChangeName), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        setupScrollView()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
        showToolTip()
    }
    
    func fetchUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        } 
        
        Database.database().reference().child("users/\(uid)").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()

                user.email = dictionary["email"] as? String
                user.name = dictionary["name"] as? String
                user.telephone = dictionary["telephone"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                self.setupUserInfos(user: user)
            }
        }, withCancel: nil)
    }
    
    
    func setupUserInfos(user: User) {
        
        if let profileImageUrl = user.profileImageUrl {
            profileImage.loadImagesUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        if let profileLabelUser = user.name {
            nameLabel.text = profileLabelUser
        }
        
        if let profileLabelEmail = user.email {
            emailLabel.text = profileLabelEmail
        }
        
        if let profileLabelTelephone = user.telephone {
            telephoneLabel.text = profileLabelTelephone
        }
    }
    
    func setupScrollView() {
        
        popTip.bubbleColor = UIColor.black
        popTip.textColor = UIColor.white
        popTip.delayIn = 5
        
        //CONSTRAINTS DA SCROLLVIEW
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.backgroundColor = UIColor.init(r: 237, g: 237, b: 237)
        
        
        //CONSTRAINTS DA IMAGEM DE CAPA
        scrollView.addSubview(coverImage)
        coverImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        coverImage.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        coverImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        coverImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        //CONSTRAINTS DA IMAGEM DE PERFIL
        scrollView.addSubview(profileImage)
        profileImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: -70).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 186).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 186).isActive = true
        
        //CONSTRAINTS DO NAMELABEL
        scrollView.addSubview(nameLabel)
        nameLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 34).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -24).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //CONSTRAINTS DO SEPARADOR PARA LOGOUT
        scrollView.addSubview(nameSeparatorView)
        nameSeparatorView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: nameLabel.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //CONSTRAINT DO TELEPHONELABEL
        scrollView.addSubview(telephoneLabel)
        telephoneLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        telephoneLabel.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor, constant: 12).isActive = true
        telephoneLabel.widthAnchor.constraint(equalTo: nameLabel.widthAnchor).isActive = true
        telephoneLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        //CONSTRAINT DO EMAILLABEL
        scrollView.addSubview(emailLabel)
        emailLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        emailLabel.topAnchor.constraint(equalTo: telephoneLabel.bottomAnchor, constant: 12).isActive = true
        emailLabel.widthAnchor.constraint(equalTo: nameLabel.widthAnchor).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        //CONSTRAINTS DO SEPARADOR PARA TROCAR SENHA
        scrollView.addSubview(changePasswordSeparatorView)
        changePasswordSeparatorView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        changePasswordSeparatorView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 12).isActive = true
        changePasswordSeparatorView.widthAnchor.constraint(equalTo: nameSeparatorView.widthAnchor).isActive = true
        changePasswordSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //CONSTRAINTS DO BOTAO DE MUDAR NOME
        scrollView.addSubview(changePhotoButton)
        changePhotoButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        changePhotoButton.topAnchor.constraint(equalTo: changePasswordSeparatorView.bottomAnchor, constant: 12).isActive = true
        changePhotoButton.widthAnchor.constraint(equalTo: nameLabel.widthAnchor).isActive = true
        changePhotoButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //CONSTRAINTS DO BOTAO DE MUDAR NOME
        scrollView.addSubview(changeNameButton)
        changeNameButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        changeNameButton.topAnchor.constraint(equalTo: changePhotoButton.bottomAnchor, constant: 12).isActive = true
        changeNameButton.widthAnchor.constraint(equalTo: nameLabel.widthAnchor).isActive = true
        changeNameButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //CONSTRAINTS DO BOTAO DE LOGOUT
        scrollView.addSubview(changeTelephoneButton)
        changeTelephoneButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        changeTelephoneButton.topAnchor.constraint(equalTo: changeNameButton.bottomAnchor, constant: 12).isActive = true
        changeTelephoneButton.widthAnchor.constraint(equalTo: nameLabel.widthAnchor).isActive = true
        changeTelephoneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //CONSTRAINTS DO BOTAO DE LOGOUT
        scrollView.addSubview(logoutButton)
        logoutButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        logoutButton.topAnchor.constraint(equalTo: changeTelephoneButton.bottomAnchor, constant: 12).isActive = true
        logoutButton.widthAnchor.constraint(equalTo: nameLabel.widthAnchor).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func showToolTip() {
        popTip.show(text: "Toque aqui para mudar sua foto de perfil!", direction: .right, maxWidth: 50, in: changePhotoButton, from: self.changePhotoButton.frame, duration: 4)
    }
    
}
