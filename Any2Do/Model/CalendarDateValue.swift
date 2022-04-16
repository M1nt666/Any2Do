//
//  CalendarDateValue.swift
//  Any2Do
//
//  Created by Mint on 2022/2/26.
//

import Foundation

struct CalendarDateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
