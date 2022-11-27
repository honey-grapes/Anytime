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
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 5) {
                    ForEach((0...100), id: \.self) {_ in
                        autoreleasepool{ //Release temp memory
                            VStack (alignment: .center, spacing: 0){
                                Text("辛阿米")
                                    .bold()
                                    .font(.system(size: 20))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(height: 50)
                                    .padding([.top,.bottom], 10)
                                    .padding(.leading, 20)
                                    .foregroundColor(Color("Primary"))
                                    .background(Color("Primary Opposite"))
                                
                                Image(uiImage: UIImage(named: "Leopard")!)
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
                                
                                (Image(systemName: "heart"))
                                    .font(.system(size: 30))
                                    .padding(.leading, 20)
                                    .frame(width: (UIScreen.main.bounds.width - 40), height: 50, alignment: .leading)
                                    .padding([.top,.bottom],15)
                                    .foregroundColor(Color("Primary Pink"))
                                    .background(Color("Primary Opposite"))
                            }
                            .cornerRadius(25)
                            .padding(.top, 25)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.leading,.trailing],20)
        .background(Color("Background"))
    }
}

struct PicView_Previews: PreviewProvider {
    static var previews: some View {
        PicView()
    }
}
