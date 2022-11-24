//
//  AlertView.swift
//  Anytime (iOS)
//
//  Created by Josephine Chan on 11/7/22.
//

import SwiftUI

struct AlertView: View {
    @Binding var show: Bool
    @Binding var inputToDelete: String
    var errorMsg: String
    var buttonName: String
    
    var body: some View {
        VStack{
            VStack(alignment: .center, spacing: 15){
                Text("提示")
                    .bold()
                    .font(.system(size: 20))
                
                Text(errorMsg)
                
                Divider()
                
                Button(action: {
                    inputToDelete = ""
                    show.toggle()
                }, label: {
                    GenericButton(buttonText: buttonName, bgColor: Color("Confirm"), fgColor: Color("Button Text"), height: 40, fontSize: 20, curve: 15)
                })
            }
            .frame(width: UIScreen.main.bounds.width - 180, alignment: .center)
            .padding([.top,.bottom],25)
            .padding([.leading,.trailing],25)
            .background(Color("Primary Opposite"))
            .cornerRadius(15)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.4).ignoresSafeArea())
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(show: .constant(true), inputToDelete: .constant("bro"), errorMsg: "⚠️ 驗證碼錯誤，請重試", buttonName: "重試")
    }
}
