//
//  PostModel.swift
//  Anytime (iOS)
//
//  Created by Josephine Chan on 11/26/22.
//

import Foundation

struct PostModel: Identifiable {
    var id: String
    var author_uuid: String
    var liked: Bool
    var postPic: Data
}
