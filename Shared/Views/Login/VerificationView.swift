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
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 20){
                //Header
                VStack(alignment: .center, spacing: 10){
                    (Text("已發送驗證碼 ") + Text(Image(systemName: "envelope.fill")))
                        .font(.system(size: 35))
                        .bold()
                    //Preview of the number that the verification code sent to
                    Text(login.areaCode+"-"+login.userPhone)
                        .font(.system(size: 28))
                        .bold()
                }
                .padding(.top,30)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color("Primary Opposite"))
                
                Spacer()
                
                VStack {
                    //User input for verification code
                    VStack(alignment: .center, spacing: 30){
                        Text("請輸入驗證碼登入")
                            .font(.system(size: 20))
                            .bold()
                        
                        HStack{
                            TextField(
                                "- - - - - -",
                                text: $login.verCode
                            )
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .keyboardType(.numberPad)
                            .font(.system(size: 55))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color("Secondary"))
                        }
                        .padding()
                        .frame(height: 70)
                        .font(.system(size: 20))
                        
                        VStack (spacing:10){
                            //Submit button
                            Button (action: login.verifyCode, label: {
                                GenericButton(buttonText: "開始使用APP", bgColor:Color("Primary"), fgColor: Color("Primary Opposite"), height:70, fontSize:20, curve: 30)
                            })
                            
                            //Resend code
                            Button (action: login.resendCode, label: {
                                GenericButton(buttonText: "重新發送驗證碼", bgColor:Color("Secondary").opacity(0.8), fgColor: Color("Button Text"), height:70, fontSize:20, curve: 30)
                            })
                            
                            //Cancel and go back button
                            Button {
                                self.presentation.wrappedValue.dismiss()
                            } label: {
                                GenericButton(buttonText: "取消重來", bgColor:Color("Cancel"), fgColor: Color("Button Text"), height:70, fontSize:20, curve: 30)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(20)
                .padding([.top], 25)
                .background(Color("Primary Opposite"))
                .cornerRadius(30)
                
                Spacer()
                Spacer()
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading,.trailing],40)
            .padding([.top,.bottom],20)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .foregroundColor(Color("Primary"))
            .background(Color("Primary Pink"))
            
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
