//
//  PicView.swift
//  Anytime
//
//  Created by Josephine Chan on 10/19/22.
//

import SwiftUI

struct PicView: View {
    //To delete
    @State var pressed = false
    var tempArray = ["詹喬棻", "辛阿米", "詹沛衡","詹喬棻", "辛阿米", "詹沛衡","詹喬棻", "辛阿米", "詹沛衡"]
    
    //Contact list and name saved in UserDefaults
    @AppStorage("contactsList") var contactsList: Data = DefaultSettings.contactsList
    
    //Decode contactsList from UserDefaults
    func decode(arr: Data) -> [String:String] {
        guard let decodedContactsList = try? JSONDecoder().decode([String:String].self, from: arr) else { return [:]}
        return decodedContactsList
    }
    
    var body: some View {
        ScrollView {
            HStack{
                //Add story button
                Button(action: {}
                       ,label: {
                    (Text("上傳圖片 ") + Text(Image(systemName: "camera.macro")))
                        .font(.system(size: 20))
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(Color("Primary Opposite"))
                        .background(Color("Primary Pink"))
                        .cornerRadius(30)
                })
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                //Refresh button
                Button(action: {}
                       ,label: {
                    (Text("更新 ") + Text(Image(systemName: "arrow.clockwise")))
                        .font(.system(size: 20))
                        .bold()
                        .frame(width: 80)
                        .padding()
                        .foregroundColor(Color("Primary Opposite"))
                        .background(Color("Primary Pink"))
                        .cornerRadius(30)
                })
                .padding(.top, 20)
                .padding(.bottom, 10)

            }
            
            //Feed
            LazyVGrid(columns: [GridItem(.flexible())]) {
                ForEach((0...100), id: \.self) {_ in
                    autoreleasepool{ //Release temp memory
                        VStack (alignment: .center, spacing: 0){
                            HStack {
                                Text("辛阿米")
                                    .bold()
                                    .font(.system(size: 20))
                                
                                Spacer()
                                
                                Text("11-28-2022")
                                    .bold()
                                    .font(.system(size: 18))
                                    .foregroundColor(Color("Secondary"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 50)
                            .padding([.top,.bottom], 10)
                            .padding([.leading,.trailing], 25)
                            .foregroundColor(Color("Primary"))
                            .background(Color("Primary Opposite"))
                            
                            Image(uiImage: UIImage(named: "Leopard")!)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
                            
                            HStack (spacing: 20){
                                //Heart button
                                Button(action: {
                                    //Switch on and off to like or dislike
                                    pressed.toggle()
                                }, label: {
                                    (Image(systemName: pressed ? "heart.fill" : "heart"))
                                        .font(.system(size: 40))
                                        .padding(.leading, 20)
                                        .padding([.top,.bottom],15)
                                        .foregroundColor(Color("Primary Pink"))
                                        .frame(alignment: .leading)
                                })
                                
                                //Contacts who liked your posts
                                //Text(Array(decode(arr: contactsList).values).joined(separator:", "))
                                 Text(tempArray.joined(separator:", "))
                                    .font(.system(size: 17))
                                    .foregroundColor(Color("Secondary"))
                                    .lineSpacing(5)
                                    .padding([.top,.bottom], 10)
                                    .padding(.trailing, 20)
                                    .frame(width: 290)
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
