//
//  searchResult.swift
//  TripPlanner
//
//  Created by Hamster on 3/30/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import Foundation

struct User {
    var userID: String
    var username: String
    var firstname: String
    var lastname: String
    var profileImageID: String
    var contactList: [String]
    
    init() {
        userID = ""
        username = ""
        firstname = ""
        lastname = ""
        profileImageID = ""
        contactList = []
    }
}
