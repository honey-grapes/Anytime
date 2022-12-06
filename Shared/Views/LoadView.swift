//
//  LoadView.swift
//  Anytime (iOS)
//
//  Created by Josephine Chan on 11/11/22.
//

import SwiftUI

struct LoadView: View {
    @Binding var show: Bool
    var content: String
    
    var body: some View {
        ZStack{
            Text("")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.6))
                .edgesIgnoringSafeArea(.all)
                
            VisualEffectView(effect: UIBlurEffect(style: .regular)).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 15){
                (Text("正在") + Text(content) + Text("，請稍候"))
                    .bold()
                    .font(.system(size: 20))
                ProgressView()
                    .scaleEffect(2)
                    .tint(Color("Primary Pink"))
                    .padding()
            }
            .frame(width: UIScreen.main.bounds.width - 180, alignment: .center)
            .padding([.top,.bottom],25)
            .padding([.leading,.trailing],25)
            .foregroundColor(Color("Primary Pink"))
            .background(Color("Primary Opposite"))
            .cornerRadius(15)
        }
    }
}

struct LoadView_Previews: PreviewProvider {
    static var previews: some View {
        LoadView(show: .constant(true), content: "載入資料")
    }
}
