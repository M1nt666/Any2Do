//
//  MotionAnimationView.swift
//  ThePlacesOfInterest
//
//  Created by Mint on 2022/1/21.
//

import SwiftUI

struct MotionAnimationView: View {
    
    @State private var randomCircle = Int.random(in: 12...16)
    @State private var isAnimating = false
    
    func randomCoordinate(max: CGFloat) -> CGFloat {
        return CGFloat.random(in: 0...max)
    }
    
    func randomSize() -> CGFloat {
        return CGFloat(Int.random(in: 10...300))
    }
    

    func randomScale() -> CGFloat {
        CGFloat(Double.random(in: 0.1...2.0))
    }
    
    func randomSpeed() -> Double {
        Double.random(in: 0.8...1.2)
    }
    
    func randomDelay() -> Double {
        Double.random(in: 0...2)
    }
    
    var body: some View {
        GeometryReader {
            geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("Purple")]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                ForEach(0..<randomCircle, id:\.self) { item in
                Circle()
                    .foregroundColor(.white)
                    .opacity(0.15)
                    .frame(width: randomSize() , height: randomSize(), alignment: .center)
                    .scaleEffect(isAnimating ? randomScale() : 1)
                    
                    .position(x: randomCoordinate(max: geometry.size.width), y: randomCoordinate(max: geometry.size.height))
                    
                    .animation(Animation.interpolatingSpring(stiffness: 0.5, damping: 0.5)
    
                                .repeatForever()
                                .speed(randomSpeed())
                                .delay(randomDelay()),value: isAnimating)
                    .onAppear {
                        isAnimating = true
                    }
                }
            }
            .drawingGroup()
            .ignoresSafeArea(.all, edges: .all)
        }
    }
}

struct MotionAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        MotionAnimationView()
    }
}
