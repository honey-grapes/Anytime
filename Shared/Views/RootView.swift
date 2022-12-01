//
//  RootView.swift
//  Anytime
//
//  Created by Josephine Chan on 10/18/22.
//

import SwiftUI

//Default values for user defaults
enum DefaultSettings {
    static let login_status = false
    static let darkMode = false
    static let updateContact = true
    static let updatePosts = true
    static let userNumber = ""
    static let contactsList = Data()
}

@available(iOS 16.0, *)
struct RootView: View {
    //UserDefaults
    @AppStorage("isDarkMode") var isDarkMode = DefaultSettings.darkMode
    @AppStorage("login_status") var login_status = DefaultSettings.login_status
    @AppStorage("updateContact") var updateContact = DefaultSettings.updateContact
    @AppStorage("updatePosts") var updatePosts = DefaultSettings.updatePosts
    
    //Creates binding and stores the state
    @State var selectedTab: Tabs = .contact
    var body: some View {
        VStack(alignment:.leading){
            NavigationView{
                if login_status {
                    NavigationStack{
                        VStack(spacing: 0){
                            //Tab headers
                            Header(login_status: $login_status, curTab: $selectedTab)
                            
                            //Content tabs
                            TabView(selection: $selectedTab) {
                                ContactView().tag(Tabs.contact)
                                AddView().tag(Tabs.add)
                                PicView().tag(Tabs.pic)
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                            //Tab bar
                            //Passing the selectedTab variable through
                            //So it will change with swipe or selection
                            ATTabBar(selectedTab: $selectedTab)
                        }
                        .ignoresSafeArea()
                    }
                    .preferredColorScheme(isDarkMode ? .dark : .light)
                }
                else {
                    LoginView()
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                }
            }
        }
        .onAppear {
            updateContact = true
            updatePosts = true
        }
    }
}

@available(iOS 16.0, *)
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
