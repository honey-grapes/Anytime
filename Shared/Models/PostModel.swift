//
//  PostModel.swift
//  Anytime (iOS)
//
//  Created by Josephine Chan on 11/26/22.
//

import Foundation

struct PostModel: Identifiable {
    var id: String
    var date: String
    var authorPhone: String //If author's phone number matches contact list or self then show the post
    var authorName: String //Retrieved from UserDefaults and not stored in Firebase as people can use different names for this number
    var postPic: Data
    var liked: [String] //A list of contacts who liked the post
    var likedByMe: Bool
}
