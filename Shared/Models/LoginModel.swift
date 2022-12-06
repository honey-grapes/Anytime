//
//  LoginModel.swift
//  Anytime (iOS)
//
//  Created by Josephine Chan on 11/6/22.
//

import SwiftUI
import Firebase

class LoginModel: ObservableObject {
    @Published var areaCode = "+886"
    @Published var userPhone = ""
    
    //Verification code sent and received
    @Published var verCodeSent = ""
    @Published var verCode = ""
    @Published var showVerifyView = false
    
    //Alert message for code sending error
    @Published var showAlertPhone = false
    @Published var alertMsgPhone = "⚠️ 號碼錯誤，請重試"
    
    //Alert message for verification error
    @Published var showAlertVer = false
    @Published var alertMsgVer = "⚠️ 驗證碼錯誤，請重試"
    
    //Alert message for resending verification code
    @Published var showAlertResend = false
    @Published var alertMsgResend = "✅ 成功重新傳送驗證碼"
    
    //Launching loading view
    @Published var loading = false
    
    //Login status
    @AppStorage("login_status") var login_status = DefaultSettings.login_status
    @AppStorage("userNumber") var userNumber = DefaultSettings.userNumber
    @AppStorage("updateContact") var updateContact = DefaultSettings.updateContact
    @AppStorage("updatePosts") var updatePosts = DefaultSettings.updatePosts
    
    //Get reference to the Firestore
    let db = Firestore.firestore()
    
    //Computed user properties from FirebaseAuth
    var uuid: String? {
        Auth.auth().currentUser?.uid
    }
    var userIsAuthenticated: Bool {
        Auth.auth().currentUser != nil
    }
    
    //Add a collection for the user if it does not already exist in the Firestore
    func addUser() {
        guard userIsAuthenticated else { return }
        
        let ref = db.collection("users").document(self.uuid!)
        ref.getDocument { document, error in
            if let document = document, document.exists {}
            else {
                let userNumber = self.areaCode + self.userPhone
                ref.setData(["uuid": self.uuid!, "userNumber": userNumber])
            }
        }
    }
    
    //Send verification code
    func sendCode() {
        //Enable testing, comment out when not testing
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        
        //Turn on loading view
        self.loading = true
    
        PhoneAuthProvider.provider().verifyPhoneNumber(areaCode+userPhone, uiDelegate: nil){
            verCode, err in
            //Turn off loading view
            self.loading = false
            self.userNumber = self.areaCode + self.userPhone
            
            if err != nil {
                self.showAlertPhone.toggle()
                return
            }
            
            self.verCodeSent = verCode ?? ""
            self.showVerifyView = true
        }
    }
    
    func verifyCode() {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verCodeSent, verificationCode: verCode)
        
        //Turn on loading view
        self.loading = true
        
        Auth.auth().signIn(with: credential) {
            result, err in
            //Turn off loading view
            self.loading = false
            
            if err != nil {
                self.showAlertVer.toggle()
                return
            }
            
            //Logged in
            self.login_status = true
            self.updateContact = true
            self.updatePosts = true
            self.addUser()
        }
    }
    
    func resendCode() {
        sendCode()
        self.showAlertResend.toggle()
    }
}
