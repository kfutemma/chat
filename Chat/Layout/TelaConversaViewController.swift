//
//  ViewController.swift
//  Chat
//
//  Created by Kaique Futemma on 23/05/18.
//  Copyright © 2018 Kaique Futemma. All rights reserved.
//

import UIKit

class TelaConversaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let nomeUsuarios = ["Kaique", "Cecilia", "Denis"]
    
    let imagemUsuarios = [UIImage(named: "kaique"), UIImage(named: "cecilia"), UIImage(named: "denis")]
    
    let conversaUsuarios = ["Oi, tudo bem?", "Olá!! como você está?", "E aí, cara. Beleza?"]    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nomeUsuarios.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ControllerViewCell
        
        
        cell.nomeUsuarioCell.text = nomeUsuarios[indexPath.row]
        cell.previewConversaCell.text = conversaUsuarios[indexPath.row]
        cell.imagemUsuarioCell.image = imagemUsuarios[indexPath.row]
        
        
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
 
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    
}

