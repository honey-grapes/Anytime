//
//  AddContactButton.swift
//  Anytime
//
//  Created by Josephine Chan on 10/20/22.
//

import SwiftUI

struct AddContactButton: View {
    var contactButtonText: String
    var contactButtonIcon: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 10){
                    Image(systemName: contactButtonIcon)
                        .font(.system(size: 60))
                        .tint(Color("Primary Opposite"))
                    Text(contactButtonText)
                        .font(.system(size: 25))
                        .foregroundColor(Color("Primary Opposite"))
        }
    }
}

struct AddContactButton_Previews: PreviewProvider {
    static var previews: some View {
        AddContactButton(contactButtonText: "讀取資料",contactButtonIcon: "camera.fill")
    }
}
