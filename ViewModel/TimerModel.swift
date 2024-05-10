//
//  TimerModel.swift
//  DoNotDisturbTheCat
//
//  Created by Megan Yi on 1/9/24.
//

import SwiftUI

class TimerModel: ObservableObject {
    // given in seconds
    @Published var workTimerDuration: Int
    @Published var breakTimerDuration: Int
    @Published var workTimerMode: TimerMode = .initial
    @Published var breakTimerMode: TimerMode = .initial
    // time remaining in seconds
    @Published var workTimeRemaining: Int
    @Published var breakTimeRemaining: Int
    @Published var workTimer: Timer?
    @Published var breakTimer: Timer?
    // true is work mode, false is break mode
    @Published var isWorkTimer = true
    // state of the play/pause button
    @Published var isTimerPlaying = false
    @Published var isWorkTimerDone = false
    
    @ObservedObject var motionManager = MotionManager()
    
    var soundManager = SoundManager()
    @Published var isAlarm = true
//    var alarms: [String:String] = [
//        "silent": "silent",
//        "ringtone": "mp3", // https://pixabay.com/sound-effects/ringtone-126505/
//    ]
//    var alarmKeys: [String]
//    @Published var alarmIndex: Int = 1
    
    // three phases the timer can be
    enum TimerMode {
        case initial
        case paused
        case running
    }
    
    // initialize the work and break timer amounts
    init(workTimerDuration: Int, breakTimerDuration: Int) {
        self.workTimerDuration = workTimerDuration
        self.breakTimerDuration = breakTimerDuration
        self.workTimeRemaining = workTimerDuration
        self.breakTimeRemaining = breakTimerDuration
//        alarmKeys = Array(alarms.keys)
    }
    
    // start either the work or break timer depending on current mode
    func startCorrectTimer() {
        self.soundManager.stopSound()
        if isWorkTimer {
            startWorkTimer()
            var motionGracePeriod: Timer?
            motionGracePeriod = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
                // only start motion manager if the timer is playing
                if self.isTimerPlaying {
                    self.motionManager.startMotionManager()
                    motionGracePeriod?.invalidate()
                    motionGracePeriod = nil
                }
            }
        } else {
            startBreakTimer()
        }
    }
    
    // start work timer
    func startWorkTimer() { // note: not a perfect timer because when pausing and resuming the timer, takes another whole second to countdown even if pausing in middle of second
        workTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            // if timer is not done
            if self.workTimeRemaining > 0 {
                self.workTimeRemaining -= 1
            // if timer is done
            } else {
                self.isWorkTimerDone = true
                self.motionManager.stopMotionManager()
                // requires silent mode to be turned off
                /*self.soundManager.playSound(filename: self.alarmKeys[self.alarmIndex], type: self.alarms[self.alarmKeys[self.alarmIndex]]!)*/ // WARNING: force unwrap
                self.isAlarm ? self.soundManager.playSound(filename: "ringtone", type: "mp3") : self.soundManager.stopSound()
                self.resetTimer()
                // change to break timer mode
                self.isWorkTimer.toggle()
            }
        }
        workTimerMode = .running
        isTimerPlaying = true
    }
    
    // start break timer
    func startBreakTimer() {
        breakTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            // if timer is not done
            if self.breakTimeRemaining > 0 {
                self.breakTimeRemaining -= 1
            // if timer is done
            } else {
                self.breakTimer?.invalidate()
                self.motionManager.stopMotionManager()
                // requires silent mode to be turned off
                self.isAlarm ? self.soundManager.playSound(filename: "ringtone", type: "mp3") : self.soundManager.stopSound()
                self.resetTimer()
                // change to work timer mode
                self.isWorkTimer.toggle()
            }
        }
        breakTimerMode = .running
        isTimerPlaying = true
    }
    
    // stop all timers and change all their states to initial
    func stopTimer() {
        workTimer?.invalidate()
        breakTimer?.invalidate()
        workTimerMode = .paused
        breakTimerMode = .paused
        isTimerPlaying = false
        // when timer is stopped, also stop motion manager
        motionManager.stopMotionManager()
    }
    
    // reset all timers to their original set value
    func resetTimer() {
        workTimer?.invalidate()
        breakTimer?.invalidate()
        workTimerMode = .initial
        breakTimerMode = .initial
        self.workTimeRemaining = workTimerDuration
        self.breakTimeRemaining = breakTimerDuration
        isTimerPlaying = false
    }
    
    // write seconds in minute:second fomat
    func formatTimer(seconds: Int) -> String {
        let formattedSeconds = seconds % 60
        let formattedMinutes = seconds / 60
        return String(format: "%02d:%02d", formattedMinutes, formattedSeconds )
    }
}

