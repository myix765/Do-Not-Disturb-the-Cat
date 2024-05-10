//
//  ContentView.swift
//  DoNotDisturbTheCat
//
//  Created by Megan Yi on 1/4/24.
//

import SwiftUI

struct ContentView: View {
//    init() {
//        UINavigationBar.setAnimationsEnabled(false)
//    }
    
    var body: some View {
        TimePickerView()
            .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
