//
//  TaskEmptyView.swift
//  Any2Do
//
//  Created by Mint on 2022/3/13.
//

import SwiftUI

struct TaskEmptyView: View {
    var body: some View {
        VStack{
            Image("Emptytask-image")
                .resizable()
                .frame(width: 300, height: 300, alignment: .center)
        }
        .frame(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.width - 60)
    }
}
