//
//  ProfileController.swift
//  Chat
//
//  Created by Kaique Futemma on 13/07/18.
//  Copyright © 2018 Kaique Futemma. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController {
    
    var messageController: MessageController? = MessageController()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize.height = 795
        view.backgroundColor = UIColor.white
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = false
        
        return view
    }()
    
    let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "sky_image")
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    
    lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "imagem_padrao")
        imageView.layer.cornerRadius = 15
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        
        return imageView
    }()
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Kaique Futemma"
        label.textAlignment = .center
        //label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(r: 220, g:220, b:220)
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
    
    let logoutSeparatorView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(r: 220, g:220, b:220)
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var changePasswordButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(r: 80, g:101, b:161).cgColor
        button.layer.cornerRadius = 5
        button.setTitle("Trocar minha senha", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(r: 80, g:101, b:161) , for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        return button
    }()
    
    let changePasswordSeparatorView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(r: 220, g:220, b:220)
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        setupScrollView()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let desiredOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top)
        UIApplication.shared.statusBarStyle = .lightContent
        self.scrollView.setContentOffset(desiredOffset, animated: true)
        fetchUser()
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
    }
    
    func setupScrollView(){
        //CONSTRAINTS DA SCROLLVIEW
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        //CONSTRAINTS DA IMAGEM DE CAPA
        scrollView.addSubview(coverImage)
        coverImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        coverImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: -20).isActive = true
        coverImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        coverImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        //CONSTRAINTS DA IMAGEM DE PERFIL
        scrollView.addSubview(profileImage)
        profileImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: coverImage.bottomAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 185).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 185).isActive = true
        
        //CONSTRAINTS DO NAMELABEL
        scrollView.addSubview(nameLabel)
        nameLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 34).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -24).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        //CONSTRAINTS DO SEPARADOR PARA LOGOUT
        scrollView.addSubview(nameSeparatorView)
        nameSeparatorView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: nameLabel.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //CONSTRAINTS DO BOTAO DE LOGOUT
        scrollView.addSubview(logoutButton)
        logoutButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        logoutButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 408).isActive = true
        logoutButton.widthAnchor.constraint(equalTo: nameLabel.widthAnchor).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //CONSTRAINTS DO SEPARADOR PARA LOGOUT
        scrollView.addSubview(logoutSeparatorView)
        logoutSeparatorView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        logoutSeparatorView.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: -12).isActive = true
        logoutSeparatorView.widthAnchor.constraint(equalTo: logoutButton.widthAnchor).isActive = true
        logoutSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //CONSTRAINTS DO BOTAO DE LOGOUT
        scrollView.addSubview(changePasswordButton)
        changePasswordButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        changePasswordButton.bottomAnchor.constraint(equalTo: logoutSeparatorView.topAnchor, constant: -12).isActive = true
        changePasswordButton.widthAnchor.constraint(equalTo: nameLabel.widthAnchor).isActive = true
        changePasswordButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //CONSTRAINTS DO SEPARADOR PARA TROCAR SENHA
        scrollView.addSubview(changePasswordSeparatorView)
        changePasswordSeparatorView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        changePasswordSeparatorView.bottomAnchor.constraint(equalTo: changePasswordButton.topAnchor, constant: -12).isActive = true
        changePasswordSeparatorView.widthAnchor.constraint(equalTo: logoutButton.widthAnchor).isActive = true
        changePasswordSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
