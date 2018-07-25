//
//  ChatLogController.swift
//  Chat
//
//  Created by Kaique Futemma on 16/07/18.
//  Copyright © 2018 Kaique Futemma. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import AVFoundation

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioRecorderDelegate {
    
    var messages = [Messages]()
    var bottomConstraint: NSLayoutConstraint?
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var user: User? {
        didSet{
            navigationItem.title = user?.name
            observeMessages()
        }
    }
    
    let cellId = "cellId"
    
    let containerView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.white
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
    
    lazy var uploadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "photo_camera")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
        
        return imageView
    }()
    
    lazy var recordImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mic_icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = UIColor.lightGray
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRecordTap)))
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        tabBarController?.tabBar.isHidden = true
        
        setupInputComponents()
        setupKeyboardObserves()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
        tabBarController?.tabBar.isHidden = true
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        cell.chatLogController = self
        
        let message = messages[indexPath.row]
        
        cell.textView.text = message.text
        
        setupCell(cell: cell, message: message)
        
        if let text = message.text {
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: text).width + /*32*/ 64
            cell.textView.isHidden = false
        }
        else if message.imageUrl != nil {
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.isHidden = true
        }
        
        if let seconds = message.timestamp?.doubleValue {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            let timestampDate = NSDate(timeIntervalSince1970: seconds)
            
            cell.timeView.text = dateFormatter.string(for: timestampDate)
        }
        
        return cell
    }
    
    private func uploadToFirebaseStorageUsingImage(image: UIImage) {
        let imageName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("message_images/\(imageName).jpg")
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.25) {
            ref.putData(uploadData, metadata: nil) { (metadata, error) in
                
                if error != nil {
                    print(error!)
                }
                
                ref.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if url != nil {
                        let profilePicUrl = url?.absoluteString
                        
                        self.sendMessageWithImageUrl(imageUrl: profilePicUrl!, image: image)
                    }
                })
            }
        }
    }
    
    private func sendMessageWithImageUrl(imageUrl: String, image: UIImage) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        
        let toId = user!.id!
        let fromId = Auth.auth().currentUser!.uid
        let timeStamp = NSDate().timeIntervalSince1970
        
        let values = ["toId": toId, "fromId": fromId, "timestamp": timeStamp, "imageUrl": imageUrl, "imageWidth": image.size.width, "imageHeight": image.size.height] as [String : Any]
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            let userMessagesRef = Database.database().reference().child("user-messages/\(fromId)/\(toId)")
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipienteUserMessagesRef = Database.database().reference().child("user-messages/\(toId)/\(fromId)")
            recipienteUserMessagesRef.updateChildValues([messageId: 1])
        }
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    private func setupCell(cell: ChatMessageCell, message: Messages) {
        
        if message.fromId == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.timeView.textColor = UIColor.white
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        }
        else {
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textView.textColor = UIColor.black
            cell.timeView.textColor = UIColor.gray
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        
        if let messageImageUrl = message.imageUrl {
            cell.messageImageView.isHidden = false
            cell.messageImageView.loadImagesUsingCacheWithUrlString(urlString: messageImageUrl)
            cell.backgroundColor = UIColor.clear
            cell.timeView.textColor = UIColor.white
        }
        else {
            cell.messageImageView.isHidden = true
        }
    }
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid, let toId = user?.id else {
            return
        }
        let userMessagesRef = Database.database().reference().child("user-messages/\(uid)/\(toId)")
        
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages/\(messageId)")
            
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                self.messages.append(Messages(dictionary: dictionary))
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    let indexPath = NSIndexPath(item: self.messages.count - 1 , section: 0)
                    self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        
        if let selectedImage = selectedImageFromPicker {
            
            uploadToFirebaseStorageUsingImage(image: selectedImage)
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupKeyboardObserves() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setupInputComponents() {
        
        view.addSubview(containerView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: containerView)
        bottomConstraint = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        containerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(uploadImageView)
        uploadImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        containerView.addSubview(recordImageView)
        recordImageView.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: 4).isActive = true
        recordImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        recordImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        recordImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        containerView.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: recordImageView.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(separatorView)
        separatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        let message = messages[indexPath.row]
        
        if let text = message.text {
            height = estimateFrameForText(text: text).height + 30
        }
        else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            height = CGFloat(imageHeight/imageWidth * 200)
        }
        
        let width = UIScreen.main.bounds.width
        
        return CGSize(width: width, height: height)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    func performZoomInForStartingImagemView(startingImageView: UIImageView) {
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {

            blackBackgroundView = UIView(frame: keyWindow.frame)
            
            self.blackBackgroundView?.backgroundColor = UIColor.black
            self.blackBackgroundView?.alpha = 0
            
            keyWindow.addSubview(blackBackgroundView!)
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackBackgroundView?.alpha = 1
                self.inputView?.alpha = 0
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
            }, completion: nil)
        }
    }
    
    func handleWithAudio(){
        recordingSession = AVAudioSession.sharedInstance()
        AVAudioSession.sharedInstance().requestRecordPermission({ (hasPermission) in
            if hasPermission {
                print("Aceito!")
            }
        })
    }
    
    @objc func handleRecordTap(){
        if audioRecorder == nil {
            let fileName =  getAudioFileURL()
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue]
            
            do {
                audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                recordImageView.image = UIImage(named: "stop_recording")
            }
            catch {
                displayAlert(title: "Erro", message: "Não foi possível gravar.")
            }
        }
        else {
            audioRecorder.stop()
            audioRecorder = nil
            recordImageView.image = UIImage(named: "mic_icon")
            
            let audioName = NSUUID().uuidString
            let fileName = getAudioFileURL()
            let ref = Storage.storage().reference().child("message_audios/\(audioName).m4a")
            
            ref.putFile(from: fileName, metadata: nil) { (metadea, error) in
                if error != nil {
                    print(error!)
                }
                ref.downloadURL(completion: { (url, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if url != nil {
                        let audioUrl = url?.absoluteString
                
                        self.sendAudioWithUrl(audioUrl: audioUrl!)
                    }
                })
            }
        }
    }
    
    private func sendAudioWithUrl(audioUrl: String) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        
        let toId = user!.id!
        let fromId = Auth.auth().currentUser!.uid
        let timeStamp = NSDate().timeIntervalSince1970
        
        let values = ["toId": toId, "fromId": fromId, "timestamp": timeStamp, "audioUrl": audioUrl] as [String : Any]
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            let userMessagesRef = Database.database().reference().child("user-messages/\(fromId)/\(toId)")
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipienteUserMessagesRef = Database.database().reference().child("user-messages/\(toId)/\(fromId)")
            recipienteUserMessagesRef.updateChildValues([messageId: 1])
        }
    }
    
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        
        return documentDirectory
    }
    
    func getAudioFileURL() -> URL {
        return getDirectory().appendingPathComponent(".m4a")
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Fechar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //FIM DO CÓDIGO ChatLogController.swift
}







