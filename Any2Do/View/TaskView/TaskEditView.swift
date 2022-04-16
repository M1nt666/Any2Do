//
//  CategoryDetailEditView.swift
//  Any2Do
//
//  Created by Mint on 2022/2/26.
//

import SwiftUI
import CoreData

struct TaskEditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CategoryTaskViewModel
    
    @State var taskEditName = ""
    @State var reminderEditTime = Date.now
    @State var taskNote = ""
    
    @State var errorShowing = false
    @State var errorTitle = ""
    @State var errorMessage = ""
    
    var dateRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .day, value: -100, to: Date())!
        let max = Calendar.current.date(byAdding: .day, value: 100, to: Date())!
        return min...max
    }
    
    let geometry: GeometryProxy
    let categoryForTask: CategoryForTask
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .center) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.system(size: geometry.size.width/15, weight: .semibold))
                            .foregroundColor(.gray)
                            .padding()
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        Constants.haptic.heavy.impactOccurred()
                        if self.taskEditName != "" {
                            viewModel.newCategoryTask(with: taskEditName, and: reminderEditTime, and: taskNote, to: categoryForTask)
                            print("save a new task：\(taskEditName), \(reminderEditTime), note: \(taskNote)")
                        } else {
                            self.errorShowing = true
                            self.errorTitle = "Invalid Task Name"
                            self.errorMessage = "Please confirm the task name you entered!"
                            return
                        }
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: geometry.size.width/15, weight: .semibold))
                            .foregroundColor(Color("Black"))
                            .padding()
                    })
                }
                Spacer()
                
                VStack(alignment:.center){
                    
                    TextField("Task Name", text: $taskEditName)
                        .font(.system(size: geometry.size.width/12, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .keyboardType(.namePhonePad)
                        .padding()
                    
                    ScrollView {
                        VStack(alignment: .leading,spacing: 10) {
                            HStack {
                                Image(systemName: "bell.badge")
                                    .font(.system(size: geometry.size.width/18))
                                Text("Reminder")
                                    .font(.system(size: geometry.size.width/18))
                                    .padding(.vertical)
                            }
                            .padding(.horizontal)
                            DatePicker(selection: $reminderEditTime,in:dateRange,displayedComponents: [.hourAndMinute,.date], label: {Text("Date&Time")})
                                .padding()
                            HStack{
                                Image(systemName: "text.bubble")
                                    .font(.system(size: geometry.size.width/18))
                                Text("Note")
                                    .font(.system(size: geometry.size.width/18))
                                    .padding(.vertical)
                            }
                            .padding(.horizontal)
                            TextField("Type something...", text: $taskNote)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal)
                                
                        }
                    }
                }
            }
            
            
        }
        .alert(isPresented: $errorShowing) {
            Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

//struct MultilineTextField: UIViewRepresentable {
//
//    @Binding var taskNote: String
//
//    func makeCoordinator() -> MultilineTextField.Coordinator {
//        return MultilineTextField.Coordinator(parent1: self)
//    }
//
//    func makeUIView(context: UIViewRepresentableContext<MultilineTextField>) -> UITextView {
//        let textView = UITextView()
//        textView.isEditable = true
//        textView.isUserInteractionEnabled = true
//        textView.isScrollEnabled = true
//        textView.text = "Type something..."
//        textView.textColor = .gray
//        textView.font = .systemFont(ofSize: 20)
//        textView.delegate = context.coordinator
//
//        return textView
//    }
//
//    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultilineTextField>) {
//
//    }
//
//    class Coordinator: NSObject, UITextViewDelegate{
//
//        var parent: MultilineTextField
//
//        init(parent1: MultilineTextField) {
//            parent = parent1
//        }
//
//        func textViewDidChange(_ textView: UITextView) {
//            self.parent.taskNote = textView.text
//        }
//
//        func textViewDidBeginEditing(_ textView: UITextView) {
//            textView.text = ""
//            textView.textColor = .label
//        }
//    }
//}
