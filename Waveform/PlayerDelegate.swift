
//
//  PlayerDelegate.swift
//  Waveform
//
//  Created by Syed Haris Ali on 12/28/17.
//  Copyright © 2017 Ausome Apps LLC. All rights reserved.
//

import Foundation
import AVFoundation

/// Handles communicating `Player` events
protocol PlayerDelegate: class {
    
    /// Notifies the `Player` has either started or stopped playing audio
    func player(_ player: Player, didChangePlaybackState isPlaying: Bool)
    
    /// Notifies everytime the `Player` receives a new audio tap event that contains the current time and buffer of audio data played
    func player(_ player: Player, didPlayFile file: AVAudioFile, atTime time: TimeInterval, withBuffer buffer: AVAudioPCMBuffer)
    
}
