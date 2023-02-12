
//
//  MusicPlayer.swift
//
//  Created by Tarandeep Mandhiratta

import Foundation
import AVFoundation

class MusicPlayer{
    var player:AVAudioPlayer?
    var musicStatus:Bool?
    
    func collision(){
        let soundURL = Bundle.main.url(forResource: "crash", withExtension: "mp3")
        do{
            try player = AVAudioPlayer(contentsOf: soundURL!)
            
        }
        catch{
            print(error)
        }
        player?.play()
        print("shipcrashed sound played")
    }
    
    func HitTarget(){
        let soundURL = Bundle.main.url(forResource: "enemyHit", withExtension: "caf")
        do{
            try player = AVAudioPlayer(contentsOf: soundURL!)
           
        }
        catch{
            print(error)
        }
        player?.play()
        print("HitTarget sound played")
        if musicStatus == true {
            playMusic()
        }else{
            stopMusic()
        }
        
    }

    func playMusic(){
        musicStatus = true
        let soundURL = Bundle.main.url(forResource: "backgroundMusic", withExtension: "caf")
   
    do{
        try player = AVAudioPlayer(contentsOf: soundURL!)
        print("music is ON")
        
    } catch
    {
        print(error)
    }
    player?.play()
    player?.numberOfLoops = -1
    }
    
    func stopMusic(){
        musicStatus = false
        if player?.isPlaying == true {
            player?.stop()
            print("music is OFF")
        }
    }
    
}
