//
//  ChatLogController.swift
//  Chat
//
//  Created by Kaique Futemma on 16/07/18.
//  Copyright © 2018 Kaique Futemma. All rights reserved.
//

import UIKit
import Firebase


class ChatLogController: UICollectionViewController, UITextFieldDelegate  {
    
    var user: User? {
        didSet{
            navigationItem.title = user?.name
        }
    }
    
    let containerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        return container
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Enviar", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleSend() {
        
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        
        let toId = user!.id!
        let fromId = Auth.auth().currentUser!.uid
        let timeStamp = NSDate().timeIntervalSince1970
        
        if let inputTextField = inputTextField.text {
            let values = ["text": inputTextField, "toId": toId, "fromId": fromId, "timestamp": timeStamp] as [String : Any]
            childRef.updateChildValues(values)
        }
        inputTextField.text = ""        
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Digite uma mensagem"
        textField.backgroundColor = UIColor.white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
        return textField
    }()
    
    let separatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        return separator
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        collectionView?.backgroundColor = UIColor.white
        
        setupInputComponents()
    }
    
    func setupInputComponents() {
        
        
        view.addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        containerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(separatorView)
        separatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func  textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
