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
    
    var pauseBtnFlag : Bool = false
    
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

    @IBAction func pauseAndResume(_ sender: Any) {
        if pauseBtnFlag == false{
            audioPlayerNode.pause()
            //pause timer
            progressTimer.invalidate()
//            if let stopTimer = stopTimer {
//                stopTimer.invalidate()
//            }
            
            setPauseButton(imageName: "Resume")
            


            
        } else{
          
            //timer resume
            startProgressViewTimer()
   //         startStopTimer()
            
            audioPlayerNode.play()
            print("resumeeeeeeeee")
            
            setPauseButton(imageName: "Pause")
            

        }
        

    }
    
    func setPauseButton(imageName : String){
        if imageName == "Pause"{
            let image = UIImage(named: imageName) as UIImage!
            pauseButton.setImage(image, for: UIControlState.normal)
            pauseBtnFlag = false
        } else if imageName == "Resume" {
            let image = UIImage(named: imageName) as UIImage!
            pauseButton.setImage(image, for: UIControlState.normal)
            pauseBtnFlag = true
        }
    }
  
    
    @IBAction func stopPlaySound(_ sender: AnyObject) {
        stopAudio()
        //for progress view : stop timer
        progressTimer.invalidate()
        progressView.progress = 0.0
        setPauseButton(imageName: "Pause")


    }
    
    //for progress view : 
    func startProgressViewTimer(){
        //for progress view : Run updateProgressViewTime function with time interval.
        progressTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(PlaySoundsViewController.updateProgressViewTime), userInfo: nil, repeats: true)
        progressTimer.fire()
    }
    
    //for progress view : update progress view count
    func updateProgressViewTime(){
        calCurrentTime()
        print("currentTime : \(currentTime)")
        print("totalTime : \(totalTime)")
        progressCount = currentTime / totalTime
        print("ProgressCount : \(progressCount)")
        progressView.progress = progressCount

    }
  
    //for progress view : calculate currentTime
    func calCurrentTime(){
        if let lastRenderTime = audioPlayerNode.lastRenderTime, let playerTime = audioPlayerNode.playerTime(forNodeTime: lastRenderTime){
                currentTime = Float(Double(playerTime.sampleTime) / playerTime.sampleRate)
                //print("currentTime in function:  \(currentTime)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        //for progress view 
        totalTime = Float(Float(audioFile.length) / Float(audioFile.fileFormat.sampleRate))
//        print("totalTime : \(totalTime)")
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
