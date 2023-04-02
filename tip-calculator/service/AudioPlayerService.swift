//
//  AudioPlayerService.swift
//  tip-calculator
//
//  Created by 山本響 on 2023/04/02.
//

import Foundation
import AVFoundation

protocol AudioPlayerServie {
    func playSound()
}

final class DefaultAudioPlayer: AudioPlayerServie {
    
    private var player: AVAudioPlayer?
    
    func playSound() {
        let path = Bundle.main.path(forResource: "click", ofType: "m4a")!
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
}
