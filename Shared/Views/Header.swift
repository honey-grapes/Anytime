//
//  Header.swift
//  Anytime
//
//  Created by Josephine Chan on 10/20/22.
//

import SwiftUI

struct Header: View {
    @Binding var login_status: Bool
    @Binding var curTab: Tabs
    
    @State var tabHeader1: String = "添加聯絡人"
    @State var tabHeader2: String = "通話"
    @State var tabHeader3: String = "朋友圈"
    
    var body: some View {
        HStack{
            if curTab == .add {
                Text(tabHeader1)
                    .font(.system(size: 35))
                    .fontWeight(.bold)
                    .padding(.top,20)
                    .padding(.leading,40)
                    .foregroundColor(Color("Primary"))
            } else if curTab == .contact {
                Text(tabHeader2)
                    .font(.system(size: 35))
                    .fontWeight(.bold)
                    .padding(.top,20)
                    .padding(.leading,40)
                    .foregroundColor(Color("Primary"))
            } else {
                Text(tabHeader3)
                    .font(.system(size: 35))
                    .fontWeight(.bold)
                    .padding(.top,20)
                    .padding(.leading,40)
                    .foregroundColor(Color("Primary"))
            }
            
            Spacer()
            
            NavigationLink(destination: SettingsView(login_status: $login_status, curTab: $curTab)) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 30))
                    .padding(.top,20)
                    .padding(.trailing,30)
                    .foregroundColor(Color("Primary"))
            }
        }
        .padding(.top,45)
        .padding(.bottom,20)
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header(login_status: .constant(false), curTab: .constant(.contact))
    }
}
