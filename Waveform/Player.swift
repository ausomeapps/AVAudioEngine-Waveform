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

/// High level audio player class
class Player {
    
    /// Default properties for the tap
    enum TapProperties {
        case `default`
        
        /// The amount of samples in each buffer of audio
        var bufferSize: AVAudioFrameCount {
            return 512
        }
        
        /// The format of the audio in the tap (desired is float 32, non-interleaved)
        var format: AVAudioFormat {
            return AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 44100, channels: 2, interleaved: false)!
        }
    }
    
    /// Namespaced logger
    private static let logger = OSLog(subsystem: "com.ausomeapps", category: "Player")
    
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
        return playerNode.isPlaying
    }
    
    /// Singleton instance of the player
    static let shared = Player()
    
    // MARK: Lifecycle
    
    deinit {
        engine.mainMixerNode.removeTap(onBus: 0)
    }
    
    init() {
        /// Make connections
        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: TapProperties.default.format)
        engine.prepare()
        
        /// Install tap
        playerNode.installTap(onBus: 0, bufferSize: TapProperties.default.bufferSize, format: TapProperties.default.format, block: onTap(_:_:))
    }
    
    // MARK: Playback
    
    /// Begins playback (starts engine and player node)
    func play() {
        os_log("%@ - %d", log: Player.logger, type: .default, #function, #line)
        
        guard !isPlaying, let _ = currentFile else {
            return
        }
        
        do {
            try engine.start()
            playerNode.play()
            delegate?.player(self, didChangePlaybackState: true)
        } catch {
            os_log("Error starting engine: %@", log: Player.logger, type: .default, #function, #line, error.localizedDescription)
        }
    }
    
    /// Pauses playback (pauses the engine and player node)
    func pause() {
        os_log("%@ - %d", log: Player.logger, type: .default, #function, #line)
        
        guard isPlaying, let _ = currentFile else {
            return
        }
        
        playerNode.pause()
        engine.pause()
        delegate?.player(self, didChangePlaybackState: false)
    }
    
    // MARK: File Loading
    
    /// Loads an AVAudioFile into the current player node
    private func loadFile(_ file: AVAudioFile) {
        os_log("%@ - %d", log: Player.logger, type: .default, #function, #line)
        
        playerNode.scheduleFile(file, at: nil) {
            [unowned self] in
            self.currentFile = nil
        }
    }
    
    /// Loads an audio file at the provided URL into the player node
    func loadFile(with url: URL) {
        os_log("%@ - %d", log: Player.logger, type: .default, #function, #line)
        
        do {
            currentFile = try AVAudioFile(forReading: url)
        } catch {
        os_log("Error loading (%@): %@", log: Player.logger, type: .error, #function, #line, url.absoluteString, error.localizedDescription)
        }
    }
    
    // MARK: Tap
    
    /// Handles the audio tap
    private func onTap(_ buffer: AVAudioPCMBuffer, _ time: AVAudioTime) {
        guard let file = currentFile,
              let nodeTime = playerNode.lastRenderTime,
              let playerTime = playerNode.playerTime(forNodeTime: nodeTime) else {
            return
        }
        
        let currentTime = TimeInterval(playerTime.sampleTime) / playerTime.sampleRate
        delegate?.player(self, didPlayFile: file, atTime: currentTime, withBuffer: buffer)
    }
}
