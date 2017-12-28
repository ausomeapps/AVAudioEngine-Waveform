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
        if let url = Bundle.main.url(forResource: "eve", withExtension: "mp3") {
            player.loadFile(with: url)
        } else {
            os_log("Could not load url", log: ViewController.logger, type: .default, #function, #line)
        }

    }

    @IBAction func play(_ sender: Any) {
        os_log("%@ - %d [isPlaying: %@]", log: ViewController.logger, type: .default, #function, #line, String(describing: Player.shared.isPlaying))
        
        
        let player = Player.shared
        
        if player.isPlaying {
            
            player.pause()
            
            playButton.setTitle("Play", for: .normal)
            
        } else {
            
            player.play()
            
            playButton.setTitle("Pause", for: .normal)
            
        }
    }
    
}

