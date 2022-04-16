//
//  SideContentView.swift
//  Any2Do
//
//  Created by Mint on 2022/2/23.
//

import SwiftUI

struct SideContentView: View {
    
    var sideContentImage: String
    var sideContentName: String
    let geometry: GeometryProxy
    
    var body: some View {
        HStack(spacing:5){
            Image(systemName: sideContentImage)
                .font(.system(size: geometry.size.width/15))
                .frame(width: geometry.size.width/12, height: geometry.size.width/12)
            
            Text(sideContentName)
                .font(.system(size: geometry.size.width/20))
                .frame(width: geometry.size.width/5, height: geometry.size.width/15)
            
            Spacer()
                .frame(width:geometry.size.width/12)
            
            Image(systemName: "chevron.right")
                .font(.system(size: geometry.size.width/20))
            Spacer()
        }
        .foregroundColor(.white)
        .padding()
        
    }
}

struct SideContentView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            SideContentView(sideContentImage: "gearshape", sideContentName: "Setting", geometry: geometry)
            .preferredColorScheme(.dark)
        }
    }
}
