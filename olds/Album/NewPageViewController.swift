//
//  NewPageViewController.swift
//  olds
//
//  Created by Raphael Alkamim on 16/09/21.
//

import UIKit

class NewPageViewController: UIViewController {
    
    private var page: Page?
    var album: Album!
    var dateInput: String = ""
    var date: Date?
    
    
    @IBOutlet weak var datePicker: UIDatePicker?
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var newPhotoButton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       

        
    }
    
    @IBAction func pageSave(_ sender: Any) {
        if let page = self.page{

            _ = page
        }
        else {

            
            page = try? CoreDataPage.createPage(album: album, date: Date(), photo: "", audio: "")
            
        }
        page?.pageDate = date
        page?.pagePhoto = "fotoooo"
        page?.pageAudio = "audio"

        try? CoreDataPage.saveContext()

        
        if let vc = storyboard?.instantiateViewController(identifier: "pageView") as? PageViewController {
            vc.changeAlbum(album: album)
            self.dismiss(animated: true, completion: nil)
            
            
        }
    }
    


    
    func convertDate(date: Date) -> String {
        self.date = date
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.full
        let stringDate = formatter.string(from: date)
        return stringDate
    }
    

   
    
    @IBAction func newPhoto(_ sender: Any) {
    }
    
    @IBAction func newAudio(_ sender: Any) {
    }
    
    
   
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.full
        let stringDate = formatter.string(from: datePicker!.date)
        date = datePicker!.date
        dateInput = stringDate
        print(date)
        print(dateInput)
    }
    
    
    @IBAction func creationCancel(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Cancelar Página", message: "Todas suas mudanças serão perdidas.\nTem certeza que deseja cancelar?", preferredStyle: .alert)

        refreshAlert.addAction(UIAlertAction(title: "Sim", style: .destructive, handler: { [self] action in
            self.dismiss(animated: true, completion: nil)
        }))

        refreshAlert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))

        present(refreshAlert, animated: true, completion: nil)

    }
  
}
    
