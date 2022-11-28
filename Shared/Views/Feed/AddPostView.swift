//
//  AddPostView.swift
//  Anytime (iOS)
//
//  Created by Josephine Chan on 11/28/22.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct AddPostView: View {
    //UserDefaults
    @AppStorage("isDarkMode") var isDarkMode = DefaultSettings.darkMode
    
    //Image picker variables
    @State var postPicked: Data = .init(capacity: 0)
    @State var postPickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State var showImagePicker = false
    @Environment(\.dismiss) private var dismiss
    
    //Notification when contact is successfully added
    @State var postAdded = false
    
    //Tell contactView to update contacts
    @AppStorage("updatePosts") var updatePosts = DefaultSettings.updatePosts
    @AppStorage("userNumber") var userNumber = DefaultSettings.userNumber
    
    //Function to upload post to Firebase Storage
    func uploadPost() {
        //Generate UUID and post publish time
        let postId = UUID().uuidString
        let date = Date.now.formatted()
        
        //Create storage reference and file path
        let storageRef = Storage.storage().reference()
        let imagePath = "posts/\(postId).png"
        let fileRef = storageRef.child(imagePath)
        
        //Upload image to storage then save a post into Firestore
        let uploadTask = fileRef.putData(postPicked) { metadata, error in
            postAdded = true //For notification
            updatePosts = true //For re-fetching contacts
            
            //Check for errors
            if error == nil && metadata != nil {
                //Get reference to the Firestore
                let db = Firestore.firestore()
                //Save to Firestore
                db.collection("posts").document(postId).setData([
                    "id": postId,
                    "date": date,
                    "authorPhone": self.userNumber,
                    "postPic": imagePath,
                    "liked": []
                ])
                
                //Remove post image after successfully adding contact to Firestore
                postPicked.removeAll(keepingCapacity: false)
            }
        }
    }
    
    var body: some View {
        VStack (alignment: .center){
            (Text("分享圖片 ") + Text(Image(systemName: "camera.macro")))
                .font(.system(size:25))
                .bold()
                .lineSpacing(5)
                .foregroundColor(Color("Button Text"))
            
            ScrollView(.vertical){
                VStack (alignment: .center) {
                    //Upload from camera
                    Button{
                        showImagePicker = true
                        postPickerSource = .camera
                    } label:{
                        AddContactButton(contactButtonText: "現場照相", contactButtonIcon: "camera.fill", color: "Button Text")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .background(isDarkMode ? Color("Primary Pink") : Color("Secondary"))
                    .cornerRadius(20)
                    .sheet(isPresented: $showImagePicker) {
                        ImagePickerView(imagePicked: $postPicked, imagePickerSource: $postPickerSource, showImagePicker: $showImagePicker)
                    }
                    
                    Text("或者")
                        .frame(maxWidth: .infinity, alignment:.center)
                        .font(.system(size:20))
                        .foregroundColor(Color("Primary"))
                    
                    //Upload from photo album
                    Button{
                        showImagePicker = true
                        postPickerSource = .photoLibrary
                    } label:{
                        AddContactButton(contactButtonText: "從相簿選取", contactButtonIcon: "rectangle.stack.fill.badge.plus", color: "Button Text")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .background(isDarkMode ? Color("Primary Pink") : Color("Secondary"))
                    .cornerRadius(20)
                    .sheet(isPresented: $showImagePicker) {
                        ImagePickerView(imagePicked: $postPicked, imagePickerSource: $postPickerSource, showImagePicker: $showImagePicker)
                    }
                    
                    //Present the image picker result
                    if postPicked.count != 0 {
                        VStack (spacing: 0){
                            HStack(alignment: .center, spacing: 5){
                                Text(Image(systemName: "checkmark.circle.fill"))
                                    .font(.system(size: 55))
                                
                                Text(" 頭像選取成功")
                                    .font(.system(size: 30))
                                    .bold()
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(Color("Primary Pink"))
                            .padding([.top,.trailing], 20)
                            .padding([.leading],10)

                            Image(uiImage:UIImage(data: self.postPicked)!)
                                .resizable()
                                .frame(alignment: .center)
                                .frame(maxWidth: .infinity)
                                .scaledToFill()
                                .padding(20)
                            
                            //Clear and remove image
                            Button {
                                postPicked.removeAll(keepingCapacity: false)
                            } label: {
                                GenericButton(buttonText: "清除圖片重來", bgColor: Color("Cancel"), fgColor: Color("Button Text"), height: 70, fontSize: 20, curve: 30)
                            }
                            .padding([.leading,.trailing,.bottom],20)
                        }
                        .foregroundColor(Color("Primary"))
                        .background(isDarkMode ? Color("Background").opacity(0.5) : Color("Background"))
                        .cornerRadius(20)
                        .padding(.top,15)
                    }
                    
                    //Submit or cancel
                    VStack(alignment: .leading, spacing: 10){
                        Button{
                            uploadPost()
                            self.dismiss()
                        } label:{
                            GenericButton(buttonText: "分享圖片", bgColor: postPicked.count > 0  ? Color("Confirm") : Color("Confirm").opacity(0.5), fgColor: Color("Button Text"), height:70, fontSize:20, curve: 30)
                        }
                        .disabled(postPicked.count == 0)
                        
                        Button{
                            postPicked.removeAll(keepingCapacity: false)
                            self.dismiss()
                        } label:{
                            GenericButton(buttonText: "返回上一頁", bgColor: Color("Cancel"), fgColor: Color("Button Text"), height:70, fontSize:20, curve: 30)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.top], 20)
                }
                .frame(maxWidth: .infinity)
                .padding(30)
                .background(Color("Light"))
                .cornerRadius(25)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding([.leading,.trailing,.top],30)
        .background(isDarkMode ? Color("Background") : Color("Primary Pink"))
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.light)
    }
}

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        AddPostView()
    }
}
