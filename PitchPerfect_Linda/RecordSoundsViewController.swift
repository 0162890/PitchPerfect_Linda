//
//  RecordSoundsViewController.swift
//  PitchPerfect_Linda
//
//  Created by 하연 on 2017. 1. 10..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import AVFoundation
import UIKit

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var btnRecording: UIButton!
    @IBOutlet weak var btnStopRecording: UIButton!
    @IBOutlet weak var lblRecording: UILabel!
    
    var audioRecorder : AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        btnStopRecording.isHidden = true
//        lblRecording.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnStopRecording.isHidden = true
        lblRecording.isHidden = true
    }

    @IBAction func recordAudio(_ sender: Any) {
        btnRecording.isEnabled = false
        btnStopRecording.isHidden = false
        btnStopRecording.isEnabled = true
        lblRecording.text = "Recording..."
        lblRecording.isHidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

    }
    @IBAction func stopRecording(_ sender: Any) {
        btnRecording.isEnabled = true
        btnStopRecording.isEnabled = false
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)

    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
             performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)

        } else{
            print("Recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

