//
//  Contact.swift
//  AddressBookSplit
//
//  Created by Jonathon Day on 1/24/17.
//  Copyright © 2017 dayj. All rights reserved.
//

import Foundation

class Contact {
    var name: PersonNameComponents
    var address: String
    var birthday: String
    var email: String
    var phoneNumber: String
    var notes: String
    
    
    init(givenName: String, familyName: String, address: String, email: String, birthday: String, phoneNumber: String, notes: String) {
        //TODO: make fields optional
        var nameComponents = PersonNameComponents()
        nameComponents.familyName = familyName
        nameComponents.givenName = givenName
        self.name = nameComponents
        self.address = address
        self.email = email
        self.birthday = birthday
        self.phoneNumber = phoneNumber
        self.notes = notes
    }
}
