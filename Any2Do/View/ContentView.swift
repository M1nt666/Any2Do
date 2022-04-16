//
//  ContentView.swift
//  Any2Do
//
//  Created by Mint on 2022/2/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var viewModel: CategoryTaskViewModel
    let geometry: GeometryProxy
    
    @State private var isShowingSideMenu = false
    
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack(alignment: .topLeading) {
                    if isShowingSideMenu {
                        SideMenuView(isShowingSideMenu: $isShowingSideMenu, geometry: geometry)
                    }
                    HomeView(viewModel: viewModel, geometry: geometry)
                        .cornerRadius(isShowingSideMenu ? 30 : 0)
                        .scaleEffect(isShowingSideMenu ? 0.8 : 1)
                        .offset(x: isShowingSideMenu ? 250 : 0, y: isShowingSideMenu ? 45 : 0)
                        .blur(radius: isShowingSideMenu ? 2.5 : 0)
                        .opacity(isShowingSideMenu ? 0.5 : 1)
                        .allowsHitTesting(!isShowingSideMenu)
                }
                .navigationBarItems(leading: Button(action: {
                    withAnimation(.spring()) {
                        isShowingSideMenu.toggle()
                    }
                }, label: {
                    Image(systemName: "list.bullet")
                        .font(.system(size: geometry.size.width/12))
                        .foregroundColor(.gray)
                }))
                .navigationBarTitleDisplayMode(.inline)
            }
            .onAppear {
                isShowingSideMenu = false
                viewModel.loadData()
            }
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
        ContentView(viewModel: CategoryTaskViewModel(), geometry: geometry)
        }
    }
}
