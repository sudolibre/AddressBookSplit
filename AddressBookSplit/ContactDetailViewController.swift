//
//  DetailViewController.swift
//  AddressBookSplit
//
//  Created by Jonathon Day on 1/24/17.
//  Copyright © 2017 dayj. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var familyNameLabel: UILabel!
    @IBOutlet var familyNameTextField: UITextField!
    @IBOutlet var givenNameTextField: UITextField!
    @IBOutlet var givenNameLabel: UILabel!
    @IBOutlet var notesLabel: UILabel!
    @IBOutlet var notesTextField: UITextField!
    @IBOutlet var birthdayLabel: UILabel!
    @IBOutlet var birthdayTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var phoneLabel: UILabel!
    var contact: Contact?
    var newContactFlow = false
    var onAddContact: ((Contact) -> Void)?

    func configureView() {
        if let contact = self.contact {
            let displayname = PersonNameComponentsFormatter.localizedString(from: contact.name, style: .default, options: [])
            self.navigationItem.title = displayname
            self.addressTextField.text   = contact.address
            self.addressLabel.text   = contact.address
            self.familyNameLabel.text  = contact.name.familyName
            self.familyNameTextField.text  = contact.name.familyName
            self.givenNameTextField.text  = contact.name.givenName!
            self.givenNameLabel.text   = contact.name.givenName!
            self.notesLabel.text   = contact.notes
            self.notesTextField.text   = contact.notes
            self.birthdayLabel.text   = contact.birthday
            self.birthdayTextField.text  = contact.birthday
            self.emailTextField.text   = contact.email
            self.emailLabel.text   = contact.email
            self.phoneTextField.text   = contact.phoneNumber
            self.phoneLabel.text  = contact.phoneNumber
        } else {
            self.navigationItem.title = "New Contact"
        }
        
        notesLabel.isHidden = isEditing
        birthdayLabel.isHidden = isEditing
        emailLabel.isHidden = isEditing
        phoneLabel.isHidden = isEditing
        addressLabel.isHidden = isEditing
        familyNameLabel.isHidden = isEditing
        givenNameLabel.isHidden = isEditing

        addressTextField.isHidden = !isEditing
        familyNameTextField.isHidden = !isEditing
        givenNameTextField.isHidden = !isEditing
        notesTextField.isHidden = !isEditing
        birthdayTextField.isHidden = !isEditing
        emailTextField.isHidden = !isEditing
        phoneTextField.isHidden = !isEditing


    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = self.editButtonItem
        if newContactFlow { isEditing = true }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing == false,
            let givenName = givenNameTextField.text,
            let familyName = familyNameTextField.text,
            let address = addressTextField.text,
            let email = emailTextField.text,
            let birthday = birthdayTextField.text,
            let phoneNumber = phoneTextField.text,
            let notes = notesTextField.text {
            if let add = onAddContact {
                contact = Contact(givenName: givenName, familyName: familyName, address: address, email: email, birthday: birthday, phoneNumber: phoneNumber, notes: notes)
                add(contact!)
                onAddContact = nil
            } else if let contactToUpdate = contact {
                var nameComponents = PersonNameComponents()
                nameComponents.familyName = familyName
                nameComponents.givenName = givenName
                contactToUpdate.name = nameComponents
                contactToUpdate.address = address
                contactToUpdate.birthday = birthday
                contactToUpdate.email = email
                contactToUpdate.notes = notes
                contactToUpdate.phoneNumber = phoneNumber
            } else {
                print("Save failed. No add closure or existing contact")
            }
        }
        configureView()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text,
            text.isEmpty == false else {
                return false
        }
        
        textField.resignFirstResponder()
        return true
    }
    
}

