//
//  AddView.swift
//  Anytime
//
//  Created by Josephine Chan on 10/18/22.
//

import SwiftUI
import VisionKit
import Firebase
import FirebaseStorage

@available(iOS 16.0, *)
struct AddView: View {
    //Scanner variables
    @State private var cameraPresented = false
    @State private var scanResult: String = ""
    @State private var scannerAvailable = false
    @State private var scannerNotAvailableAlert = false
    
    //Contact info
    @State private var lastName: String = ""
    @State private var firstName: String = ""
    @State private var phoneNumber: String = ""
    @State private var areaCode: String = ""
    
    //Image picker variables
    @State var imagePicked: Data = .init(capacity: 0)
    @State var imagePickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State var showImagePicker = false
    
    //Computed user properties from FirebaseAuth
    var uuid: String? {
        Auth.auth().currentUser?.uid
    }
    
    //Notification when contact is successfully added
    @State var contactAdded = false
    
    //Tell contactView to update contacts
    @AppStorage("updateContact") var updateContact = DefaultSettings.updateContact
    
    //Function to upload image to Firebase Storage
    @State var photoUploaded = false
    func uploadContact() {
        //Create storage reference and file path
        let storageRef = Storage.storage().reference()
        let imagePath = "images/\(self.uuid!)/\(phoneNumber).png"
        let fileRef = storageRef.child(imagePath)
        
        //Upload image to storage then save a contact into Firestore
        let uploadTask = fileRef.putData(imagePicked) { metadata, error in
            contactAdded = true //For notification
            updateContact = true //For re-fetching contacts
            
            //Check for errors
            if error == nil && metadata != nil {
                //Get reference to the Firestore
                let db = Firestore.firestore()
                //Save to Firestore
                let fullNumber = self.areaCode + self.phoneNumber
                db.collection("users").document(self.uuid!).collection("contacts").document(fullNumber).setData([
                    "firstName": self.firstName,
                    "lastName": self.lastName,
                    "phoneNumber": fullNumber,
                    "profilePicURL": imagePath
                ])
                //Remove contact information after successfully adding contact to Firestore
                firstName = ""
                lastName = ""
                phoneNumber = ""
                imagePicked.removeAll(keepingCapacity: false)
                scanResult = ""
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading){
                //Body content
                ScrollView(.vertical){
                    VStack(spacing: 40){
                        //Step 1: Setting up the area code
                        VStack(alignment: .leading, spacing: 20){
                            HStack{
                                Image(systemName: "chevron.right.square.fill")
                                    .font(.system(size:30))
                                Text("步驟一")
                                    .font(.system(size:30))
                                    .bold()
                            }
                            
                            (Text("請選擇聯絡人的")+Text("電話區號").bold())
                                .font(.system(size:20))
                                .lineSpacing(5)
                            
                            //Input area code
                            HStack(spacing: 20){
                                Text("電話區號")
                                    .font(.system(size: 20))
                                    .bold()
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(5)
                                
                                Picker(selection: $areaCode, label: Text("")) {
                                    Text("+1").tag("+1")
                                    Text("+886").tag("+886")
                                }
                                .scaleEffect(1.2)
                                .accentColor(Color("Primary"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(RoundedRectangle(cornerRadius: 15).stroke(Color("Primary"), lineWidth: 3))
                            }
                        }
                        
                        //=========================================================
                        //
                        //Step 2 Upload photo for reading contact information
                        //
                        //=========================================================
                        VStack(alignment: .leading, spacing: 20){
                            HStack{
                                Image(systemName: "chevron.right.square.fill")
                                    .font(.system(size:30))
                                Text("步驟二")
                                    .font(.system(size:30))
                                    .bold()
                            }
                            //Sample info for reference
                            (Text("請在白紙上")+Text("分三行工整書寫").bold()+Text("聯絡人姓、名、電話。範例："))
                                .font(.system(size:20))
                                .lineSpacing(5)
                            Text("王\n小明\n12345678")
                                .font(.system(size:25).bold())
                                .lineSpacing(10)
                                .frame(maxWidth: .infinity)
                                .frame(height: 150)
                                .multilineTextAlignment(.center)
                                .background(RoundedRectangle(cornerRadius: 30).stroke(Color("Primary"), lineWidth: 5))
                        }
                        
                        //Turn on text scanner button
                        VStack(alignment: .leading, spacing: 20){
                            VStack(alignment: .leading, spacing: 5){
                                (Text("接下來，請按以下 ") +
                                 Text(Image(systemName: "camera.fill")) +
                                 Text(" 相機按鈕，讓手機讀取聯絡人資料"))
                                    .font(.system(size:20))
                                    .lineSpacing(5)
                            }
                            
                            //Presenting the data scanner sheet
                            VStack {
                                Button{
                                    if scannerAvailable {
                                        cameraPresented = true
                                    }
                                    else {
                                        scannerNotAvailableAlert = true
                                    }
                                } label:{
                                    AddContactButton(contactButtonText: "讀取資料", contactButtonIcon: "camera.fill")
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                                .background(Color("Primary"))
                                .cornerRadius(20)
                            }
                            .sheet(isPresented: $cameraPresented) {
                                ScannerView(openScanner: $cameraPresented, scanResult: $scanResult, lastName: $lastName, firstName: $firstName, phoneNumber: $phoneNumber)
                            }
                            .alert("Scanner not available", isPresented: $scannerNotAvailableAlert, actions:{})
                            .onAppear {
                                scannerAvailable = (DataScannerViewController.isSupported && DataScannerViewController.isAvailable)
                            }
                            
                            //Present the scan result to the user to show that the data has been successfully scanned
                            if scanResult != "" {
                            HStack{
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 80))
                                        .foregroundColor(Color("Green Check"))
                                        .padding([.leading],20)
                                
                                    (Text("讀取成功\n").font(.system(size: 35)).bold() + Text("\n").font(.system(size: 5)) + (Text("姓氏： " + lastName + "\n") + Text("名字： " + firstName + "\n") + Text("電話： " + phoneNumber))
                                            .font(.system(size: 20)))
                                            .padding()
                                            .foregroundColor(Color("Primary"))
                                            .frame(height: 180)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .background(RoundedRectangle(cornerRadius: 25).stroke(Color("Green Check"), lineWidth: 5))
                           }
                        }
                        
                        //=========================================================
                        //
                        //Step 3: Upload profile picture for contact
                        //
                        //=========================================================
                        VStack(alignment: .leading, spacing: 20){
                            //Step 3 label
                            HStack{
                                Image(systemName: "chevron.right.square.fill")
                                    .font(.system(size:30))
                                Text("步驟三")
                                    .font(.system(size:30))
                                    .bold()
                            }
                            //Step 3 instruction
                            Text("請用以下其中一種方式設定聯絡人的頭像")
                                .font(.system(size:20))
                                .lineSpacing(5)
                            
                            //Upload from camera
                            Button{
                                showImagePicker = true
                                imagePickerSource = .camera
                            } label:{
                                AddContactButton(contactButtonText: "現場照相", contactButtonIcon: "camera.fill")
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .background(Color("Primary"))
                            .cornerRadius(20)
                            .sheet(isPresented: $showImagePicker) {
                                ImagePickerView(imagePicked: $imagePicked, imagePickerSource: $imagePickerSource, showImagePicker: $showImagePicker)
                            }
                            
                            Text("或者")
                                .frame(maxWidth: .infinity, alignment:.center)
                                .font(.system(size:20))
                            
                            //Upload from photo album
                            Button{
                                showImagePicker = true
                                imagePickerSource = .photoLibrary
                            } label:{
                                AddContactButton(contactButtonText: "從相簿選取", contactButtonIcon: "rectangle.stack.fill.badge.plus")
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .background(Color("Primary"))
                            .cornerRadius(20)
                            .sheet(isPresented: $showImagePicker) {
                                ImagePickerView(imagePicked: $imagePicked, imagePickerSource: $imagePickerSource, showImagePicker: $showImagePicker)
                            }
                            
                            //Present the image picker result
                            if imagePicked.count != 0 {
                                VStack{
                                    (Text(Image(systemName: "checkmark.circle.fill"))
                                            .font(.system(size: 50))
                                            .foregroundColor(Color("Green Check"))
                                     + Text(" 頭像選取成功")
                                            .font(.system(size: 30))
                                            .bold()
                                            .foregroundColor(Color("Primary")))
                                        .padding([.top,.leading,.trailing], 20)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Image(uiImage:UIImage(data: self.imagePicked)!)
                                        .resizable()
                                        .frame(alignment: .center)
                                        .frame(maxWidth: .infinity)
                                        .scaledToFill()
                                        .padding([.leading,.trailing],20)
                                    
                                    //Clear and remove image
                                    Button {
                                        imagePicked.removeAll(keepingCapacity: false)
                                    } label: {
                                        GenericButton(buttonText: "清除圖片重來", bgColor: Color("Cancel"), fgColor: Color("Button Text"), height: 70, fontSize: 20, curve: 20)
                                    }
                                    .padding([.bottom, .leading, .trailing], 20)
                                }
                                .background(RoundedRectangle(cornerRadius: 25).stroke(Color("Green Check"), lineWidth: 5))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading,.trailing],40)
                    .padding([.top],20)
                    .background(Color("Background"))
                    
                    //Submit or cancel
                    VStack(alignment: .leading, spacing: 10){
                        Button{
                            uploadContact()
                        } label:{
                            GenericButton(buttonText: "添加聯絡人", bgColor: (photoUploaded && scanResult != "") ? Color("Confirm") : Color("Confirm").opacity(0.7), fgColor: Color("Button Text"), height:70, fontSize:20, curve: 20)
                        }
                        .disabled(photoUploaded && scanResult != "")
                        
                        Button{
                            firstName = ""
                            lastName = ""
                            phoneNumber = ""
                            areaCode = ""
                            imagePicked.removeAll(keepingCapacity: false)
                            scanResult = ""
                        } label:{
                            GenericButton(buttonText: "重新來過", bgColor: Color("Cancel"), fgColor: Color("Button Text"), height:70, fontSize:20, curve: 20)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading,.trailing],40)
                    .padding([.bottom],20)
                    .padding([.top], 10)
                }
            }
            
            if contactAdded {
                AlertView(show: $contactAdded, inputToDelete: .constant(""), errorMsg: "成功添加聯絡人", buttonName: "確認")
            }
        }
    }
}

@available(iOS 16.0, *)
struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}

