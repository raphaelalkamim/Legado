//
//  ViewController.swift
//  olds
//
//  Created by Raphael Alkamim on 15/09/21.
//

import UIKit

// MARK: DID REGISTER - PROTOCOLO
protocol AlbumViewControllerDelegate: AnyObject { // protocolo para atualizar a pagina se houver edições
    func didRegister()
}

class AlbumViewController: UIViewController {
    
    //MARK: Outlets e variáveis
    @IBOutlet weak var openBookLabel: UILabel!
    @IBOutlet weak var openBookButton: UIButton!
    var elements = [UIAccessibilityElement]()
    var album: Album?
    var page: Page?
    weak var delegate: NewAlbumViewControllerDelegate?
    @IBOutlet weak var albunsButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var backToAlbumsButton: UIBarButtonItem!
    
    
    
    //MARK: VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = album?.albumTitle //settando titulo do album
        albumCover.contentMode = .scaleAspectFit
        changeCover()
        
        //Determinando os elementos como de acessibilidade
        editButton.isAccessibilityElement = true
        albumCover.isAccessibilityElement = true
//        newPageButton.isAccessibilityElement = true
        backToAlbumsButton.isAccessibilityElement = true
        albunsButton.isAccessibilityElement = true
        openBookLabel.isAccessibilityElement = true
        openBookButton.isAccessibilityElement = true
        
        //O que o voice over fala
        editButton.accessibilityLabel = "Editar álbum"
        albumCover.accessibilityLabel = "Álbum"
        openBookLabel.accessibilityLabel = " "
        openBookButton.accessibilityLabel = "Abrir Album"
        
        
        let groupedElement = UIAccessibilityElement(accessibilityContainer: self)
        groupedElement.accessibilityLabel = "\(openBookButton.self!), \(openBookLabel.text!)"
        groupedElement.accessibilityFrameInContainerSpace = openBookButton.frame.union(openBookLabel.frame)
        elements.append(groupedElement)
    }
    
    //MARK: VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        title = album?.albumTitle
        albumCover.contentMode = .scaleAspectFit
        changeCover()
    }
    
    //MARK: BAR BUTTON ITEM - BACK TO ALBUMS
    @IBAction func goBackToAlbums(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: BAR BUTTON ITEM - EDIT
    @IBAction func edit(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "EditView") as? NewAlbumViewController {
            vc.changeAlbum(album: album)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: CHANGE ALBUM
    func changeAlbum(album: Album?) {
        self.album = album
    }
    
    
    //MARK: CHANGE COVER
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
    
    
    //MARK: PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PageViewController {
            let vc = segue.destination as? PageViewController
            vc?.album = album
        }
    }
    
}
