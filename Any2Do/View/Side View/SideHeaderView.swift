//
//  SideHeaderView.swift
//  Any2Do
//
//  Created by Mint on 2022/2/23.
//

import SwiftUI

struct SideHeaderView: View {
    
    @Binding var isShowingSideMenu: Bool
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: {
                withAnimation(.spring()){
                    isShowingSideMenu.toggle()
                }
            }, label: {
                Image(systemName: "xmark")
                    .font(.system(size: geometry.size.width/18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
            })
            
            VStack(alignment: .leading) {
                Image("LogoImage")
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .frame(width: geometry.size.width/5, height: geometry.size.width/5)
                    .clipShape(Circle())
                    .padding(.bottom, 10)
                
                HStack {
                    Text("Plan your task")
                        .font(.system(size: geometry.size.width/15, weight: .heavy))
                        .padding(.bottom, 5)
                    Spacer()
                }
                Spacer()
            }
            .foregroundColor(.white)
            .padding()
        }
    }
}

struct SideHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
        SideHeaderView(isShowingSideMenu: .constant(false), geometry: geometry)
            .preferredColorScheme(.dark)
        }
    }
}
