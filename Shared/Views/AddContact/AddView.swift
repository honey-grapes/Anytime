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
    @State private var areaCode: String = "+1"
    
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
    
    //Function to upload contact to Firebase Storage
    func uploadContact() {
        //Create storage reference and file path
        let storageRef = Storage.storage().reference()
        let imagePath = "images/\(self.uuid!)/\(phoneNumber).png"
        let fileRef = storageRef.child(imagePath)
        
        //Upload image to storage then save a contact into Firestore
        fileRef.putData(imagePicked) { metadata, error in
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
                            //Step 1 label
                            HStack{
                                Image(systemName: "chevron.right.square.fill")
                                    .font(.system(size:25))
                                Text("?????????")
                                    .font(.system(size:25))
                                    .bold()
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .foregroundColor(Color("Button Text"))
                            .background(Color("Primary Pink"))
                            .cornerRadius(30)
                            
                            VStack (alignment: .leading) {
                                (Text("?????????????????????")+Text("????????????").bold())
                                    .font(.system(size:20))
                                    .lineSpacing(5)
                                
                                //Input area code
                                HStack(spacing: 20){
                                    Text("????????????")
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
                                    .background(Color("Light"))
                                    .cornerRadius(15)
                                }
                            }
                            .padding([.leading,.trailing],15)
                        }
                        .foregroundColor(Color("Primary"))
                        
                        //=========================================================
                        //
                        //Step 2 Upload photo for reading contact information
                        //
                        //=========================================================
                        VStack(alignment: .leading, spacing: 20){
                            //Step 2 label
                            HStack{
                                Image(systemName: "chevron.right.square.fill")
                                    .font(.system(size:25))
                                Text("?????????")
                                    .font(.system(size:25))
                                    .bold()
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .foregroundColor(Color("Button Text"))
                            .background(Color("Primary Pink"))
                            .cornerRadius(30)
                            
                            VStack (alignment: .leading){
                                //Sample info for reference
                                (Text("???????????????")+Text("?????????????????????").bold()+Text("???????????????????????????????????????"))
                                    .font(.system(size:20))
                                    .lineSpacing(5)
                                Text("???\n??????\n12345678")
                                    .font(.system(size:25).bold())
                                    .lineSpacing(10)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 150)
                                    .multilineTextAlignment(.center)
                                    .background(Color("Light"))
                                    .cornerRadius(20)
                            }
                            .padding([.leading,.trailing],15)
                        }
                        .foregroundColor(Color("Primary"))
                        
                        //Turn on text scanner button
                        VStack(alignment: .leading, spacing: 20){
                            VStack(alignment: .leading, spacing: 5){
                                (Text("???????????????????????? ") +
                                 Text(Image(systemName: "camera.fill")) +
                                 Text(" ?????????????????????????????????????????????"))
                                    .font(.system(size:20))
                                    .lineSpacing(5)
                            }
                            .foregroundColor(Color("Primary"))
                            
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
                                    AddContactButton(contactButtonText: "????????????", contactButtonIcon: "camera.fill", color: "Primary Opposite")
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                                .background(Color("Primary"))
                                .cornerRadius(20)
                            }
                            .sheet(isPresented: $cameraPresented) {
                                ScannerView(openScanner: $cameraPresented, scanResult: $scanResult, lastName: $lastName, firstName: $firstName, phoneNumber: $phoneNumber)
                            }
                            .alert("????????????", isPresented: $scannerNotAvailableAlert, actions:{})
                            .onAppear {
                                scannerAvailable = (DataScannerViewController.isSupported && DataScannerViewController.isAvailable)
                            }
                            
                            //Present the scan result to the user to show that the data has been successfully scanned
                            if scanResult != "" {
                                VStack(spacing: 5){
                                    HStack{
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 80))
                                            .padding([.leading],20)
                                        
                                        (Text("????????????\n").font(.system(size: 35)).bold().foregroundColor(Color("Primary Pink")) + Text("\n").font(.system(size: 5)) + (Text("????????? " + lastName + "\n") + Text("????????? " + firstName + "\n") + Text("????????? " + phoneNumber))
                                                .font(.system(size: 18)))
                                                .padding()
                                                .frame(height: 150)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .foregroundColor(Color("Primary"))
                                    }
                                    
                                    //Clear and remove info
                                    Button {
                                        lastName = ""
                                        firstName = ""
                                        phoneNumber = ""
                                        scanResult = ""
                                    } label: {
                                        GenericButton(buttonText: "??????????????????", bgColor: Color("Cancel"), fgColor: Color("Button Text"), height: 70, fontSize: 20, curve: 20)
                                    }
                                    .padding([.bottom, .leading, .trailing], 20)
                                }
                                .foregroundColor(Color("Primary Pink"))
                                .background(Color("Primary Opposite"))
                                .cornerRadius(20)
                            }
                        }
                        .padding([.leading,.trailing],15)
                        
                        //=========================================================
                        //
                        //Step 3: Upload profile picture for contact
                        //
                        //=========================================================
                        VStack(alignment: .leading, spacing: 20){
                            //Step 3 label
                            HStack{
                                Image(systemName: "chevron.right.square.fill")
                                    .font(.system(size:25))
                                Text("?????????")
                                    .font(.system(size:25))
                                    .bold()
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .foregroundColor(Color("Button Text"))
                            .background(Color("Primary Pink"))
                            .cornerRadius(30)
                            
                            VStack (alignment: .leading){
                                //Step 3 instruction
                                Text("??????????????????????????????????????????????????????")
                                    .font(.system(size:20))
                                    .lineSpacing(5)
                                    .foregroundColor(Color("Primary"))
                                
                                //Upload from camera
                                Button{
                                    showImagePicker = true
                                    imagePickerSource = .camera
                                } label:{
                                    AddContactButton(contactButtonText: "????????????", contactButtonIcon: "camera.fill", color: "Primary Opposite")
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                                .background(Color("Primary"))
                                .cornerRadius(20)
                                .sheet(isPresented: $showImagePicker) {
                                    ImagePickerView(imagePicked: $imagePicked, imagePickerSource: $imagePickerSource, showImagePicker: $showImagePicker)
                                }
                                
                                Text("??????")
                                    .frame(maxWidth: .infinity, alignment:.center)
                                    .font(.system(size:20))
                                    .foregroundColor(Color("Primary"))
                                
                                //Upload from photo album
                                Button{
                                    showImagePicker = true
                                    imagePickerSource = .photoLibrary
                                } label:{
                                    AddContactButton(contactButtonText: "???????????????", contactButtonIcon: "rectangle.stack.fill.badge.plus", color: "Primary Opposite")
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
                                    VStack (spacing: 0){
                                        HStack(alignment: .center, spacing: 5){
                                            Text(Image(systemName: "checkmark.circle.fill"))
                                                .font(.system(size: 55))
                                            
                                            Text(" ??????????????????")
                                                .font(.system(size: 30))
                                                .bold()
                                        }
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .foregroundColor(Color("Primary Pink"))
                                        .padding([.top,.trailing], 20)
                                        .padding(.leading,10)
                    
                                        Image(uiImage:UIImage(data: self.imagePicked)!)
                                            .resizable()
                                            .frame(alignment: .center)
                                            .frame(maxWidth: .infinity)
                                            .scaledToFill()
                                            .padding(20)
                                        
                                        //Clear and remove image
                                        Button {
                                            imagePicked.removeAll(keepingCapacity: false)
                                        } label: {
                                            GenericButton(buttonText: "??????????????????", bgColor: Color("Cancel"), fgColor: Color("Button Text"), height: 70, fontSize: 20, curve: 20)
                                        }
                                        .padding([.leading,.trailing,.bottom],20)
                                    }
                                    .foregroundColor(Color("Primary"))
                                    .background(Color("Primary Opposite"))
                                    .cornerRadius(20)
                                    .padding(.top,15)
                                }
                            }
                            .padding([.leading,.trailing],15)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading,.trailing],25)
                    .padding([.top],20)
                    
                    //Submit or cancel
                    VStack(alignment: .leading, spacing: 10){
                        Button{
                            uploadContact()
                        } label:{
                            GenericButton(buttonText: "???????????????", bgColor: (imagePicked.count > 0 && scanResult != "") ? Color("Confirm") : Color("Confirm").opacity(0.5), fgColor: Color("Button Text"), height:70, fontSize:20, curve: 30)
                        }
                        .disabled(!(imagePicked.count > 0 && scanResult != ""))
                        
                        Button{
                            firstName = ""
                            lastName = ""
                            phoneNumber = ""
                            areaCode = ""
                            imagePicked.removeAll(keepingCapacity: false)
                            scanResult = ""
                        } label:{
                            GenericButton(buttonText: "????????????", bgColor: Color("Cancel"), fgColor: Color("Button Text"), height:70, fontSize:20, curve: 30)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading,.trailing],25)
                    .padding([.bottom],20)
                    .padding([.top], 20)
                }
            }
            .background(Color("Background"))
            
            if contactAdded {
                AlertView(show: $contactAdded, inputToDelete: .constant(""), errorMsg: "?????????????????????", buttonName: "??????")
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

