//
//  Player.swift
//  Waveform
//
//  Created by Syed Haris Ali on 12/28/17.
//  Copyright © 2017 Ausome Apps LLC. All rights reserved.
//

import Foundation
import AVFoundation
import os.log

class Player {
    
    static let logger = OSLog(subsystem: "com.ausomeapps", category: "Player")
    
    /// An internal instance of AVAudioEngine
    private let engine = AVAudioEngine()
    
    /// The node responsible for playing the audio file
    private let playerNode = AVAudioPlayerNode()
    
    /// The currently playing audio file
    private var currentFile: AVAudioFile? {
        didSet {
            if let file = currentFile {
                loadFile(file)
            }
        }
    }
    
    /// A delegate to receive events from the Player
    weak var delegate: PlayerDelegate?
    
    /// A Bool indicating whether the engine is playing or not
    var isPlaying: Bool {
        return engine.isRunning
    }
    
    /// Singleton instance of the player
    static let shared = Player()
    
    init() {
        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: nil)
        engine.prepare()
        
        engine.mainMixerNode.installTap(onBus: 0, bufferSize: 512, format: nil, block: onTap(_:_:))
    }
    
    // MARK: Playback
    
    func play() {
        os_log("%@ - %d", log: Player.logger, type: .default, #function, #line)
        
        guard !isPlaying else {
            return
        }
        
        do {
            try engine.start()
            
            if let _ = currentFile {
                playerNode.play()
            }
            
            delegate?.player(self, didChangePlaybackState: true)
        } catch {
            os_log("Error starting engine: %@", log: Player.logger, type: .default, #function, #line, error.localizedDescription)
        }
    }
    
    func pause() {
        os_log("%@ - %d", log: Player.logger, type: .default, #function, #line)
        
        guard isPlaying else {
            return
        }
        
        engine.pause()
        
        delegate?.player(self, didChangePlaybackState: false)
    }
    
    // MARK: File Loading
    
    private func loadFile(_ file: AVAudioFile) {
        os_log("%@ - %d", log: Player.logger, type: .default, #function, #line)
        
        playerNode.scheduleFile(file, at: nil) {
            [unowned self] in
            self.currentFile = nil
        }
    }
    
    func loadFile(with url: URL) {
        os_log("%@ - %d", log: Player.logger, type: .default, #function, #line)
        
        do {
            currentFile = try AVAudioFile(forReading: url)
        } catch {
        os_log("Error loading (%@): %@", log: Player.logger, type: .default, #function, #line, url.absoluteString, error.localizedDescription)
        }
    }
    
    // Tap
    
    private func onTap(_ buffer: AVAudioPCMBuffer, _ time: AVAudioTime) {
        os_log("%@ - %d", log: Player.logger, type: .default, #function, #line)
    }
}
