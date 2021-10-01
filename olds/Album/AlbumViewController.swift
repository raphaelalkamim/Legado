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
    
    @IBOutlet weak var openBookButton: UIView!
    @IBOutlet weak var openBookLabel: UIView!
    
    //MARK: Outlets e variáveis
    var album: Album?
    var page: Page?
    weak var delegate: NewAlbumViewControllerDelegate?
    @IBOutlet weak var albunsButton: UIBarButtonItem!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var newPageButton: UIButton!
    @IBOutlet weak var backToAlbumsButton: UIBarButtonItem!
    
    func changeAlbum(album: Album?) {
        self.album = album
    }
    
    
    
    
    
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
        
        //Determinando os elementos como de acessibilidade
        editButton.isAccessibilityElement = true
        albumCover.isAccessibilityElement = true
//        newPageButton.isAccessibilityElement = true
        backToAlbumsButton.isAccessibilityElement = true
        albunsButton.isAccessibilityElement = true
        
        //O que o voice over fala
        editButton.accessibilityLabel = "Editar álbum"
        albumCover.accessibilityLabel = "Álbum"
        
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
            albumCover.accessibilityValue = "Pessoas"
        }
        else if (coverName == "travel") {
            albumCover.image = UIImage(named: "brownAlbum")
            albumCover.accessibilityValue = "Viagens"
        }
        else if (coverName == "event") {
            albumCover.image = UIImage(named: "greenAlbum")
            albumCover.accessibilityValue = "Eventos"
        }
        else {
            albumCover.image = UIImage(named: "redAlbum")
            albumCover.accessibilityValue = "Outros"
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
        else if segue.destination is PageViewController {
            let vc = segue.destination as? PageViewController
            vc?.album = album
        }
    }
}
