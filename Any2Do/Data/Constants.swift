//
//  constant.swift
//  Any2Do
//
//  Created by Mint on 2022/3/10.
//

import Foundation
import SwiftUI

struct Constants {
    struct haptic {
        static let rigid = UIImpactFeedbackGenerator(style: .rigid)
        static let heavy = UIImpactFeedbackGenerator(style: .heavy)
        static let medium = UIImpactFeedbackGenerator(style: .medium)
        static let light = UIImpactFeedbackGenerator(style: .light)
    }
}
