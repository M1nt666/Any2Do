//
//  HomeView.swift
//  Any2Do
//
//  Created by Mint on 2022/2/23.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    @ObservedObject var viewModel: CategoryTaskViewModel
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.taskName, ascending: false)]) var totalTask: FetchedResults<Task>
    
    
    let homeGridLayout: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
    let geometry: GeometryProxy
    
    @State private var isShowingCalendar = false
    @State private var isShowingCategoryEditView = false
    
    var body: some View {
        ZStack {
            if viewModel.categoryArray.count == 0 {
                TaskEmptyView()
            }
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .leading,spacing: 15) {
                    Text("Any2Do")
                        .font(.system(size: geometry.size.width/10,weight: .heavy))
                        .padding(.horizontal,25)
                    if totalTask.count == 0{
                        Text("No task! Let's create!")
                            .font(.system(size: geometry.size.width/15,weight: .medium))
                            .padding(.horizontal,25)
                    }else if totalTask.count == 1{
                        Text("You have \(totalTask.count) task to do!")
                            .font(.system(size: geometry.size.width/15,weight: .medium))
                            .padding(.horizontal,25)
                    } else {
                        Text("You have \(totalTask.count) tasks to do!")
                            .font(.system(size: geometry.size.width/15,weight: .medium))
                            .padding(.horizontal,25)
                    }
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: geometry.size.width/2.5))], spacing: 40) {
                        ForEach(viewModel.categoryArray) { category in
                            NavigationLink(destination:
                                            CategoryDetailView(viewModel: viewModel, categoryForTask: category, geometry: geometry)
                                           , label: {
                                CategoryView(viewModel: viewModel, categoryForTask: category, geometry: geometry)
                                
                            })
                        }
                    }
                    
                    .padding()
                }
            }
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    HStack(spacing: 10){
                        Button(action: {
                            //calendarview
                            isShowingCalendar = true
                        }, label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color("Blue"))
                                
                                Image(systemName: "calendar.badge.clock")
                                    .font(.system(size: geometry.size.width/8))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .frame(width: geometry.size.width/5, height: geometry.size.width/6, alignment: .center)
                        })
                        Button(action: {
                            isShowingCategoryEditView = true
                        }, label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color("Purple"))
                                
                                Image(systemName: "plus")
                                    .font(.system(size: geometry.size.width/10))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .frame(width: geometry.size.width/5, height: geometry.size.width/6, alignment: .center)
                        })
                    }
                }
            }
            .padding()
        }
        .sheet(isPresented: $isShowingCalendar) {
            CalendarHomeView(viewModel: viewModel)
        }
        .sheet(isPresented: $isShowingCategoryEditView) {
            CategoryEditView(viewModel: viewModel, isShowingCategoryEditView: $isShowingCategoryEditView, geometry: geometry)
        }
    }
    
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
        HomeView(viewModel: CategoryTaskViewModel(), geometry: geometry)
        }
    }
}
