//
//  AudioVC.swift
//  Spot
//
//  Created by Neel Patel on 08/11/16.
//  Copyright © 2016 Neel Patel. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class AudioVC: UIViewController {
    
    
    @IBOutlet weak var pauseplay: UIButton!
    
    var Image = UIImage()
    var songTitle = String()
    var mainpreviewURL = String()
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var main: UIImageView!
    
    @IBOutlet weak var text: UILabel!
    
    override func viewDidLoad() {
        
        
        background.image = Image
        
        main.image = Image
        
        text.text = songTitle
        
        downloadFilefromURL(url: URL(string: mainpreviewURL)!)
        
        pauseplay.setTitle("Pause", for: .normal)
        
    }
    
    func downloadFilefromURL(url: URL){
        
        var downloadTask = URLSessionDownloadTask()
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: {
            
            customURL, response, error in
            
                self.play(url: customURL!)
        })
        
        downloadTask.resume()
        
    }
    
    func play(url: URL){
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
        
        }
        catch
        {
            print(error)
        }
    
    }
    @IBAction func playpause(_ sender: Any) {
        
        if player.isPlaying{
            player.pause()
            pauseplay.setTitle("Play", for: .normal)
        }else{
            
            player.play()
            
            pauseplay.setTitle("Pause", for: .normal)
            
        }
    }
}
