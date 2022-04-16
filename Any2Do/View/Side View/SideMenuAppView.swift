//
//  SideMenuAppView.swift
//  Any2Do
//
//  Created by Mint on 2022/3/13.
//

import SwiftUI

struct SideMenuAppView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("Purple")]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment:.center) {
                    HStack{
                        Text("General")
                            .font(.system(size: 25,weight: .heavy))
                            .foregroundColor(.black)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(.white)
                    .clipShape(Capsule())
                    .shadow(radius: 10, x: 3, y: 0)
                    
                    VStack(alignment:.center, spacing: 15){
                        Image("LogoImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .cornerRadius(10)
                            .padding(.vertical)
                        Text("Any2Do")
                            .font(.system(size: 20,weight: .medium))
                            .foregroundColor(.black)
                        Text("Verson 1.0.0")
                            .foregroundColor(.black)
                        HStack{
                            Image(systemName: "person")
                                .font(.system(size: 25,weight: .regular))
                            Text("By Boyun He")
                                .font(.system(size: 15,weight: .regular))
                                .padding(.vertical)
                        }
                    }
                    .frame(width: 335)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(radius: 10, x: 3,y: 0)
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack{
                Image(systemName: "chevron.backward")
                    .font(.system(size: 25, weight: .semibold))
                    .accentColor(.white)
                Spacer()
            }
        }))
    }
}

struct SideMenuAppView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuAppView()
    }
}
