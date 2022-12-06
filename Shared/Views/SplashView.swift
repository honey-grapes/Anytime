//
//  SplashView.swift
//  Anytime (iOS)
//
//  Created by Josephine Chan on 12/1/22.
//

import SwiftUI

@available(iOS 16.0, *)
struct SplashView: View {
    @State var isActive: Bool = false
    @State var size = 0.9
    @State var opacity = 0.6
    
    var body: some View {
        if isActive {
            TabView{
                RootView()
            }
        }
        else {
            VStack {
                VStack(spacing: 10) {
                    Image(systemName: "heart.circle.fill")
                        .font(.system(size: 80))
                    Text("通話易")
                        .font(.system(size: 30))
                        .bold()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(.white)
                .scaleEffect(self.size)
                .opacity(self.opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 1
                        self.opacity = 1
                    }
                }
            }
            .background(Color("Primary Pink"))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation{
                        self.isActive = true
                    }
                }
            }
        }
    }
}

@available(iOS 16.0, *)
struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
