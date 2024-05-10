//
//  SunMoonCycleView.swift
//  DoNotDisturbTheCat
//
//  Created by Megan Yi on 1/15/24.
//

import SwiftUI

struct SunMoonCycleView: View {
    @Binding var isDoNotDisturb: Bool
    @State private var rotationFirstHalf: Double = 0.0
    @State private var rotationSecondHalf: Double = 0.0
    
    let radius: CGFloat
    @State private var offsetFirstHalf: (x: CGFloat, y: CGFloat)
    @State private var offsetSecondHalf: (x: CGFloat, y: CGFloat)
    
    init(isDoNotDisturb: Binding<Bool>) {
        self.radius = 240.0
        self._offsetFirstHalf = State(initialValue: (x: 0.0, y: -self.radius))
        self._offsetSecondHalf = State(initialValue: (x: -self.radius, y: 0.0))
        _isDoNotDisturb = isDoNotDisturb
    }
    
    var body: some View {
        VStack {
            ZStack {
                Image(isDoNotDisturb ? "rotation_moon" : "rotation_sun")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(135))
                    .offset(x: offsetFirstHalf.x, y: offsetFirstHalf.y)
                    .rotationEffect(.degrees(rotationFirstHalf), anchor: .center)
                    .onChange(of: isDoNotDisturb) { _ in
                        offsetFirstHalf = (x: radius, y: 0)
                        rotationFirstHalf = 0.0
                        withAnimation(Animation.timingCurve(0.6, 0.4, 0.2, 1.15, duration: 1.8)) {
                            rotationFirstHalf = -90.0
                        }
                    }
                
                Image(isDoNotDisturb ? "rotation_sun" : "rotation_moon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(45))
                    .offset(x: offsetSecondHalf.x, y: offsetSecondHalf.y)
                    .rotationEffect(.degrees(rotationSecondHalf), anchor: .center)
                    .onChange(of: isDoNotDisturb) { _ in
                        offsetSecondHalf = (x: 0, y: -radius)
                        rotationSecondHalf = 0.0
                        withAnimation(Animation.timingCurve(0.5, -0.15, 0.3, 1.0, duration: 1.8)) {
                            rotationSecondHalf = -90.0
                        }
                    }
            }
        }
    }
}

#Preview {
    SunMoonCycleView(isDoNotDisturb: .constant(false))
}
