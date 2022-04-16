//
//  Any2DoApp.swift
//  Any2Do
//
//  Created by Mint on 2022/2/23.
//

import SwiftUI

@main
struct Any2DoApp: App {
    
    let DataManager = CoreDataManager.shared
    
    
    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
            ContentView(viewModel: CategoryTaskViewModel(), geometry: geometry)
                .environment(\.managedObjectContext, DataManager.container.viewContext)
            }
        }
    }
}
