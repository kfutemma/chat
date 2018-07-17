//
//  NewMessageController.swift
//  Chat
//
//  Created by Kaique Futemma on 08/07/18.
//  Copyright © 2018 Kaique Futemma. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController, UISearchResultsUpdating {
    
    let cellId = "cellId"
    var users = [User]()
    var filteredUsers = [User]()
    
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
        tableView.contentInset = UIEdgeInsetsMake(7, 0, 0, 0)
        fetchUser()
    }
    
    func fetchUser(){
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.id = snapshot.key
                
                //print(snapshot)
                //user.setValuesForKeys(dictionary)
                user.email = dictionary["email"] as? String
                user.name = dictionary["name"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
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
        navigationItem.title = "Pesquisar"
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.hidesBarsOnSwipe = false
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        self.filterContent(searchText: self.searchController.searchBar.text!)
    }
    
    func filterContent(searchText: String) {
        
        self.filteredUsers = self.users.filter({ (user) -> Bool in
            let userName = user.email
            
            return (userName?.lowercased().contains(searchText.lowercased()))!
        })
        tableView.reloadData()
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredUsers.count
        }
        /*else if searchController.isActive && searchController.searchBar.text == "" {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "Faça uma pesquisa!"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }*/
        else/* if searchController.isActive && searchController.searchBar.text != "" && filteredUsers.count == 0*/{
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "Faça uma pesquisa!"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        
        let user : User
        
        if searchController.isActive && searchController.searchBar.text != "" {
            user = filteredUsers[indexPath.row]
        }
        else {
            user = self.users[indexPath.row]
        }
        
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImagesUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    var messagesController: MessageController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.messagesController?.showChatControllerForUser(user: user)
            self.dismiss(animated: true, completion: nil)
        }
    }
        
}

