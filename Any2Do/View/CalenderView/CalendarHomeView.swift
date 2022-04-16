//
//  CalenderHomeView.swift
//  Any2Do
//
//  Created by Mint on 2022/2/26.
//

import SwiftUI

struct CalendarHomeView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CategoryTaskViewModel
    
    @State var currentDate: Date = Date()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                ScrollView(.vertical, showsIndicators: false) {
                    CalendarDatePickerView(viewModel: viewModel, geometry: geometry, currentDate: $currentDate)
                }
            }
        }
    }
}

struct CalenderHomeView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarHomeView(viewModel: CategoryTaskViewModel())
    }
}
