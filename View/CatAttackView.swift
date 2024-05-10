//
//  CatAttackView.swift
//  DoNotDisturbTheCat
//
//  Created by Megan Yi on 1/13/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct CatAttackView: View {
    @State var isAnimating: Bool = false
    
    var body: some View {
        AnimatedImage(name: "cat_attack.gif", isAnimating: $isAnimating)
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CatAttackView()
}
