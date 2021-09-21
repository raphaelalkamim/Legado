//
//  NewAlbumViewController.swift
//  olds
//
//  Created by Raphael Alkamim on 16/09/21.
//

import UIKit

protocol NewAlbumViewControllerDelegate: AnyObject { // protocolo para atualizar a pagina se houver edições
    func didRegister()
}

class NewAlbumViewController: UIViewController, UITextFieldDelegate {
    private var album: Album?
    weak var delegate: NewAlbumViewControllerDelegate?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var personImageButton: UIButton!
    @IBOutlet weak var otherImageButton: UIButton!
    @IBOutlet weak var eventImageButton: UIButton!
    @IBOutlet weak var travelImageButton: UIButton!
    @IBOutlet weak var createButton: UIBarButtonItem!
    var typeName: String?
    
    
    @IBAction func didSelectPerson(_ sender: Any) {
        typeName = "person"
        personImageButton.isSelected = true
        travelImageButton.isSelected = false
        eventImageButton.isSelected = false
        otherImageButton.isSelected = false
    }
    
    @IBAction func didSelectTravel(_ sender: Any) {
        typeName = "travel"
        personImageButton.isSelected = false
        travelImageButton.isSelected = true
        eventImageButton.isSelected = false
        otherImageButton.isSelected = false
    }
    
    @IBAction func didSelectEvent(_ sender: Any) {
        typeName = "even"
        personImageButton.isSelected = false
        travelImageButton.isSelected = false
        eventImageButton.isSelected = true
        otherImageButton.isSelected = false
    }
    
    @IBAction func didSelectOther(_ sender: Any) {
        typeName = "other"
        personImageButton.isSelected = false
        travelImageButton.isSelected = false
        eventImageButton.isSelected = false
        otherImageButton.isSelected = true
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        
        personImageButton.setImage(UIImage(named: "blueAlbumNotSel"), for: .normal)
        eventImageButton.setImage(UIImage(named: "greenAlbumNotSel"), for: .normal)
        travelImageButton.setImage(UIImage(named: "brownAlbumNotSel"), for: .normal)
        otherImageButton.setImage(UIImage(named: "redAlbumNotSel"), for: .normal)
        
        personImageButton.isSelected = true
        
        
    }
    

    @IBAction func createAlbum(_ sender: Any) {
        if let album = self.album {
            _ = album
        }
        else{
            album = try? CoreDataAlbum.createAlbum(title: "", type: "")
        }
        album?.albumTitle = titleTextField.text!
        
        
        album?.albumType = typeName!
        
        try? CoreDataAlbum.saveContext()
        delegate?.didRegister()
    }
    
    
    
    enum coverType: String {
    
        case person = "blueAlbum"
        case travel = "brownAlbum"
        case event = "greenAlbum"
        case other = "redAlbum"
        
        
    }
    

}
