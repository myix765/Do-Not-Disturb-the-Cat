//
//  SoundModel.swift
//  DoNotDisturbTheCat
//
//  Created by Megan Yi on 1/14/24.
//

import AVFoundation

class SoundManager {
    var audioPlayer: AVAudioPlayer?
    
    func playSound(filename: String, type: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: type) else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 0.4
            audioPlayer?.play()
        } catch let error {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    func stopSound() {
        audioPlayer?.stop()
    }
}
