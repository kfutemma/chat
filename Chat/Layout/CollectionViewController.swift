//
//  CollectionViewController.swift
//  Chat
//
//  Created by Kaique Futemma on 04/06/18.
//  Copyright © 2018 Kaique Futemma. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    let nomeUsuarios = ["Kaique", "Cecilia", "Denis"]
    
    let imagemUsuarios = [UIImage(named: "kaique"), UIImage(named: "cecilia"), UIImage(named: "denis")]
    
    let conversaUsuarios = ["Oi, tudo bem?", "Olá!! como você está?", "E aí, cara. Beleza?"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
    }



    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return nomeUsuarios.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ControllerViewCell
        
        cell.nomeUsuario.text = nomeUsuarios[indexPath.row]
        cell.conversaUsuario.text = conversaUsuarios[indexPath.row]
        cell.imagemUsuario.image = imagemUsuarios[indexPath.row]
    
        return cell
    }



}
