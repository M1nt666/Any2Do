//
//  CategoryDetailView.swift
//  Any2Do
//
//  Created by Mint on 2022/2/25.
//

import SwiftUI
import CoreData

struct CategoryDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CategoryTaskViewModel
    let categoryForTask: CategoryForTask
    let geometry: GeometryProxy
    
    @State var isShowingDetailEditView = false
    
    var body: some View {
        ZStack{
            Color("Blue")
                .edgesIgnoringSafeArea(.top)
            
            VStack {
                CategoryDetailHeaderView(viewModel: viewModel, category: categoryForTask, geometry: geometry)
                
                List{
                    ForEach(viewModel.taskArray,id:\.self.taskId) { task in
                        TaskDetailsView(viewModel: viewModel, task: task, category: categoryForTask, geometry: geometry)
                            .navigationBarTitleDisplayMode(.inline)
                            .frame(height: 50)
                    }
                    .onDelete(perform: deleteTask)
                }
                .listStyle(DefaultListStyle())
                .cornerRadius(5)
            }
            .edgesIgnoringSafeArea(.bottom)
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut) {
                            isShowingDetailEditView.toggle()
                        }
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
            .padding()
        }
        .onAppear {
            viewModel.loadTask(by: categoryForTask)
        }
        .halfSheetView(showSheet: $isShowingDetailEditView, sheetView: {
            TaskEditView(viewModel: viewModel, geometry: geometry, categoryForTask: categoryForTask)
        })
        .navigationBarHidden(true)
        
        
    }
    
    private func deleteTask(offsets: IndexSet) {
        viewModel.deleteTask(by: offsets)
        viewModel.loadTask(by: categoryForTask)
    }
}

struct CategoryDetailHeaderView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CategoryTaskViewModel
    
    let category: CategoryForTask
    let geometry: GeometryProxy
    
    @State private var showingAlert = false
    
    var body: some View{
        VStack {
            HStack(alignment: .bottom) {
                if let categoryDetailViewName = category.categoryName{
                    VStack{
                        HStack{
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Image(systemName: "chevron.backward")
                                    .font(.system(size: geometry.size.width/15, weight: .semibold))
                                    .accentColor(.white)
                            })
                            Spacer()
                            Button {
                                Constants.haptic.rigid.impactOccurred()
                                showingAlert = true
                            } label: {
                                Image(systemName: "trash")
                                    .font(.system(size: geometry.size.width/15, weight: .semibold))
                                    .foregroundColor(.pink)
                            }
                            .alert(isPresented: $showingAlert) {
                                Alert(
                                    title: Text("Confirm deletion"),
                                    message: Text("Are you sure?"),
                                    primaryButton: .destructive(Text("Delete")) {
                                        viewModel.delete(the: category)
                                    },
                                    secondaryButton: .cancel(Text("Cancel"))
                                )
                            }
                        }
                        .padding()
                        HStack{
                            VStack(alignment: .leading,spacing: 18){
                                Text(categoryDetailViewName)
                                    .font(.system(size: geometry.size.width/15, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                if category.sumOfCategoryTask <= 1 {
                                    Text("\(category.sumOfCategoryTask) task")
                                        .font(.system(size: geometry.size.width/18, weight: .medium))
                                        .foregroundColor(.white)
                                }else {
                                    Text("\(category.sumOfCategoryTask) tasks")
                                        .font(.system(size: geometry.size.width/18, weight: .medium))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                            
                            Spacer()
                            
                            Image(systemName: category.categoryImageName ?? " ")
                                .font(.system(size: geometry.size.width/6))
                                .foregroundColor(.white)
                                .padding()
                        }
                        
                    }
                }
            }
        }
    }
}


struct TaskDetailsView: View {
    
    @ObservedObject var viewModel: CategoryTaskViewModel
    let task: Task
    let category: CategoryForTask
    let geometry: GeometryProxy
    
    var body: some View{
        VStack {
            HStack(alignment: .center, spacing: 20){
                Image(systemName: task.taskDone ? "checkmark" :"circle")
                    .font(.system(size: geometry.size.width/10, weight: .medium))
                    .padding(.vertical)
                    .foregroundColor(Color("Purple"))
                    .onTapGesture {
                        task.taskDone.toggle()
                        task.taskFlag = false
                        viewModel.saveData(by: category)
                        Constants.haptic.medium.impactOccurred()
                    }
                    .animation(.default, value: task.taskDone)
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack{
                            Image(systemName: "alarm")
                                .font(.footnote)
                            Text(taskDate(date: task.taskReminder))
                                .font(.footnote)
                                .strikethrough(task.taskDone ? true : false)
                            if task.taskNote?.count ?? 0 >= 1 {
                                Image(systemName: "message")
                                    .font(.footnote)
                            }
                        }
                        Text(task.taskName ?? "task name")
                            .font(.system(size: geometry.size.width/15))
                            .strikethrough(task.taskDone ? true : false)
                    }
                    .foregroundColor(task.taskDone ? Color("Gray") : Color("Black") )
                    .padding(.vertical)
                    .animation(.default, value: task.taskDone)
                    
                    Spacer()
                }
                .contextMenu {
                    Text(task.taskNote ?? "No note")
                }
                
                Image(systemName: task.taskFlag ? "flag.fill" : "flag")
                    .font(.system(size: geometry.size.width/10))
                    .foregroundColor(task.taskFlag ? Color("Red"): Color("Black") )
                    .padding(.vertical)
                    .onTapGesture {
                        task.taskFlag.toggle()
                        viewModel.saveData(by: category)
                        Constants.haptic.light.impactOccurred()
                    }
                    .animation(.default, value: task.taskFlag)
            }
        }
        
    }
    
    func taskDate(date: Date?) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm"
        
        let date = formatter.string(from: date ?? Date())
        return date
    }
}

extension View{
    
    func halfSheetView<SheetView: View>(showSheet: Binding<Bool>, @ViewBuilder sheetView:@escaping () ->SheetView) -> some View{
        
        return self
            .background(
                HalfSheetViewHelper(sheetView: sheetView(), isShowingDetailEditView: showSheet)
            )
    }
}


struct HalfSheetViewHelper<SheetView: View>: UIViewControllerRepresentable{
    var sheetView: SheetView
    @Binding var isShowingDetailEditView: Bool
    
    let controllar = UIViewController()
    func makeUIViewController(context: Context) -> UIViewController {
        controllar.view.backgroundColor = .clear
        return controllar
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isShowingDetailEditView {
            let sheetController = CustomHostingController(rootView: sheetView)
            
            uiViewController.present(sheetController, animated: true) {
                DispatchQueue.main.async {
                    self.isShowingDetailEditView.toggle()
                }
            }
        }
    }
}

class CustomHostingController<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
        if let presentationController = presentationController as? UISheetPresentationController{
            presentationController.detents = [
                .medium(),
                .large()
            ]
            presentationController.prefersGrabberVisible = true
        }
    }
}
