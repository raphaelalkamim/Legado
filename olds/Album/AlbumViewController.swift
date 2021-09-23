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
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var newPageButton: UIButton!
    @IBOutlet weak var nextPageButton: UILabel!
    
    func changeAlbum(album: Album?) {
        self.album = album
    }
    
    @IBAction func actNextPage(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "pageView") as? PageViewController {
            vc.changeAlbum(album: album)
            vc.page = album?.pages?.allObjects[0] as? Page
            vc.pageIndex = 0
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    @IBOutlet weak var backToAlbumsButton: UIBarButtonItem!
    
    
    @IBAction func goBackToAlbums(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editButton.setTitle("Editar Álbum", for: .normal)
        editButton.setTitleColor(.darkGray, for: .normal)
        
        title = album?.albumTitle //settando titulo do album
        albumCover.contentMode = .scaleAspectFit
        changeCover()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = album?.albumTitle
        albumCover.contentMode = .scaleAspectFit
        changeCover()
    }
    
    
    func changeCover() {
        let coverName: String? = String?((album?.albumType)!)
        if (coverName == "person") {
            albumCover.image = UIImage(named: "blueAlbum")
        }
        else if (coverName == "travel") {
            albumCover.image = UIImage(named: "brownAlbum")
        }
        else if (coverName == "event") {
            albumCover.image = UIImage(named: "greenAlbum")
        }
        else {
            albumCover.image = UIImage(named: "redAlbum")
        }
    }
    
   
    
    @IBAction func edit(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "EditView") as? NewAlbumViewController {
            vc.changeAlbum(album: album)
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is NewPageViewController {
            let vc = segue.destination as? NewPageViewController
            vc?.album = album
        }
    }
}
