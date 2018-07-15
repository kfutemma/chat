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
                print(snapshot)
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
        
        return self.users.count
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
        
}

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
        //imageView.image = UIImage(named: "denis")
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

