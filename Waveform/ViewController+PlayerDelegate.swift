//
//  ViewController+PlayerDelegate.swift
//  Waveform
//
//  Created by Syed Haris Ali on 12/28/17.
//  Copyright © 2017 Ausome Apps LLC. All rights reserved.
//

import Foundation
import os.log

extension ViewController: PlayerDelegate {
    
    func player(_ player: Player, didChangePlaybackState isPlaying: Bool) {
        os_log("%@ - %d", log: ViewController.logger, type: .default, #function, #line)
        
        if isPlaying {
            playButton.setTitle("Pause", for: .normal)
        } else {
            playButton.setTitle("Play", for: .normal)
        }
    }
    
    func player(_ player: Player, didPlayFile file: AVAudioFile, atTime time: TimeInterval, withBuffer
        buffer: AVAudioPCMBuffer) {
        os_log("%@ - %d [time: %f]", log: ViewController.logger, type: .default, #function, #line, time)
        
        if let floatBuffer = buffer.floatChannelData {
            let first = floatBuffer[0]
            plot.updateBuffer(first, withBufferSize: UInt32(buffer.frameLength))
        }
    }
    
}
