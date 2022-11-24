//
//  PicView.swift
//  Anytime
//
//  Created by Josephine Chan on 10/19/22.
//

import SwiftUI

struct PicView: View {
    @State var text = ""
    var body: some View {
        VStack(alignment: .center){
            Text("如果喜歡您看到的內容，可以按愛心點讚")
                .font(.system(size: 20))
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
                    ForEach((0...100), id: \.self) {_ in
                        VStack{
                            Image(uiImage: UIImage(named: "Leopard")!)
                                .resizable()
                                .font(.system(size: 30))
                                .frame(width: UIScreen.main.bounds.width - 40, height: 250)
                        }
                        .cornerRadius(20)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.leading,.trailing],40)
        .padding([.top,.bottom],20)
        .background(Color("Background"))
    }
}

struct PicView_Previews: PreviewProvider {
    static var previews: some View {
        PicView()
    }
}
