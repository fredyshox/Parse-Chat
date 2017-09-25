//
//  FriendsTableViewController.swift
//  ParseTest
//
//  Created by Kacper Raczy on 24.09.2017.
//  Copyright © 2017 Kacper Raczy. All rights reserved.
//

import UIKit
import Parse

class FriendsTableViewController: UITableViewController {
    var users = [PFUser]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Users"
        initLogoutButton()
        
        let predicate = NSPredicate(format: "username != %@", PFUser.current()!.username!)
        let query = PFUser.query(with: predicate)
        query?.findObjectsInBackground(block: { (objects, err) in
            if err != nil {
                print("Error while downloading users")
                print(err!.localizedDescription)
            }else {
                if let users = objects as? [PFUser] {
                    self.users = users
                }
            }
        })
    }
    
    func initLogoutButton() {
        let button = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOut))
        print("initializing logout")
        self.navigationItem.leftBarButtonItem = button
    }
    
    @objc func logOut() {
        PFUser.logOutInBackground { (err) in
            if let error = err {
                print(error.localizedDescription)
            }else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].username
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "chatSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch(identifier) {
            case "chatSegue":
                if let vc = segue.destination as? ChatViewController {
                    if let indexPath = sender as? IndexPath {
                        let uid = PFUser.current()!.objectId!
                        let selectedId = users[indexPath.row].objectId!
                        let conversationId = selectedId<uid ? selectedId+uid : uid+selectedId
                        vc.conversationId = conversationId
                        vc.title = users[indexPath.row].username
                    }
                }
            default: return
            }
        }
    }
    

}
