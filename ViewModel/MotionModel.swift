//
//  MotionModel.swift
//  DoNotDisturbTheCat
//
//  Created by Megan Yi on 1/11/24.
//

import CoreMotion

class MotionManager: ObservableObject {
    let motion = CMMotionManager()
    @Published var rotationRate: CMRotationRate = CMRotationRate(x: 0, y: 0, z: 0)
    let rotationThreshold = 1.2
    @Published var isRotating = false
    
    // start getting rotation rate updates and check for if rotating
    func startMotionManager() {
        // check if device supports gyroscope
        if motion.isGyroAvailable {
            motion.gyroUpdateInterval = 1.0 / 10.0 // 10 Hz
            motion.startGyroUpdates(to: .main) { data, error in
                if let rotationRate = data?.rotationRate {
                    self.rotationRate = rotationRate
                    print("X: \(rotationRate.x), Y: \(rotationRate.y), Z: \(rotationRate.z)")
                    self.detectRotationRate()
                }
            }
        } else {
            print("Gyroscope is not available on this device.")
        }
    }
    
    // stop getting rotation rate updates
    func stopMotionManager() {
        motion.stopGyroUpdates()
    }
    
    // check if rotation rate exceeds rotation threshold in any axis
    func detectRotationRate() {
        let sum = abs(rotationRate.x) + abs(rotationRate.y) + abs(rotationRate.z)
//        if abs(rotationRate.x) >= rotationThreshold || abs(rotationRate.y) >= rotationThreshold || abs(rotationRate.z) >= rotationThreshold {
        if sum >= rotationThreshold {
            isRotating = true
        }
    }
    
    // if/when change to automatic dismissal of cat attack screen
//    func detectNoRotation() {
//        
//    }
}
