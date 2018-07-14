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
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize.height = 1400
        view.backgroundColor = UIColor.white
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = false
        
        return view
    }()
    
    let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "beach_image")
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "kaique")
        imageView.layer.cornerRadius = 185/2
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Kaique Futemma"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var logoutButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = UIColor.red
        button.setTitle("Sair da minha conta", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func handleLogout(_ sender: AnyObject?){
        do{
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    let logoutSeparatorView: UIView = {
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
        coverImage.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
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
        
        //CONSTRAINTS DO BOTAO DE LOGOUT
        scrollView.addSubview(logoutButton)
        logoutButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        logoutButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 800).isActive = true
        logoutButton.widthAnchor.constraint(equalTo: nameLabel.widthAnchor).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        /*CONSTRAINTS DO SEPARADOR PARA LOGOUT
        scrollView.addSubview(logoutSeparatorView)
        logoutSeparatorView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        logoutSeparatorView.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: -12).isActive = true
        logoutSeparatorView.widthAnchor.constraint(equalTo: nameLabel.widthAnchor).isActive = true
        logoutSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        */
 }
    

}
