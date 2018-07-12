//
//  NewMessageController.swift
//  Chat
//
//  Created by Kaique Futemma on 08/07/18.
//  Copyright © 2018 Kaique Futemma. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    var users = [User]()
    
    let searchController:UISearchController = {
        let search = UISearchController(searchResultsController:nil)
        search.dimsBackgroundDuringPresentation = false
        search.searchBar.autocapitalizationType = .none
        
        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }
    
    func fetchUser(){
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                print(snapshot)
                //user.setValuesForKeys(dictionary)
                user.email = dictionary["email"] as? String
                user.name = dictionary["name"] as? String
                self.users.append(user)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }
        
        
        /*
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            Database.database().reference().child("users").observeSingleEvent(of: .value) {
                (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let user = User()
                    
                    user.setValuesForKeys(dictionary)
                    self.users.append(user)
                    self.tableView.reloadData()
                    
                }
 
            }
        }*/
    }
    
    func setupNavigationBar(){
        //navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.hidesBarsOnSwipe = true
    }
    
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        return cell
    }

        
}

class UserCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

