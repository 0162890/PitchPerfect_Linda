//
//  RecordSoundsViewController.swift
//  PitchPerfect_Linda
//
//  Created by 하연 on 2017. 1. 10..
//  Copyright © 2017년 hayeon. All rights reserved.
//

import UIKit

class RecordSoundsViewController: UIViewController {

    @IBOutlet weak var btnRecording: UIButton!
    @IBOutlet weak var btnStopRecording: UIButton!
    @IBOutlet weak var lblRecording: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnStopRecording.isHidden = true
        lblRecording.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func recordAudio(_ sender: Any) {
        btnRecording.isEnabled = true
        btnStopRecording.isHidden = false
        lblRecording.text = "Recording..."
        lblRecording.isHidden = false

    }
    @IBAction func stopRecording(_ sender: Any) {
        btnRecording.isEnabled = true
        btnStopRecording.isEnabled = false
        lblRecording.text = "Recording is stopped"
        performSegue(withIdentifier: "RecordToPlaySegue", sender: sender)

    }
}

