//
//  PicView.swift
//  Anytime
//
//  Created by Josephine Chan on 10/19/22.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct PicView: View {
    //Image picker variable
    @State var showUploadModal = false
    
    //State variables to dictate views
    @State var havePosts = true
    @State var loading = false
    
    //Store post models
    @State var retrievedPosts: [PostModel] = []
    
    //Contact list and name saved in UserDefaults
    //To be used to filter posts to show and display contact who liked certain posts
    @AppStorage("contactsList") var contactsList: Data = DefaultSettings.contactsList
    //Decode contactsList from UserDefaults
    func decode(dic: Data) -> [String:String] {
        guard let decodedContactsList = try? JSONDecoder().decode([String:String].self, from: dic) else { return [:]}
        return decodedContactsList
    }
    
    //Date formatter
    func formatDate(date: String) -> String {
        let removeTime = date.components(separatedBy: ",")
        return removeTime[0].replacingOccurrences(of: "/", with: "-")
    }
    
    //Like updating: Update a post's liked array when user likes / unlikes a post
    @AppStorage("userNumber") var userNumber = DefaultSettings.userNumber
    func updateLike(postID: String, liked: [String], likeState: Bool) {
        let db = Firestore.firestore()
        //Like
        if likeState {
            //Append new liked array with user's own number
            var newLiked: [String] = liked
            newLiked.append(userNumber)
            db.collection("posts").document(postID).setData(["liked": newLiked], merge: true)
        }
        //Unlike
        else if let i = liked.firstIndex(of: userNumber) {
            //Append new liked array without user's own number
            var newLiked: [String] = liked
            newLiked.remove(at: i)
            db.collection("posts").document(postID).setData(["liked": newLiked], merge: true)
        }
    }
    
    //Convert liked array into an array of names based on the contactsList dictionary
    func contactsWhoLiked(liked: [String]) -> [String] {
        let dic = decode(dic: contactsList)
        var names: [String] = []
        for i in 0..<liked.count {
            if dic[liked[i]] != nil {
                names.append(dic[liked[i]]!)
            }
        }
        
        return names
    }
    
    //Fetch posts from Firebase and filter what to display based on each user's contactsList
    @AppStorage("updatePosts") var updatePosts = DefaultSettings.updatePosts
    func fetchPosts(completion: @escaping ([PostModel]) -> Void) {
        if updatePosts {
            //Starts loading view
            loading.toggle()
            
            //Get reference to the Firestore and Firebase Storage
            let db = Firestore.firestore()
            let storageRef = Storage.storage().reference()
            var postsToReturn = [PostModel]()
            let group = DispatchGroup()
            
            //Extract contact numbers to filter for the posts to show
            let decodedContactList = decode(dic: contactsList)
            let contactNumbers = Array(decodedContactList.keys)
            
            //Get contact documents from Firestore
            db.collection("posts").whereField("authorPhone", in: contactNumbers).getDocuments{ snapshot, error in
                //Show the "no contact" view if the snapshot is nil or the snapshot contains no document
                if snapshot == nil || (snapshot != nil && snapshot!.documents.count <= 0) {
                    havePosts = false
                }
                
                if error == nil && snapshot != nil {
                    //Clear the previous iteration of fetched contacts
                    self.retrievedPosts = [PostModel]()
                    
                    for post in snapshot!.documents{
                        autoreleasepool{ //Release temp memory
                            group.enter() //Display the posts after all posts are loaded
                            
                            let id = post["id"] as! String
                            let date = post["date"] as! String
                            let authorPhone = post["authorPhone"] as! String
                            let authorName = decodedContactList[authorPhone]!
                            let postPicURL = post["postPic"] as! String
                            let liked = post["liked"] as! [String]
                            let likedByMe = liked.contains(userNumber)
                            
                            //Retrieve image data and save Contact into retrievedContacts array
                            storageRef.child(postPicURL).getData(maxSize: 10 * 1024 * 1024) { data, error in
                                if error == nil && data != nil {
                                    postsToReturn.append(PostModel(id: id, date: date, authorPhone: authorPhone, authorName: authorName, postPic: data!, liked: liked, likedByMe: likedByMe))
                                    updatePosts = false //Convert to "true" if a post is added or when the app was in the background
                                    
                                    group.leave()
                                }
                            }
                        }
                    }
                    group.notify(queue: .main) {
                        //Turn off loading view
                        loading = false
                        print(postsToReturn)
                        
                        completion(postsToReturn.sorted{ (post1, post2) -> Bool in
                            return post1.date > post2.date
                        })
                    }
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                if havePosts {
                    //Header
                    HStack{
                        //Add post button
                        NavigationLink(destination: AddPostView(), isActive: $showUploadModal){
                            Button(action: {
                                showUploadModal.toggle()
                            },label: {
                                (Text("上傳圖片 ") + Text(Image(systemName: "camera.macro")))
                                    .font(.system(size: 20))
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(Color("Button Text"))
                                    .background(Color("Primary Pink"))
                                    .cornerRadius(30)
                            })
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                        }
                        
                        //Refresh button
                        Button(
                            action: {
                                updatePosts = true
                                fetchPosts() {posts in
                                    self.retrievedPosts = posts
                                }
                            }
                           ,label: {
                            (Text("更新 ") + Text(Image(systemName: "arrow.clockwise")))
                                    .font(.system(size: 20))
                                    .bold()
                                    .frame(width: 80)
                                    .padding()
                                    .foregroundColor(Color("Button Text"))
                                    .background(Color("Primary Pink"))
                                    .cornerRadius(30)
                           }
                        )
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    }
                    
                    //Feed
                    LazyVGrid(columns: [GridItem(.flexible())]) {
                        ForEach(retrievedPosts.indices, id: \.self) { n in
                            autoreleasepool{ //Release temp memory
                                VStack (alignment: .center, spacing: 0){
                                    HStack {
                                        Text(retrievedPosts[n].authorName)
                                            .bold()
                                            .font(.system(size: 20))
                                        
                                        Spacer()
                                        
                                        Text(formatDate(date: retrievedPosts[n].date))
                                            .bold()
                                            .font(.system(size: 18))
                                            .foregroundColor(Color("Secondary"))
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(height: 50)
                                    .padding([.top,.bottom], 5)
                                    .padding([.leading,.trailing], 25)
                                    .foregroundColor(Color("Primary"))
                                    .background(Color("Primary Opposite"))
                                    
                                    Image(uiImage: UIImage(data: retrievedPosts[n].postPic)!)
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
                                    
                                    HStack (spacing: 20){
                                        //Heart button
                                        Button(action: {
                                            //Switch on and off to like or dislike
                                            retrievedPosts[n].likedByMe.toggle()
                                            
                                            //Updates the user liked the post on Firebase
                                            updateLike(postID: retrievedPosts[n].id, liked: retrievedPosts[n].liked, likeState: retrievedPosts[n].likedByMe)
                                        }, label: {
                                            (Image(systemName: retrievedPosts[n].likedByMe ? "heart.fill" : "heart"))
                                                .font(.system(size: 40))
                                                .padding(.leading, 20)
                                                .padding([.top,.bottom],5)
                                                .foregroundColor(Color("Primary Pink"))
                                                .frame(alignment: .leading)
                                        })
                                        
                                        //Contacts who liked your posts
                                        //If the page is yet to be refreshed after a new like, there will be a mismatch of likedByMe and liked. A Text will show "me" when likedByMe = true and liked does not reflect that
                                        (Text(contactsWhoLiked(liked: retrievedPosts[n].liked).joined(separator:", ")) +
                                         Text(retrievedPosts[n].likedByMe && !retrievedPosts[n].liked.contains(userNumber) ? ", 我" : ""))
                                            .font(.system(size: 17))
                                            .foregroundColor(Color("Secondary"))
                                            .lineSpacing(5)
                                            .padding([.top,.bottom], 5)
                                            .padding(.trailing, 20)
                                            .frame(width: 290, alignment: .leading)
                                    }
                                    .frame(width: (UIScreen.main.bounds.width - 40))
                                    .padding([.top,.bottom], 15)
                                    .background(Color("Primary Opposite"))
                                }
                                .cornerRadius(25)
                                .padding(.bottom, 15)
                                .foregroundColor(Color("Primary"))
                            }
                        }
                    }
                }
                else {
                    //Header
                    HStack{
                        //Add post button
                        NavigationLink(destination: AddPostView(), isActive: $showUploadModal){
                            Button(action: {
                                showUploadModal.toggle()
                            },label: {
                                (Text("上傳圖片 ") + Text(Image(systemName: "camera.macro")))
                                    .font(.system(size: 20))
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(Color("Button Text"))
                                    .background(Color("Primary Pink"))
                                    .cornerRadius(30)
                            })
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                        }
                        
                        //Refresh button
                        Button(
                            action: {
                                updatePosts = true
                                fetchPosts() {posts in
                                    self.retrievedPosts = posts
                                }
                            }
                           ,label: {
                            (Text("更新 ") + Text(Image(systemName: "arrow.clockwise")))
                                    .font(.system(size: 20))
                                    .bold()
                                    .frame(width: 80)
                                    .padding()
                                    .foregroundColor(Color("Button Text"))
                                    .background(Color("Primary Pink"))
                                    .cornerRadius(30)
                           }
                        )
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    }
                    
                    VStack (alignment: .center) {
                        Text("尚無圖片")
                            .foregroundColor(Color("Primary"))
                            .font(.system(size: 30))
                            .bold()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading,.trailing],20)
            .background(Color("Background"))
            .onAppear{
                if updatePosts {
                    fetchPosts() { posts in
                        self.retrievedPosts = posts
                    }
                }
            }
            
            if loading {
                LoadView(show: $loading, content: "載入圖片")
            }
        }
    }
}

struct PicView_Previews: PreviewProvider {
    static var previews: some View {
        PicView()
    }
}
