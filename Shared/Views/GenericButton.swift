//
//  GenericButton.swift
//  Anytime
//
//  Created by Josephine Chan on 10/23/22.
//

import SwiftUI

struct GenericButton: View {
    var buttonText: String
    var bgColor: Color
    var fgColor: Color
    var height: CGFloat
    var fontSize: CGFloat
    var curve: CGFloat
    
    var body: some View {
        Text(buttonText)
            .font(.system(size: fontSize).bold())
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .foregroundColor(fgColor)
            .background(bgColor)
            .cornerRadius(curve)
    }
}

struct GenericButton_Previews: PreviewProvider {
    static var previews: some View {
        GenericButton(buttonText: "", bgColor: Color("Confirm"), fgColor: Color("Button Text"), height: 50, fontSize: 20, curve: 25)
    }
}
