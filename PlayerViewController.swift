//
//  PlayerViewController.swift
//  HGC Internal
//
//  Created by user161027 on 11/28/19.
//  Copyright © 2019 Jay Sastry. All rights reserved.
//

import AVFoundation
import UIKit
import AVKit

// Fried Chicken Yummy

class PlayerViewController: UIViewController {
    static var buttoned: Bool!
    var audioPlayer: AVAudioPlayer!
    
    func playTrack(url: String) -> Void {
        
    }

    // create variable song of type subwork to hold the information passed from the PLoadingView controller about a given song
    var song: subwork!
    
    // create UILabels to contain information about the title, year of performance, and the artist
    @IBOutlet var titleVar: UILabel!
    @IBOutlet var yearVar: UILabel!
    @IBOutlet var artistAlbumVar: UILabel!
    
    // Jay Funny Yummy Funny

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set the title and year UILabels as the song's title and year
        titleVar.text = song.stitle
        yearVar.text = String(song.year.prefix(4))
        var album = ""
        var artist = ""
        
        // if the song has an album and artist, set it as the UILabel
        if song.album != nil {
            album = String(song.album)
        }

        if song.artist != nil {
            artist = String(song.artist)
        }

        artistAlbumVar.text = "\(artist)\n\n\(album)"
        
    }
    

    @IBAction func playMusic(_ sender: AnyObject) {
        
        // launch Harvard Glee Club Internal website upon clicking the play button
        
        if PlayerViewController.buttoned == nil {
            PlayerViewController.buttoned = false
        }
                
        if PlayerViewController.buttoned! == true {
            print(song.nodeurl)
            let url = URL(string: "\(String(song.downloadurl))")
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
        
        else if let url = URL(string: "https://internal.harvardgleeclub.org/"), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            PlayerViewController.buttoned = true
        }
                
    }
}
    
