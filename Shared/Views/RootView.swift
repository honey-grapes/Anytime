//
//  RootView.swift
//  Anytime
//
//  Created by Josephine Chan on 10/18/22.
//

import SwiftUI

enum DefaultSettings {
    static let login_status = false
    static let darkMode = false
    static let updateContact = true
}

@available(iOS 16.0, *)
struct RootView: View {
    //User Default
    @AppStorage("isDarkMode") var isDarkMode = DefaultSettings.darkMode
    @AppStorage("login_status") var login_status = DefaultSettings.login_status
    @AppStorage("updateContact") var updateContact = DefaultSettings.updateContact
    
    //Creates binding and stores the state
    @State var selectedTab: Tabs = .contact
    var body: some View {
        VStack(alignment:.leading){
            if login_status {
                NavigationStack{
                    //Tab headers
                    Header(login_status: $login_status, curTab: $selectedTab)
                    
                    //Content tabs
                    TabView(selection: $selectedTab) {
                        ContactView().tag(Tabs.contact)
                        AddView().tag(Tabs.add)
                        PicView().tag(Tabs.pic)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .edgesIgnoringSafeArea(.all)

                    //Tab bar
                    //Passing the selectedTab variable through
                    //So it will change with swipe or selection
                    ATTabBar(selectedTab: $selectedTab)
                }
                .preferredColorScheme(isDarkMode ? .dark : .light)
            }
            else {
                NavigationView{
                    LoginView()
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
        .onAppear {
            updateContact = true
        }
    }
}

@available(iOS 16.0, *)
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
