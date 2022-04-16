//
//  CategoryView.swift
//  Any2Do
//
//  Created by Mint on 2022/2/24.
//

import SwiftUI
import CoreData

struct CategoryView: View {
    
    @ObservedObject var viewModel: CategoryTaskViewModel
    let categoryForTask: CategoryForTask
    let geometry: GeometryProxy
    
    var body: some View {
        if let categoryName = categoryForTask.categoryName{
            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 4)
                
                VStack(alignment:.leading) {
                    Text(categoryName)
                        .foregroundColor(.black)
                        .font(.system(size: geometry.size.width/15))
                    Spacer()
                    HStack(alignment: .bottom) {
                        Image(systemName: categoryForTask.categoryImageName ?? "wallet.pass")
                            .font(.system(size: geometry.size.width/12))
                            .foregroundColor(.black)
                        Spacer()
                        if categoryForTask.sumOfCategoryTask <= 1{
                            VStack(alignment:.leading){
                                Text("\(categoryForTask.sumOfCategoryTask)")
                                Text("task")
                            }
                            .font(.system(size: geometry.size.width/20))
                            .foregroundColor(.gray)
                        }else {
                            VStack(alignment:.leading){
                                Text("\(categoryForTask.sumOfCategoryTask)")
                                Text("tasks")
                            }
                            .font(.system(size: geometry.size.width/20))
                            .foregroundColor(.gray)
                        }
                    }
                }
                .padding(10)
            }
            .frame(width: geometry.size.width/2.4, height: geometry.size.width/5)
        }
    }
}



