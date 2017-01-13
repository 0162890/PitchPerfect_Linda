//
//  PlaySoundsViewController.swift
//  PitchPerfect_Linda
//
//  Created by 하연 on 2017. 1. 11..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import AVFoundation
import UIKit

class PlaySoundsViewController: UIViewController {
    
    
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var highPitchButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var lowPitchButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var pauseButton: UIButton!
    
    
    var recordedAudioURL : URL!
    var audioFile : AVAudioFile!
    var audioEngine : AVAudioEngine!
    var audioPlayerNode : AVAudioPlayerNode!
    var stopTimer : Timer!
    
    //for progress view
    var progressCount : Float = 0.0
    var totalTime : Float = 0.0
    var currentTime : Float = 0.0
    var progressTimer : Timer!
    
    var nowPlaying : Bool = true
    
    enum ButtonType: Int {
        case slow = 0, fast, highPitch, lowPitch, echo, reverb
    }
    
    @IBAction func playSoundForButton(_ sender: UIButton){
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .highPitch:
            playSound(pitch: 1000)
        case .lowPitch:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        
        configureUI(.playing)
        
        startProgressViewTimer()
        setPauseButton(imageName: "Pause")
    }

    //Pause and Resume Action
    @IBAction func pauseAndResume(_ sender: Any) {
        if nowPlaying {
            audioPlayerNode.pause()
            setPauseButton(imageName: "Resume")
            
            //pause progressTimer
            progressTimer.invalidate()
        
        } else{
            audioPlayerNode.play()
            setPauseButton(imageName: "Pause")
            
            //resume progressTimer
            startProgressViewTimer()
        }
    }

    @IBAction func stopPlaySound(_ sender: AnyObject) {
        stopAudio()
        setPauseButton(imageName: "Pause")
        
        //for progress view : stop progress view
        progressTimer.invalidate()
        progressView.progress = 0.0
    }
    
    //Change nowPlaying flag and button image
    func setPauseButton(imageName : String){
        if imageName == "Pause"{
            let image = UIImage(named: imageName) as UIImage!
            pauseButton.setImage(image, for: UIControlState.normal)
            nowPlaying = true
        } else if imageName == "Resume" {
            let image = UIImage(named: imageName) as UIImage!
            pauseButton.setImage(image, for: UIControlState.normal)
            nowPlaying = false
        }
    }
    
    //for progress view : Run updateProgressViewTime function with time interval.
    func startProgressViewTimer(){
        progressTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(PlaySoundsViewController.updateProgressViewTime), userInfo: nil, repeats: true)
        progressTimer.fire()
    }
    
    //for progress view : update progressCount
    func updateProgressViewTime(){
        calCurrentTime()
        progressCount = currentTime / totalTime
        progressView.progress = progressCount
    }
  
    //for progress view : calculate currentTime
    func calCurrentTime(){
        if let lastRenderTime = audioPlayerNode.lastRenderTime, let playerTime = audioPlayerNode.playerTime(forNodeTime: lastRenderTime){
                currentTime = Float(Double(playerTime.sampleTime) / playerTime.sampleRate)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        //for progress view 
        totalTime = Float(Float(audioFile.length) / Float(audioFile.fileFormat.sampleRate))
        progressView.progress = progressCount
        
        //change the progress view width
        let transform : CGAffineTransform = CGAffineTransform(scaleX: 0.6, y: 1.0)
        progressView.transform = transform
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }



}
