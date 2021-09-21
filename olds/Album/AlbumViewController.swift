//
//  ViewController.swift
//  olds
//
//  Created by Raphael Alkamim on 15/09/21.
//

import UIKit

protocol AlbumViewControllerDelegate: AnyObject { // protocolo para atualizar a pagina se houver edições
    func didRegister()
}

class AlbumViewController: UIViewController {
    var album: Album?
    weak var delegate: NewAlbumViewControllerDelegate?
    @IBOutlet weak var albunsButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var newPageButton: UIButton!
    @IBOutlet weak var nextPageButton: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = album?.albumTitle //settando titulo do album
        albumCover.contentMode = .scaleAspectFit
        
        
        
        
    }


}

