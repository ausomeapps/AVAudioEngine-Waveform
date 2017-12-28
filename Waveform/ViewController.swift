//
//  ViewController.swift
//  Waveform
//
//  Created by Syed Haris Ali on 12/28/17.
//  Copyright © 2017 Ausome Apps LLC. All rights reserved.
//

import UIKit
import AVFoundation
import os.log

class ViewController: UIViewController {

    static let logger = OSLog(subsystem: "com.ausomeapps", category: "ViewController")
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var plot: EZAudioPlot! {
        willSet {
            newValue.plotType = .rolling
            newValue.color = UIColor.blue
            newValue.shouldMirror = true
            newValue.shouldFill = true
        }
    }
    
    override func viewDidLoad() {
        os_log("%@ - %d", log: ViewController.logger, type: .default, #function, #line)
        
        /// Setup session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            try session.setActive(true)
        } catch {
            os_log("Failed to activate audio session: %@", log: ViewController.logger, type: .default, #function, #line, error.localizedDescription)
        }
        
        /// Start player
        let player = Player.shared
        player.delegate = self
        
        if let url = Bundle.main.url(forResource: "eve", withExtension: "mp3") {
            player.loadFile(with: url)
        } else {
            os_log("Could not load url", log: ViewController.logger, type: .default, #function, #line)
        }

    }

    @IBAction func play(_ sender: Any) {
        let player = Player.shared
        let isPlaying = player.isPlaying
        os_log("%@ - %d [isPlaying: %@]", log: ViewController.logger, type: .default, #function, #line, String(describing: isPlaying))

        /// Toggle playback state
        player.isPlaying ? player.pause() : player.play()
    }
    
}

