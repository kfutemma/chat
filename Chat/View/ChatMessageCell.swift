//
//  ChatMessageCell.swift
//  Chat
//
//  Created by Kaique Futemma on 18/07/18.
//  Copyright © 2018 Kaique Futemma. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    let textView:UITextView = {
        let text = UITextView()
        text.font = UIFont.systemFont(ofSize: 16)
        text.text = "OII, EU SOU O KAIQUE FUTEMMA!!!!!"
        text.textColor = UIColor.black
        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMessage()
    }
    
    func setupMessage() {
        addSubview(textView)
        
        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
