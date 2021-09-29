//
//  PageViewCollectionViewCell.swift
//  olds
//
//  Created by Raphael Alkamim on 27/09/21.
//

import UIKit
import AVFoundation

class PageViewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleCell: UILabel!
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var playButtonCell: UIButton!
    var audio: AVAudioPlayer?
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgCell.image = nil
    }
    
    @IBAction func playButtonCellAction(_ sender: Any) {
        
        audio?.play()
    }
    
    
    func playAudio(url: URL) {
        
        do {
            audio = try AVAudioPlayer(contentsOf: url)
            
        } catch {
            
        }
    }
    
}
