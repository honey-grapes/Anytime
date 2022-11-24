//
//  ATTabButton.swift
//  Anytime
//
//  Created by Josephine Chan on 10/19/22.
//

import SwiftUI

struct ATTabButton: View {
    var buttonLabel: String
    var buttonIcon: String
    var isActive: Bool
    
    var body: some View {
        let iconColor = isActive ? Color("Primary") : Color("Secondary")
        
        VStack (alignment: .center, spacing: 7){
            Image(systemName: buttonIcon)
                .font(.system(size:50))
                .foregroundColor(iconColor)
            Text(buttonLabel)
                .font(.system(size:35))
                .foregroundColor(iconColor)
        }
    }
}

struct ATTabButton_Previews: PreviewProvider {
    static var previews: some View {
        ATTabButton(buttonLabel: "通話", buttonIcon: "phone.circle.fill", isActive: true)
    }
}
