//
//  TimelineCollectionViewCell.swift
//  olds
//
//  Created by Caroline Taus on 05/10/21.
//

import UIKit
import AVFoundation

class TimelineCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabelCell: UILabel!
    
    @IBOutlet weak var imgCell: UIImageView!
    
    @IBOutlet weak var playButtonCell: UIButton!
    
    @IBOutlet weak var playLabel: UILabel!
    var audio: AVAudioPlayer?
    
    @IBAction func playButtonActionCell(_ sender: Any) {
        audio?.play()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgCell.image = nil
    }
    
    func playAudio(url: URL) {
        
        do {
            audio = try AVAudioPlayer(contentsOf: url)
            
        } catch {
            
        }
    }
}
