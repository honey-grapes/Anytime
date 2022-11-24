//
//  UserModel.swift
//  Anytime (iOS)
//
//  Created by Josephine Chan on 11/8/22.
//

import Foundation

struct ContactModel: Identifiable {
    var id: String { phoneNumber }
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var profilePic: Data
}
