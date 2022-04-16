//
//  CategoryEditView.swift
//  Any2Do
//
//  Created by Mint on 2022/2/24.
//

import SwiftUI
import CoreData

struct CategoryEditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CategoryTaskViewModel
    
    @Binding var isShowingCategoryEditView: Bool
    @State var categoryEditName = ""
    @State var categorySelectImage = "wallet.pass"
    
    @State var errorCategoryShowing = false
    @State var errorCategoryTitle = ""
    @State var errorCategoryMessage = ""
    
    let categoryTagImages = ["wallet.pass", "person","house","book","case","building.2","gamecontroller","lightbulb","fork.knife","display","airplane","tshirt","music.quarternote.3","gift","cart",]
    let categoryGridLayout: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack(alignment: .center){
            VStack(alignment: .center){
                HStack{
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
                        if self.categoryEditName != "" {
                            viewModel.addNewCategory(with: categoryEditName, and: categorySelectImage)
                            print("save a new category：\(categoryEditName)")
                            isShowingCategoryEditView = false
                        } else {
                            self.errorCategoryShowing = true
                            self.errorCategoryTitle = "Invalid Category Name"
                            self.errorCategoryMessage = "Please confirm the category name you entered!"
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
                    
                    
                    TextField("Category Name", text: $categoryEditName)
                        .font(.system(size: geometry.size.width/12, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .keyboardType(.namePhonePad)
                        .padding()
                    
                    
                        LazyVGrid(columns: categoryGridLayout, alignment: .center, spacing: 40) {
                            ForEach(categoryTagImages, id:\.self) { image in
                                Image(systemName: image)
                                    .font(.system(size: geometry.size.width/15))
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .strokeBorder(lineWidth: 5)
                                            .foregroundColor(.gray)
                                            .opacity(isSameImage(image1: image, image2: categorySelectImage) ? 1 : 0 )
                                    )
                                    .onTapGesture {
                                        categorySelectImage = image
                                    }
                            }
                        }
                    
                    Spacer()
                }
            }
        }
        .alert(isPresented: $errorCategoryShowing) {
            Alert(title: Text(errorCategoryTitle), message: Text(errorCategoryMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func isSameImage(image1: String, image2: String) ->Bool{
        return image1 == image2
    }
}

struct CategoryEditView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            CategoryEditView(viewModel: CategoryTaskViewModel(), isShowingCategoryEditView: .constant(true), geometry: geometry)
        }
    }
}

