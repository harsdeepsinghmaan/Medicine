//
//  ViewController.swift
//  M3DICINE
//
//  Created by IOS on 13/9/21.
//

import UIKit
import AVFoundation
import FDWaveformView


class ViewController: UIViewController {
    
    var audioPlayer = AVAudioPlayer()
    var totalLengthOfAudio = ""

    @IBOutlet weak var waveFormOutlet: FDWaveformView!
    @IBOutlet weak var playPauseButtonOutlet: UIButton!
    @IBOutlet weak var totalLengthOfAudioLabelOutlet: UILabel!
    @IBOutlet weak var progressTimerLabelOutlet: UILabel!
    @IBOutlet weak var progressViewOutlet: UIProgressView!
    
    /// Handles Play/Pause button.
      @IBAction func playPauseButton(_ sender: Any) {
        
        if (audioPlayer.isPlaying == true) {
            audioPlayer.stop()
            playPauseButtonOutlet.setTitle("Play", for: .normal)
            } else {
            audioPlayer.play()
            playPauseButtonOutlet.setTitle("Pause", for: .normal)
            }
    }
    
    override func viewDidLoad() {
             super.viewDidLoad()
             // Do any additional setup after loading the view.
             intiAudioPlayer()
             showTotalSongLength()
    }
    
        func intiAudioPlayer() {
            guard let url = Bundle.main.url(forResource: "audioFile", withExtension: "wav") else { return }

            do {
                /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
                audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
                showTotalSongLength()
                audioPlayer.prepareToPlay()
                
                // Show Waveform of Audio file 
                waveFormOutlet.audioURL = url

                /* iOS 10 and earlier require the following line:
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
                
                Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
                progressViewOutlet.setProgress(Float(audioPlayer.currentTime/audioPlayer.duration), animated: false)
          
            } catch let error {
                print(error.localizedDescription)
            }
        }
    
        @objc func updateAudioProgressView()
           {
            if (audioPlayer.isPlaying == true){
               // Update progress
                progressViewOutlet.setProgress(Float(audioPlayer.currentTime/audioPlayer.duration), animated: true)
                let time = calculateTimeFromNSTimeInterval(audioPlayer.currentTime)
                progressTimerLabelOutlet.text  = "\(time.minute):\(time.second)"
                    }
                }
    
            func showTotalSongLength(){
                calculateSongLength()
                totalLengthOfAudioLabelOutlet.text = totalLengthOfAudio
            }
            func calculateSongLength(){
                let time = calculateTimeFromNSTimeInterval(audioPlayer.duration)
                totalLengthOfAudio = "\(time.minute):\(time.second)"
            }
    //This returns song length
            func calculateTimeFromNSTimeInterval(_ duration:TimeInterval) ->(minute:String, second:String){
               // let hour_   = abs(Int(duration)/3600)
                let minute_ = abs(Int((duration/60).truncatingRemainder(dividingBy: 60)))
                let second_ = abs(Int(duration.truncatingRemainder(dividingBy: 60)))
                
               // var hour = hour_ > 9 ? "\(hour_)" : "0\(hour_)"
                let minute = minute_ > 9 ? "\(minute_)" : "0\(minute_)"
                let second = second_ > 9 ? "\(second_)" : "0\(second_)"
                return (minute,second)
            }
        }
