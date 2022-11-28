//
//  PicView.swift
//  Anytime
//
//  Created by Josephine Chan on 10/19/22.
//

import SwiftUI

struct PicView: View {
    @State var pressed = false
    
    var body: some View {
        VStack(alignment: .center){
            ScrollView {
                //Add story button
                Button(action: {}
                       ,label: {
                    (Text("上傳圖片 ") + Text(Image(systemName: "camera.macro")))
                        .font(.system(size: 20))
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding([.top,.bottom], 20)
                        .foregroundColor(Color("Primary Opposite"))
                        .background(Color("Primary Pink"))
                        .cornerRadius(30)
                })
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                //Feed
                LazyVGrid(columns: [GridItem(.flexible())]) {
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
                                
                                HStack (spacing: 30){
                                    //Heart button
                                    Button(action: {
                                        //Switch on and off to like or dislike
                                        pressed.toggle()
                                    }, label: {
                                        (Image(systemName: pressed ? "heart.fill" : "heart"))
                                            .font(.system(size: 30))
                                            .padding(.leading, 20)
                                            .padding([.top,.bottom],15)
                                            .foregroundColor(Color("Primary Pink"))
                                    })
                                    
                                    //Contacts who liked your posts
                                    Text("詹喬棻, 辛阿米, 詹沛衡, 詹喬棻, 辛阿米, 詹沛衡, 詹喬棻, 辛阿米, 詹沛衡, 詹喬棻, 辛阿米, 詹沛衡, 詹喬棻, 辛阿米, 詹沛衡")
                                        .font(.system(size: 20))
                                        .foregroundColor(Color("Primary"))
                                        .lineSpacing(5)
                                        .padding([.top,.bottom], 10)
                                        .padding(.trailing, 20)
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
