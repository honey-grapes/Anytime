//
//  SettingsView.swift
//  Anytime (iOS)
//
//  Created by Josephine Chan on 11/7/22.
//

import SwiftUI
import Firebase

struct SettingsView: View {
    //App Storage
    @AppStorage("isDarkMode") var isDarkMode = DefaultSettings.darkMode
    @Binding var login_status: Bool
    @Binding var curTab: Tabs
    
    @State var logout_error: Bool = false
    
    //Go back to previous page
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 50){
                //Header
                Text("設定")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                
                //Switch light and dark modes
                VStack(spacing: 10){
                    Button{
                        isDarkMode.toggle()
                    } label: {
                        let sunMoonIcon = isDarkMode ? "sun.max" : "moon"
                        let lightDark = isDarkMode ? " 切換日間模式" : " 切換夜間模式"
                        (Text(Image(systemName: sunMoonIcon)) + Text(lightDark))
                            .font(.system(size: 20).bold())
                            .frame(maxWidth: .infinity)
                            .frame(height: 70)
                            .foregroundColor(Color("Primary Opposite"))
                            .background(Color("Primary"))
                            .cornerRadius(20)
                    }
                    
                    //Go back to previous page button
                    Button {
                        self.presentation.wrappedValue.dismiss()
                    } label: {
                        GenericButton(buttonText: "返回上一頁", bgColor:Color("Secondary"), fgColor: Color("Button Text"), height:70, fontSize:20, curve: 20)
                    }
                    
                    //Log out
                    Button(action: {
                        do {
                            try Auth.auth().signOut()
                            curTab = .contact
                            self.presentation.wrappedValue.dismiss()
                            withAnimation{login_status = false}
                        }
                        catch {
                            logout_error = true
                        }}, label: {
                        GenericButton(buttonText: "登出", bgColor:Color("Cancel"), fgColor: Color("Button Text"), height:70, fontSize:20, curve: 20)
                    })
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading,.trailing],40)
            .padding([.top,.bottom],20)
            
            if logout_error {
                AlertView(show: $logout_error, inputToDelete: .constant(""), errorMsg: "登出失敗", buttonName: "重試")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(login_status: .constant(false), curTab: .constant(.contact))
    }
}
