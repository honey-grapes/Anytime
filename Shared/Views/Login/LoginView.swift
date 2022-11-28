//
//  LoginView.swift
//  Anytime (iOS)
//
//  Created by Josephine Chan on 11/5/22.
//

import SwiftUI

struct LoginView: View {
    @StateObject var login = LoginModel()
    @FocusState private var phoneFieldIsFocused: Bool
    
    //Check if phone number is acceptable
    var isAcceptable: Bool {
        return CharacterSet(charactersIn: login.userPhone).isSubset(of: CharacterSet.decimalDigits) && login.userPhone.count >= 8
    }
    
    //Check if phone number contains non-numerical values
    var isNotNumber: Bool {
        return !CharacterSet(charactersIn: login.userPhone).isSubset(of: CharacterSet.decimalDigits)
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading,spacing: 20) {
                //Header
                VStack(alignment: .leading, spacing: 10){
                    Text("您好！")
                        .font(.system(size: 48))
                        .bold()
                    
                    (Text("歡迎使用") + Text("通話易 🎉").foregroundColor(Color("Primary Pink")))
                        .font(.system(size: 35))
                        .bold()
                        .foregroundColor(Color("Secondary"))
                }
                .padding(.top,30)
                
                Spacer()
                
                //User input
                VStack(alignment: .center, spacing: 20){
                    Text("請輸入您的手機號碼")
                        .font(.system(size: 25))
                        .bold()
                    
                    VStack(alignment: .center, spacing: 15){
                        //Input area code
                        HStack(spacing: 20){
                            Picker(selection: $login.areaCode, label: Text("")) {
                                Text("+1").tag("+1")
                                Text("+886").tag("+886")
                            }
                            .scaleEffect(1.2)
                            .accentColor(Color("Primary"))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("Background"))
                            .cornerRadius(30)
                        }
                           
                        //Input phone number
                        HStack{
                            TextField(
                                "點擊輸入電話號碼",
                                text: $login.userPhone
                            )
                            .focused($phoneFieldIsFocused)
                            .onAppear {
                                //Set up the initial value for FocusState
                                DispatchQueue.main.async {
                                    phoneFieldIsFocused = true
                                }
                            }
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .keyboardType(.numberPad)
                            
                            if isNotNumber{
                                Image(systemName: "x.circle.fill")
                                    .font(.system(size: 25))
                                    .foregroundColor(Color("Cancel"))
                            }
                            else if isAcceptable {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 25))
                                    .foregroundColor(Color("Confirm"))
                            }
                        }
                        .padding()
                        .padding([.leading,.trailing],15)
                        .frame(height: 70)
                        .background(Color("Background"))
                        .font(.system(size: 20))
                        .cornerRadius(30)
                        
                        //Warning for non-numerical value
                        if isNotNumber{
                            Text("請只輸入數字")
                                .font(.system(size: 20))
                                .foregroundColor(Color("Cancel"))
                        }
                        
                        //Submit button
                        NavigationLink(destination: VerificationView(login: login), isActive: $login.showVerifyView){
                            Button(action: login.sendCode,
                                   label: {
                                GenericButton(buttonText: "獲取驗證碼", bgColor: isAcceptable ? Color("Primary Pink"): Color("Primary Pink").opacity(0.6), fgColor: Color("Primary Opposite"), height:70, fontSize:20, curve: 30)
                            })
                            .disabled(!isAcceptable)
                        }
                        .disabled(!isAcceptable)
                    }
                }
                
                Spacer()
                Spacer()
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading,.trailing],40)
            .padding([.top,.bottom],20)
            .foregroundColor(Color("Primary"))
            
            if login.showAlertPhone {
                AlertView(show: $login.showAlertPhone, inputToDelete: $login.userPhone, errorMsg: login.alertMsgPhone, buttonName: "重試")
            }
            
            if login.loading {
                LoadView(show: $login.loading, content: "傳送驗證碼")
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
