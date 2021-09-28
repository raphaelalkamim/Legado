//
//  AlbumCollectionViewCell.swift
//  olds
//
//  Created by Caroline Taus on 20/09/21.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumCover: UIImageView!
    var elements = [UIAccessibilityElement]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    //Determinando elementos como de acessibilidade
    albumTitle.isAccessibilityElement = true
    albumCover.isAccessibilityElement = true
        
    //o que o voice over fala
    albumCover.accessibilityLabel = "álbum"
         
        
        }
    }

