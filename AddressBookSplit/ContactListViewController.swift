//
//  MasterViewController.swift
//  AddressBookSplit
//
//  Created by Jonathon Day on 1/24/17.
//  Copyright © 2017 dayj. All rights reserved.
//

import UIKit

class ContactListViewController: UITableViewController {

    var contactDetailVC: ContactDetailViewController? = nil
    var dataSource: ContactsDataSource!

    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showContactDetail", sender: sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Contacts"
        
        dataSource = ContactsDataSource()
        tableView.dataSource = dataSource
        dataSource.registerCellForTableView(tableView)
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.contactDetailVC = (controllers[controllers.count-1] as! UINavigationController).topViewController as? ContactDetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

//TODO: remove
//    func insertNewContact(_ sender: Any) {
//        dataSource.contacts.insert(Contact(), at: 0)
//        let indexPath = IndexPath(row: 0, section: 0)
//        self.tableView.insertRows(at: [indexPath], with: .automatic)
//    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContactDetail" && sender is UIBarButtonItem {
            let contactCreateVC = (segue.destination as! UINavigationController).topViewController as! ContactDetailViewController
            contactCreateVC.newContactFlow = true
            contactCreateVC.onAddContact = { [weak self] (contact) in
                self?.dataSource.contacts.append(contact)
            }
            contactCreateVC.navigationItem.leftItemsSupplementBackButton = true
        }
        if segue.identifier == "showContactDetail" && sender is UITableView {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let contact = dataSource.contacts[indexPath.row]
                let contactDetailVC = (segue.destination as! UINavigationController).topViewController as! ContactDetailViewController
                contactDetailVC.contact = contact
                contactDetailVC.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                contactDetailVC.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showContactDetail", sender: tableView)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataSource.contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

class ContactsDataSource: NSObject, UITableViewDataSource {
    var contacts = [Contact]()
    var reuseIdentifier = "contactCell"
    
    func registerCellForTableView(_ tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        let contact = contacts[indexPath.row]
        //TODO: Use name formatter here
        let displayName = PersonNameComponentsFormatter.localizedString(from: contact.name, style: .default, options: [])
        cell.textLabel!.text = displayName
        return cell
    }

}

