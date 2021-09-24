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
    

    
    @IBOutlet weak var otherLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var travelLabel: UILabel!
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var personImageButton: UIButton!
    @IBOutlet weak var otherImageButton: UIButton!
    @IBOutlet weak var eventImageButton: UIButton!
    @IBOutlet weak var travelImageButton: UIButton!
    var debs: Int = 90

    
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
        typeName = "event"
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleTextField.becomeFirstResponder() //
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        typeName = "person"
        personImageButton.setImage(UIImage(named: "blueAlbumNotSel"), for: .normal)
        eventImageButton.setImage(UIImage(named: "greenAlbumNotSel"), for: .normal)
        travelImageButton.setImage(UIImage(named: "brownAlbumNotSel"), for: .normal)
        otherImageButton.setImage(UIImage(named: "redAlbumNotSel"), for: .normal)
        
        personImageButton.isSelected = true
        titleTextField.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let album = self.album{
            title = album.albumTitle
            let button: String? = album.albumType
            if button == "person"{
                personImageButton.isSelected = true
                travelImageButton.isSelected = false
                eventImageButton.isSelected = false
                otherImageButton.isSelected = false
                
            }
            else if button == "travel"{
                personImageButton.isSelected = false
                travelImageButton.isSelected = true
                eventImageButton.isSelected = false
                otherImageButton.isSelected = false
                
            }
            else if button == "event"{
                personImageButton.isSelected = false
                travelImageButton.isSelected = false
                eventImageButton.isSelected = true
                otherImageButton.isSelected = false
                
            }
            else{
                personImageButton.isSelected = false
                travelImageButton.isSelected = false
                eventImageButton.isSelected = false
                otherImageButton.isSelected = true
                
            }
        }
        
        
    }
    
    // criar album
    @IBAction func teste(_ sender: Any) {
        if let album = self.album {
            _ = album
        }
        else{
            album = try? CoreDataAlbum.createAlbum(title: "", type: "")
        }
        album?.albumTitle = titleTextField.text!
        album?.albumType = typeName!
        print(album)
        
        try? CoreDataAlbum.saveContext()
        delegate?.didRegister()
        
        
        
        if let vc = storyboard?.instantiateViewController(identifier: "CoverView") as? AlbumViewController{
            vc.changeAlbum(album: album)
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    // alerta de cancelar
    @IBAction func cancelCreation(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Cancelar Álbum", message: "Todas suas mudanças serão perdidas.\nTem certeza que deseja cancelar?", preferredStyle: .alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Sim", style: .destructive, handler: { [self] action in
            navigationController?.popViewController(animated: true)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    
    
 
    
    
    func changeAlbum(album: Album?) {
        self.album = album
    }
    

}
