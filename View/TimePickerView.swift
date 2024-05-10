//
//  TimePickerView.swift
//  DoNotDisturbTheCat
//
//  Created by Megan Yi on 1/17/24.
//

import SwiftUI

struct TimePickerView: View {
    let availableSeconds = [0, 15, 30, 45]
    let availableMinutes = Array(stride(from: 0, through: 60, by: 5))
    
    // set default to 25 min and 0 sec for work
    @State private var selectedWorkMinuteIndex = 5
    @State private var selectedWorkSecondIndex = 0
    
    // set default to 5 min and 0 sec for break
    @State private var selectedBreakMinuteIndex = 1
    @State private var selectedBreakSecondIndex = 0
    
    // set equal to default seconds
    @State private var totalWorkSeconds: Int = 1500
    @State private var totalBreakSeconds: Int = 300
    
    func calculateTotalSeconds(minutes: Int, seconds: Int) -> Int {
        return (minutes * 60) + seconds
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                
                // TODO: remove the slide over animation when changing views
                Image("rotation_sun")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(135))
                    .offset(x: 0, y: -290)
                VStack(spacing: 0) {
                    Spacer()
                    
                    PickerView(pickerTitle: "Set Work Timer", availableMinutes: availableMinutes, availableSeconds: availableSeconds, selectedMinuteIndex: $selectedWorkMinuteIndex, selectedSecondIndex: $selectedWorkSecondIndex)
                        // if work minute index changes
                        .onChange(of: selectedWorkMinuteIndex) { _ in
                            totalWorkSeconds = calculateTotalSeconds(minutes: availableMinutes[selectedWorkMinuteIndex], seconds: availableSeconds[selectedWorkSecondIndex])
                        }
                        // if work seconds index changes
                        .onChange(of: selectedWorkSecondIndex) { _ in
                            totalWorkSeconds = calculateTotalSeconds(minutes: availableMinutes[selectedWorkMinuteIndex], seconds: availableSeconds[selectedWorkSecondIndex])
                        }
                    
                    PickerView(pickerTitle: "Set Break Timer", availableMinutes: availableMinutes, availableSeconds: availableSeconds, selectedMinuteIndex: $selectedBreakMinuteIndex, selectedSecondIndex: $selectedBreakSecondIndex)
                        // if break minute index changes
                        .onChange(of: selectedBreakMinuteIndex) { _ in
                            totalBreakSeconds = calculateTotalSeconds(minutes: availableMinutes[selectedBreakMinuteIndex], seconds: availableSeconds[selectedBreakSecondIndex])
                        }
                        // if break seconds index changes
                        .onChange(of: selectedBreakSecondIndex) { _ in
                            totalBreakSeconds = calculateTotalSeconds(minutes: availableMinutes[selectedBreakMinuteIndex], seconds: availableSeconds[selectedBreakSecondIndex])
                        }
                    
                    Spacer()
                        .frame(height: 140)
                    
                    NavigationLink(destination: TimerView(workSeconds: totalWorkSeconds, breakSeconds: totalBreakSeconds).navigationBarBackButtonHidden(true)) {
                        Image(systemName: "play.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.black)
                    }
                    
                    // to make play button in same position as blay button in timer view
                    Spacer()
                        .frame(height: 100)
                }
                
            }
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    TimePickerView()
}

// view to select the minute and second duration of specified timer
struct PickerView: View {
    var pickerTitle: String
    var availableMinutes: [Int]
    var availableSeconds: [Int]
    @Binding var selectedMinuteIndex: Int
    @Binding var selectedSecondIndex: Int
    
    var body: some View {
        VStack {
            Text(pickerTitle)
            HStack(spacing: 0) {
                Picker(selection: $selectedMinuteIndex, label: Text("")) {
                    ForEach(0..<availableMinutes.count, id: \.self) {
                        Text("\(availableMinutes[$0]) min")
                    }
                }
                Picker(selection: $selectedSecondIndex, label: Text("")) {
                    ForEach(0..<availableSeconds.count, id: \.self) {
                        Text("\(availableSeconds[$0]) sec")
                    }
                }
            }
            .labelsHidden()
//            .pickerStyle(.wheel)
//            .frame(width: 300, height: 150)
//            .clipped()
            // to make menu size smaller and let user scroll instead could use list instead of picker
        }
        .padding(.top, 30)
    }
}
