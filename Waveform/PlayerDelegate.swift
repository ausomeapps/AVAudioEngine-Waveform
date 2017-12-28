
//
//  PlayerDelegate.swift
//  Waveform
//
//  Created by Syed Haris Ali on 12/28/17.
//  Copyright © 2017 Ausome Apps LLC. All rights reserved.
//

import Foundation
import AVFoundation

protocol PlayerDelegate: class {
    
    func player(_ player: Player, didChangePlaybackState isPlaying: Bool)
    
    func player(_ player: Player, didPlayFile file: AVAudioFile, atTime time: TimeInterval, withBuffer buffer: AVAudioPCMBuffer)
    
}
