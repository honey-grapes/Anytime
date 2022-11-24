//
//  VerificationView.swift
//  Anytime (iOS)
//
//  Created by Josephine Chan on 11/6/22.
//

import SwiftUI

struct VerificationView: View {
    @ObservedObject var login: LoginModel
    //Go back to login page
    @Environment(\.presentationMode) var presentation
    
    func getCodeAtIndex(index: Int) -> String {
        if login.verCode.count > index {
            let current = login.verCode.index(login.verCode.startIndex, offsetBy: index)
            return String(login.verCode[current])
        }
        
        return ""
    }
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 20){
                //Header
                VStack(alignment: .leading, spacing: 10){
                    Text("已發送驗證碼 ✉️")
                        .font(.system(size: 42))
                        .bold()
                    //Preview of the number that the verification code sent to
                    Text(login.areaCode+"-"+login.userPhone)
                        .font(.system(size: 30))
                        .bold()
                        .foregroundColor(Color("Secondary"))
                }
                .padding(.top,30)
                
                Spacer()
                
                //User input for verification code
                VStack(alignment: .center, spacing: 15){
                    Text("請輸入驗證碼登入")
                        .font(.system(size: 25))
                        .bold()
                    
                    HStack{
                        TextField(
                            "點擊輸入驗證碼",
                            text: $login.verCode
                        )
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .keyboardType(.numberPad)
                    }
                    .padding()
                    .frame(height: 70)
                    .background(RoundedRectangle(cornerRadius: 20).stroke(Color("Background"), lineWidth: 3))
                    .font(.system(size: 20))
                    
                    //Submit button
                    Button (action: login.verifyCode, label: {
                        GenericButton(buttonText: "開始使用APP", bgColor:Color("Primary"), fgColor: Color("Primary Opposite"), height:70, fontSize:20, curve: 20)
                    })
                    
                    //Resend code
                    Button (action: login.resendCode, label: {
                        GenericButton(buttonText: "重新發送驗證碼", bgColor:Color("Secondary").opacity(0.8), fgColor: Color("Button Text"), height:70, fontSize:20, curve: 20)
                    })
                    
                    //Cancel and go back button
                    Button {
                        self.presentation.wrappedValue.dismiss()
                    } label: {
                        GenericButton(buttonText: "取消重來", bgColor:Color("Cancel"), fgColor: Color("Button Text"), height:70, fontSize:20, curve: 20)
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                Spacer()
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading,.trailing],40)
            .padding([.top,.bottom],20)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
            if login.showAlertVer {
                AlertView(show: $login.showAlertVer, inputToDelete: $login.verCode, errorMsg: login.alertMsgVer, buttonName: "重試")
            }
            
            if login.showAlertResend {
                AlertView(show: $login.showAlertResend, inputToDelete: $login.verCode, errorMsg: login.alertMsgResend, buttonName: "確認")
            }
            
            if login.loading {
                LoadView(show: $login.loading, content: "登入")
            }
        }
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView(login: LoginModel())
    }
}
