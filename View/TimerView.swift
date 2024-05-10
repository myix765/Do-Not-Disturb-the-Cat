//
//  TimerView.swift
//  DoNotDisturbTheCat
//
//  Created by Megan Yi on 1/9/24.
//

import SwiftUI

struct TimerView: View {
    var workSeconds: Int
    var breakSeconds: Int

    @ObservedObject var timer: TimerModel
//    @State private var alarmKeys: [String]
    
    init(workSeconds: Int, breakSeconds: Int) {
        UINavigationBar.setAnimationsEnabled(false)
        self.workSeconds = workSeconds
        self.breakSeconds = breakSeconds
        self.timer = TimerModel(workTimerDuration: workSeconds, breakTimerDuration: breakSeconds)
//        self.timer.startCorrectTimer()
    }
    
    let catAttack = ["cat_raise", "cat_slap"]
    @State private var currentImageIndex = 0
    @State private var isDoNotDisturb: Bool = false
//    @State private var isAlarm: Bool = true
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                // moon and sun cycle view
                SunMoonCycleView(isDoNotDisturb: $isDoNotDisturb)
                    .offset(x: 0, y: -50)
                
                // timer components
                VStack(spacing: 0) {
                    Spacer()
                    Text(isDoNotDisturb ? "Work Time" : "Break Time")
                        .font(.title3)
                    Text(timer.formatTimer(seconds: timer.isWorkTimer ? timer.workTimeRemaining : timer.breakTimeRemaining))
                        .font(.system(size: 80))
//                    Rectangle()
//                        .frame(height: 300)
//                        .opacity(0.1)
                    if !timer.motionManager.isRotating {
                        Image(isDoNotDisturb ? "cat_sleep" : "cat_sit")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 300)
                            .clipped()
                            .padding(20)
                    }
                    Text(timer.isWorkTimer ? "do not disturb the cat" : "break time!")
                        .padding(.bottom, 20)
                    
                    // play/pause button
//                    Button(action: {
//                        if timer.workTimerMode == .running || timer.breakTimerMode == .running {
//                            timer.stopTimer()
//                        } else {
//                            timer.startCorrectTimer()
//                        }
//                        isDoNotDisturb = timer.isWorkTimer
//                    }, label: {
//                        Image(systemName: timer.isTimerPlaying ? "pause.circle" : "play.circle")
//                            .font(.system(size: 60))
//                            .foregroundColor(.black)
//                    })
                    
                    Image(systemName: timer.isTimerPlaying ? "pause.circle" : "play.circle")
                        .font(.system(size: 60))
                        .foregroundColor(.black)
                        .onTapGesture {
                            if timer.workTimerMode == .running || timer.breakTimerMode == .running {
                                timer.stopTimer()
                            } else {
                                timer.startCorrectTimer()
                            }
                            isDoNotDisturb = timer.isWorkTimer
                        }
                    Spacer()
                        .frame(height: 100)
                }
                
                // sound control button
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Button(action: {
                            timer.isAlarm.toggle()
                            if !timer.isAlarm {
                                timer.soundManager.stopSound()
                            }
//                            timer.alarmIndex = 0
                        }, label: {
                            Image(systemName: timer.isAlarm ? "bell" : "bell.slash")
                                .foregroundColor(.black)
                                .font(.system(size: 30))
                        })
                        .padding(.bottom, 260)
                    }
                    .padding(.trailing, 20)
                }
                
                // custom navigation back button
                VStack {
                    HStack {
                        NavigationLink(
                            destination: TimePickerView()
                                .navigationBarBackButtonHidden(true)
                                .onAppear {
                                    timer.resetTimer()
                                    timer.soundManager.stopSound()
                                }
                        ) {
                            Image(systemName: "arrow.left.circle")
                                .font(.system(size: 40))
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.top, 72)
                .padding(.leading, 32)
                
                // notification of coins received
//                if timer.isWorkTimerDone {
//                    VStack {
//                        coinsGiftedPopUp(numCoins: Int(0.5))
//                            .padding(.top, 30)
//                        Spacer()
//                    }
//                    .onAppear() {
//                        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in
//                            timer.isWorkTimerDone = false
//                        })
//                    }
//                }
                
                // show cat attack gif when rotation detected
                if timer.motionManager.isRotating {
                    ZStack {
                        CatAttackView()
                            .onAppear {
                                timer.stopTimer()
                            }
                        VStack {
                            Spacer()
                            Button(action: {
                                timer.motionManager.isRotating = false
                                timer.startCorrectTimer()
                                timer.motionManager.stopMotionManager()
                                Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false) { _ in
                                    if timer.isTimerPlaying {
                                        timer.motionManager.startMotionManager()
                                    }
                                }
                            }, label: {
                                Image("get_back_to_work_bttn")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 350, height: 120)
                            })
                            .padding(.bottom, 50)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
    }
    
    // coin notification view
    private func coinsGiftedPopUp(numCoins: Int) -> some View {
        Text("\(numCoins) coins have been granted")
            .padding()
            .border(.black)
            .background(.white)
    }
}

#Preview {
    TimerView(workSeconds: 10, breakSeconds: 5)
}

//struct SoundControlPanel: View {
//    let rounding: CGFloat = 25
//    @Binding var showSoundControl: Bool
//    
//    var body: some View {
//            GeometryReader { geometry in
//                ZStack {
//                    // x button to close
//                    HStack {
//                        Spacer()
//                        VStack {
//                            Image(systemName: "xmark")
//                                .font(.system(size: 21))
//                                .onTapGesture {
//                                    withAnimation {
//                                        showSoundControl.toggle()
//                                    }
//                                }
//                            Spacer()
//                        }
//                    }
//                    .padding(.top, 24)
//                    .padding(.trailing, 22)
//                        
//                }
//                .frame(width: geometry.size.width - 15, height: 360)
//                .background(Color.white)
//                .overlay(
//                    RoundedRectangle(cornerRadius: rounding)
//                        .stroke(Color.black, lineWidth: 6)
//                )
//                .cornerRadius(rounding)
//                .position(x: geometry.size.width / 2, y: geometry.size.height - 160)
//            }
//            .background(Color.black.opacity(0.2))
//    }
//}
