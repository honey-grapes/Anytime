//
//  ContentView.swift
//  Shared
//
//  Created by Josephine Chan on 10/17/22.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct ContactView: View {
    //Computed user properties from FirebaseAuth
    var uuid: String? {
        Auth.auth().currentUser?.uid
    }
    @AppStorage("userNumber") var userNumber = DefaultSettings.userNumber
    
    //Fetch contacts and posts only when the app launches or when a new contact is added
    @AppStorage("updateContact") var updateContact = DefaultSettings.updateContact
    @AppStorage("updatePosts") var updatePosts = DefaultSettings.updatePosts
    @AppStorage("contactsList") var contactsList: Data = DefaultSettings.contactsList
    @State var retrievedContacts: [ContactModel] = []
    
    //Dictates which view to show
    @State var haveContacts = true
    
    //Loading view
    @State var loading = false
    
    //Fetch all contacts from Firestore
    func fetchContact(completion: @escaping ([ContactModel]) -> Void) {
        if updateContact {
            //Turn on loading view
            loading = true
            
            //Get reference to the Firestore and Firebase Storage
            let db = Firestore.firestore()
            let storageRef = Storage.storage().reference()
            var contactToReturn = [ContactModel]()
            let group = DispatchGroup()
            
            //Get contact documents from Firestore
            db.collection("users").document(self.uuid!).collection("contacts").order(by: "lastName").getDocuments{ snapshot, error in
                //Show the "no contact" view if the snapshot is nil or the snapshot contains no document
                if snapshot == nil || (snapshot != nil && snapshot!.documents.count <= 0) {
                    haveContacts = false
                }
                else {
                    haveContacts = true
                }
                
                if error == nil && snapshot != nil {
                    //Clear the previous iteration of fetched contacts
                    self.retrievedContacts = [ContactModel]()
                    //Temporary dictionary of contact phone:name key value pairs
                    var tmp_contacts:[String:String] = [:]
                    
                    for contact in snapshot!.documents{
                        autoreleasepool{ //Release temp memory
                            group.enter() //Display the contacts after all contacts are loaded
                            
                            let phoneNumber = contact["phoneNumber"] as! String
                            let firstName = contact["firstName"] as! String
                            let lastName = contact["lastName"] as! String
                            let profilePicURL = contact["profilePicURL"] as! String
                            
                            //Add contact key value pair into temp dictionary
                            tmp_contacts[phoneNumber] = lastName + firstName
                            
                            //Retrieve image data and save Contact into retrievedContacts array
                            storageRef.child(profilePicURL).getData(maxSize: 10 * 1024 * 1024) { data, error in
                                if error == nil && data != nil {
                                    contactToReturn.append(ContactModel(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, profilePic: data!))
                                    //Convert to "true" if a contact is added or when the app was in the background
                                    updateContact = false
                                    
                                    group.leave()
                                }
                            }
                        }
                    }
                    group.notify(queue: .main) {
                        //Turn off loading view
                        loading = false
                        //Save temporary dictionary to UserDefaults
                        tmp_contacts[self.userNumber] = "我" //Adding "me" to the contact list so your own post shows up later in the feed as well
                        guard let contactsList = try? JSONEncoder().encode(tmp_contacts) else {return}
                        self.contactsList = contactsList
                        
                        completion(contactToReturn.sorted{ (contact1, contact2) -> Bool in
                            return (contact1.lastName, contact1.firstName) < (contact2.lastName, contact2.firstName)
                        })
                    }
                }
            }
        }
    }
    
    //Delete contact
    @State var showDeleteError = false
    @State var showDeleteSuccess = false
    @State var showDeleteModal = false
    @State var contactToDelete = ""
    func deleteContact(phone: String) {
        //Get reference to the Firestore
        let db = Firestore.firestore()
        //Delete
        db.collection("users").document(self.uuid!).collection("contacts").document(phone).delete { err in
            if err != nil {
                showDeleteError = true
            }
            else {
                updateContact = true
                updatePosts = true
                fetchContact() { contacts in
                    self.retrievedContacts = contacts
                }
                showDeleteSuccess = true
            }
        }
    }
    
    var gridItem = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            //No contact view
            if haveContacts {
                VStack(alignment: .leading){
                    ScrollView {
                        //Refresh button and instruction
                        HStack(alignment: .center) {
                            (Text("請點擊聯絡人通話"))
                                .font(.system(size: 20))
                                .bold()
                                .padding(.trailing, 10)
                                .foregroundColor(Color("Secondary"))
                            
                            //Button to manually fetch and refresh contact
                            Button {
                                updateContact = true
                                updatePosts = true
                                fetchContact() { contacts in
                                    self.retrievedContacts = contacts
                                }
                            } label: {
                                (Text("更新 ") + Text(Image(systemName: "arrow.clockwise")))
                                    .font(.system(size: 18))
                                    .bold()
                                    .padding([.top,.bottom], 6)
                                    .padding([.leading,.trailing], 15)
                                    .foregroundColor(Color("Button Text"))
                                    .background(Color("Primary Pink"))
                                    .cornerRadius(20)
                            }
                        }
                        .padding([.leading,.trailing],40)
                        .padding([.top],20)
                        .frame(maxWidth: .infinity)
                        
                        //Display contacts
                        LazyVGrid(columns: gridItem, spacing: 6) {
                            ForEach(retrievedContacts) {contact in
                                autoreleasepool{ //Release temp memory
                                    Button(action: {
                                        let phone = "tel://"
                                        let phoneNumberformatted = phone + contact.phoneNumber
                                        guard let url = URL(string: phoneNumberformatted) else { return }
                                        UIApplication.shared.open(url)
                                    }){
                                        VStack (spacing: 0){
                                            Image(uiImage: UIImage(data: contact.profilePic)!)
                                                .resizable()
                                                .overlay(alignment: .topLeading) {
                                                    //Delete button
                                                    Button(action: {
                                                        contactToDelete = contact.phoneNumber
                                                        showDeleteModal = true
                                                    }, label: {
                                                        Image(systemName: "trash.fill")
                                                            .foregroundColor(Color("Button Text"))
                                                            .padding(7)
                                                            .font(.system(size: 20))
                                                    })
                                                    .background(Color("Primary Pink"))
                                                    .cornerRadius(15)
                                                    .padding(10)
                                                }
                                                .frame(width: (UIScreen.main.bounds.width - 15) / 2, height: (UIScreen.main.bounds.width - 15) / 2)
                                            (Text(contact.lastName) + Text(contact.firstName))
                                                .font(.system(size: 20))
                                                .bold()
                                                .frame(width: (UIScreen.main.bounds.width - 15) / 2, height: 50)
                                                .foregroundColor(Color("Primary"))
                                                .background(Color("Primary Opposite"))
                                        }
                                        .cornerRadius(20)
                                    }
                                }
                            }
                        }
                    }
                    .padding([.leading, .trailing], 5)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color("Background"))
                .onAppear{
                    if updateContact {
                        fetchContact() { contacts in
                            self.retrievedContacts = contacts
                        }
                    }
                }
            }
            //Contact view
            else{
                VStack(alignment: .center) {
                    //Button to manually fetch and refresh contact
                    Button {
                        updateContact = true
                        updatePosts = true
                        fetchContact() { contacts in
                            self.retrievedContacts = contacts
                        }
                    } label: {
                        (Text("更新 ") + Text(Image(systemName: "arrow.clockwise")))
                            .font(.system(size: 18))
                            .bold()
                            .padding()
                            .foregroundColor(Color("Primary Opposite"))
                            .background(Color("Primary Pink"))
                            .cornerRadius(20)
                    }
                    .padding([.leading,.trailing],40)
                    .padding([.top],20)
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    (Text("尚無聯絡人"))
                        .font(.system(size: 25))
                        .foregroundColor(Color("Secondary"))
                        .bold()
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("Background"))
                .onAppear{
                    if updateContact {
                        fetchContact() { contacts in
                            self.retrievedContacts = contacts
                        }
                    }
                }
            }
            
            if loading {
                LoadView(show: $loading, content: "載入資料")
            }
            
            if showDeleteError {
                AlertView(show: $showDeleteError, inputToDelete: .constant(""), errorMsg: "刪除錯誤", buttonName: "重試")
            }
            
            if showDeleteSuccess {
                AlertView(show: $showDeleteSuccess, inputToDelete: .constant(""), errorMsg: "刪除成功", buttonName: "確認")
            }
            
            if showDeleteModal {
                ConfirmView(show: $showDeleteModal, msg: "確認刪除？", buttonName: "確認", action: deleteContact, id: contactToDelete)
            }
        }
    }
}

struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView()
    }
}

