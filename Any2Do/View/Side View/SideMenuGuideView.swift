//
//  SideMenuAboutView.swift
//  Any2Do
//
//  Created by Mint on 2022/3/13.
//

import SwiftUI

struct SideMenuGuideView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("Purple")]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment:.center) {
                    HStack{
                    Text("Guide")
                        .font(.system(size: 25,weight: .heavy))
                        .foregroundColor(.black)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(.white)
                    .clipShape(Capsule())
                    .shadow(radius: 10, x: 3, y: 0)
                    VStack(alignment: .leading){
                        Text("1.Create a task category: enter a name and select the tag.")
                            .font(.system(size: 18,weight: .bold))
                            .foregroundColor(.black)
                            .padding()
                        Image("Guide1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 240)
                            .padding()
                        Text("2.Create a corresponding task: enter a name and select a time, enter a task note if required.")
                            .font(.system(size: 18,weight: .bold))
                            .foregroundColor(.black)
                            .padding()
                        Image("Guide2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 240)
                            .padding()
                        Text("3.Complete or mark, long press to see task notes.")
                            .font(.system(size: 18,weight: .bold))
                            .foregroundColor(.black)
                            .padding()
                        Image("Guide3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 240)
                            .padding()
                        Text("4.Overall tasks can be viewed in the calendar view.")
                            .font(.system(size: 18,weight: .bold))
                            .foregroundColor(.black)
                            .padding()
                        Image("Guide4")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 240)
                            .padding()
                    }
                    .frame(width: 335)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(radius: 10, x: 3,y: 0)
                }
                .padding()
            }
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

struct SideMenuAboutView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuGuideView()
    }
}
