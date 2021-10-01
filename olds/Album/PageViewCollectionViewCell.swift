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
    @IBOutlet weak var playLabel: UIView!
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var playButtonCell: UIButton!
    var audio: AVAudioPlayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    //Determinando elementos como de acessibilidade
//        titleCell.isAccessibilityElement = true
//        playLabel.isAccessibilityElement = true
//        imgCell.isAccessibilityElement = true
//        playButtonCell.isAccessibilityElement = true
        
        //o que o voice over fala
        playButtonCell.accessibilityLabel = "Reproduzir áudio"
        imgCell.accessibilityLabel = "Foto"
        

    }
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
