//
//  NewAlbumViewController.swift
//  olds
//
//  Created by Raphael Alkamim on 16/09/21.
//

import UIKit

class NewAlbumViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var personImageButton: UIButton!
    @IBOutlet weak var otherImageButton: UIButton!
    @IBOutlet weak var eventImageButton: UIButton!
    @IBOutlet weak var travelImageButton: UIButton!
    @IBOutlet weak var createButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        
        

    
    }
    

    @IBAction func createAlbum(_ sender: Any) {
        if let 
    }
    

}
