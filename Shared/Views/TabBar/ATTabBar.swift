//
//  SwiftUIView.swift
//  Anytime
//
//  Created by Josephine Chan on 10/18/22.
//

import SwiftUI

enum Tabs: Int {
    case add = 0
    case contact = 1
    case pic = 2
}

struct ATTabBar: View {
    //Binds property and view
    @Binding var selectedTab: Tabs
    @State var addColor: Color = Color("Secondary")
    @State var contactColor: Color = Color("Primary Pink")
    @State var picColor: Color = Color("Secondary")
    
    var body: some View {
        HStack{
            Spacer()
            Button{
                selectedTab = .contact
            } label: {
                ATTabButton(buttonLabel: "通話", buttonIcon: "phone.circle.fill", isActive: selectedTab == .contact)
            }.tint(contactColor)
            Spacer()
            Button{
                selectedTab = .add
            } label: {
                ATTabButton(buttonLabel: "添加", buttonIcon: "person.crop.circle.fill.badge.plus", isActive: selectedTab == .add)
            }.tint(addColor)
            Spacer()
            Button{
                selectedTab = .pic
            } label: {
                ATTabButton(buttonLabel: "照片", buttonIcon: "photo.fill.on.rectangle.fill", isActive: selectedTab == .pic)
            }.tint(picColor)
            Spacer()
        }
        .padding(.top,15)
    }
}

struct ATTabBar_Previews: PreviewProvider {
    static var previews: some View {
        ATTabBar(selectedTab: .constant(.contact))
    }
}
