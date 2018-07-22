//
//  MessageController
//  Chat
//
//  Created by Kaique Futemma on 02/07/18.
//  Copyright © 2018 Kaique Futemma. All rights reserved.
//

import UIKit
import Firebase

class MessageController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "Conversas"

        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(handleNewMessage))
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        
        checkIfUserIsLoggedIn()
        observeUserMessages()
    }
    
    static var messages = [Messages]()
    static var messagesDictionary = [String: Messages]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        UIApplication.shared.statusBarStyle = .default
        observeUserMessages()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func observeUserMessages() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages/\(uid)")
        
        ref.observe(.childAdded, with: { (snapshot) in

            let userId = snapshot.key
            Database.database().reference().child("user-messages/\(uid)/\(userId)").observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                let messagesReference = Database.database().reference().child("messages/\(messageId)")
                
                messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let message = Messages()
                        
                        message.fromId = dictionary["fromId"] as? String
                        message.toId = dictionary["toId"] as? String
                        message.text = dictionary["text"] as? String
                        message.timestamp = dictionary["timestamp"] as? NSNumber
                        
                        if let chatPartnerId = message.chatPartnerId() {
                            MessageController.messagesDictionary[chatPartnerId] = message
                        }
                        self.attemptReloadOfTable()
                    }
                }, withCancel: nil)
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    private func attemptReloadOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    var timer: Timer?
    
    @objc func handleReloadTable() {
        MessageController.messages = Array(MessageController.messagesDictionary.values)
        MessageController.messages.sort(by: { (message1, message2) -> Bool in
            return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
        })
        
        DispatchQueue.main.async(execute: {
            self.collectionView?.reloadData()
        })
    }
    
    func reloadCollection() {
        collectionView?.reloadData()
    }
    
    func showChatControllerForUser(user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    @objc func handleNewMessage(){
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    
    @objc func handleLogout(){
        do{
            try Auth.auth().signOut()
            MessageController.messages.removeAll()
            MessageController.messagesDictionary.removeAll()
            self.collectionView?.reloadData()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MessageController.messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        
        let message = MessageController.messages[indexPath.row]
        //----------------------

        if let id = message.chatPartnerId() {
            let ref = Database.database().reference().child("users/\(id)")
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    cell.nameLabel.text = dictionary["name"] as? String
                    
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String{
                        cell.profileImageView.loadImagesUsingCacheWithUrlString(urlString: profileImageUrl)
                    }
                }
            }, withCancel: nil)
        }
        //----------------------
        cell.messageLabel.text = message.text
        
        if let seconds = message.timestamp?.doubleValue {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            let timestampDate = NSDate(timeIntervalSince1970: seconds)
            
            /*let secondInDay: TimeInterval = 60 * 60 * 24
             
            if timestampDate > 7 * secondInDay {
                dateFormatter.dateFormat = "MM/dd/yy"
            }
            else if (timestampDate - secondInDay) > secondInDay {
                dateFormatter.dateFormat = "EEE"
            }
            */
            
            cell.timeLabel.text = dateFormatter.string(for: timestampDate)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: view.frame.width,height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let message = MessageController.messages[indexPath.item]
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = Database.database().reference().child("users/\(chatPartnerId)")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User()
            user.name = dictionary["name"] as? String
            user.email = dictionary["email"] as? String
            user.profileImageUrl = dictionary["profileImageUrl"] as? String
            user.id = chatPartnerId
            
            self.showChatControllerForUser(user: user)
            
        }, withCancel: nil)
    }
}

//COLOCAR EM OUTRA CLASSE. DAQUI PARA BAIXO

class MessageCell: BaseCell{
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        return view
    }()
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Kaique Futemma"
        lbl.font = UIFont.systemFont(ofSize: 18)
        
        return lbl
    }()
    
    let messageLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Thunder only happens when it's rainning."
        lbl.textColor = UIColor.darkGray
        lbl.font = UIFont.systemFont(ofSize: 14)
        
        return lbl
    }()
    
    let timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "12:05 pm"
        lbl.textAlignment = .right
        lbl.font = UIFont.systemFont(ofSize: 14)
        
        return lbl
    }()
    
    override func setupViews() {
        addSubview(profileImageView)
        addSubview(dividerLineView)
        setupContainerView()
        
        profileImageView.image = UIImage(named: "kaique")
        
        // CONSTRAINTS DA FOTO DE PERFIL
        addConstraintsWithFormat(format: "H:|-12-[v0(68)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(68)]", views: profileImageView)
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        // CONSTRAINTS DO SEPARADOR DE CONVERSA
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: dividerLineView)
        addConstraintsWithFormat(format: "V:|[v0(1)]|", views: dividerLineView)
    }
    
     func setupContainerView(){
        let containerView = UIView()
        addSubview(containerView)
        
        // CONSTRAINTS DO CONTAINER
        addConstraintsWithFormat(format: "H:|-90-[v0]|", views: containerView)
        addConstraintsWithFormat(format: "V:[v0(50)]", views: containerView)
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(timeLabel)
        // CONSTRAINTS DO CONTAINER
        addConstraintsWithFormat(format: "H:|[v0][v1(80)]-12-|", views: nameLabel, timeLabel)
        addConstraintsWithFormat(format: "V:|[v0][v1(24)]|", views: nameLabel, messageLabel)
        addConstraintsWithFormat(format: "H:|[v0]-12-|", views: messageLabel)
        addConstraintsWithFormat(format: "V:|[v0(24)]", views: timeLabel)
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(r: 0, g: 134, b: 249) : UIColor.white
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            timeLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            messageLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    
}

class BaseCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    func setupViews(){
        //TODO
    }
}





