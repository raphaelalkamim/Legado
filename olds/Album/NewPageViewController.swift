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
    
    
    
    @IBAction func savePage(_ sender: Any) {
        if let newPage = self.page{
            print("to aqui")
           // _ = page
        }
        else {
            print("entrei no else ")
            
            page = try? CoreDataPage.createPage(album: album, date: Date(), photo: "", audio: "")
            
        }
        page?.pageDate = date
        page?.pagePhoto = "fotoooo"
        page?.pageAudio = "audio"
        
        
        try? CoreDataPage.saveContext()
        print(page?.pageDate)
        print(page?.pagePhoto)
        print(page?.pageAudio)
        print(page)
        //navigationController?.popViewController(animated: true)
    }
    
    func convertDate(date: Date) -> String {
        self.date = date
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.full
        let stringDate = formatter.string(from: date)
        return stringDate
    }
    
    @IBAction func cancel(_ sender: Any) {
    }
    @IBOutlet weak var datePicker: UIDatePicker?
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var newPhotoButton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
    
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
    
    var dateInput: String = ""
    var date: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       

        
    }
    

    

}
