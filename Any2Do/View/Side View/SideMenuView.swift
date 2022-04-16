//
//  SideMenuView.swift
//  Any2Do
//
//  Created by Mint on 2022/2/23.
//

import SwiftUI

struct SideMenuView: View {
    
    @Binding var isShowingSideMenu: Bool
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack{
            MotionAnimationView()
           
            VStack(alignment: .leading, spacing: 2) {
                SideHeaderView(isShowingSideMenu: $isShowingSideMenu, geometry: geometry)
                    .frame(height: 200)
                
                NavigationLink(destination: {
                    SideMenuGuideView()
                }, label: {
                    SideContentView(sideContentImage: "book", sideContentName: "Guide", geometry: geometry)
                })
              
                NavigationLink(destination: {
                    SideMenuAppView()
                }, label: {
                    SideContentView(sideContentImage: "ellipsis.circle", sideContentName: "App", geometry: geometry)
                })
                Spacer()
            }
            .navigationBarHidden(true)
            .padding()
        }
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            SideMenuView(isShowingSideMenu: .constant(false), geometry: geometry)
        }
    }
}
