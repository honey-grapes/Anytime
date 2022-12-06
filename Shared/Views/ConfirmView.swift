//
//  ConfirmView.swift
//  Anytime (iOS)
//
//  Created by Josephine Chan on 12/2/22.
//

import SwiftUI

struct ConfirmView: View {
    @Binding var show: Bool
    var msg: String
    var buttonName: String
    let action: (_ id: String) -> Void
    let id: String
    
    var body: some View {
        VStack{
            VStack(alignment: .center, spacing: 15){
                Text("確認")
                    .bold()
                    .font(.system(size: 20))
                
                Text(msg)
                
                Divider()
                
                Button(action: {
                    action(id)
                    show.toggle()
                }, label: {
                    GenericButton(buttonText: buttonName, bgColor: Color("Confirm"), fgColor: Color("Button Text"), height: 40, fontSize: 20, curve: 20)
                })
                
                Button(action: {
                    show.toggle()
                }, label: {
                    GenericButton(buttonText: "取消", bgColor: Color("Cancel"), fgColor: Color("Button Text"), height: 40, fontSize: 20, curve: 20)
                })
            }
            .frame(width: UIScreen.main.bounds.width - 180, alignment: .center)
            .padding([.top,.bottom],25)
            .padding([.leading,.trailing],25)
            .background(Color("Primary Opposite"))
            .cornerRadius(15)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(Color("Primary"))
        .background(Color.black.opacity(0.4).ignoresSafeArea())
    }
}

