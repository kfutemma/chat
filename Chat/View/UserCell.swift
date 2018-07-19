//
//  UserCell.swift
//  Chat
//
//  Created by Kaique Futemma on 17/07/18.
//  Copyright © 2018 Kaique Futemma. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "blue")
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 9.725
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 0, y: textLabel!.frame.origin.y + 100, width: self.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 0, y: detailTextLabel!.frame.origin.y + 100, width: self.frame.width, height: detailTextLabel!.frame.height)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        textLabel?.textAlignment = .center
        detailTextLabel?.textAlignment = .center
        setupImagesInCell()
        
    }
    
    func setupImagesInCell(){
        addSubview(coverImageView)
        coverImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        coverImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        coverImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        addSubview(profileImageView)
        profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
