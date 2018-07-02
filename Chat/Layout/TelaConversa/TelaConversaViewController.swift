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
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nomeUsuarios.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ControllerViewCell
        
        cell.nomeUsuarioCell.text = nomeUsuarios[indexPath.row]
        cell.previewConversaCell.text = conversaUsuarios[indexPath.row]
        cell.imagemUsuarioCell.image = imagemUsuarios[indexPath.row]
        
        //Navigation Bar layout
        navigationItem.title = "Conversas"
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white
    
        
        //tab bar layout
        
        
        
        //layout da celula
        cell.contentView.layer.cornerRadius = 5
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.white.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.contentView.backgroundColor = UIColor.lightGray
        
        cell.imagemUsuarioCell.layer.cornerRadius = cell.imagemUsuarioCell.frame.height/2
        cell.imagemUsuarioCell.clipsToBounds = true
        cell.imagemUsuarioCell.layer.borderWidth = 5.0
        cell.imagemUsuarioCell.layer.borderColor = UIColor.white.cgColor
        /*sombreado da celula */
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
 
        //layout do UIImageView
        cell.imagemUsuarioCell.layer.shadowColor = UIColor.gray.cgColor
        cell.imagemUsuarioCell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.imagemUsuarioCell.layer.shadowRadius = 4.0
        cell.imagemUsuarioCell.layer.shadowOpacity = 1.0
        cell.imagemUsuarioCell.layer.masksToBounds = false
        cell.imagemUsuarioCell.layer.shadowPath = UIBezierPath(roundedRect: cell.imagemUsuarioCell.bounds, cornerRadius: cell.imagemUsuarioCell.layer.cornerRadius).cgPath
        //*/
        return cell
    }
    
    
}
