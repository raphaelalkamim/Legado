//
//  NewPageViewController.swift
//  olds
//
//  Created by Raphael Alkamim on 16/09/21.
//

import UIKit
import AVFoundation


protocol NewPageViewControllerDelegate: AnyObject {
    func didRegisterPage()
}

class NewPageViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    
    var album: Album!
    var dateInput: String = ""
    var date: Date?
    var pages: [Page] = []
    var imagePicker: ImagePicker!
    var imageURL: String?
    
    weak var delegate: NewPageViewControllerDelegate?
    
    
    @IBOutlet weak var datePicker: UIDatePicker?
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var newPhotoButton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    
    }
    
    
    @IBAction func showImagePicker(_ sender: Any) {
        self.imagePicker.present(from: sender as! UIView)
    }
    
    
    @IBAction func pageSave(_ sender: Any) {
        let page = try! CoreDataPage.createPage(album: album, date: Date(), photo: "", audio: "")
        
        if date != nil {
            page.pageDate = date
        }
        
        if imageURL !=  nil {
            page.pagePhoto = imageURL
        }
        
        pages.append(page)
        
        try? CoreDataPage.saveContext()
        print(page)
        
        
        if let didRegister = delegate {
            didRegister.didRegisterPage()
        }
        
        
        
        if let vc = storyboard?.instantiateViewController(identifier: "pageView") as? PageViewController {
            vc.changeAlbum(album: album)
            
            
            self.dismiss(animated: true, completion: nil)
        }
        
        
        delegate?.didRegisterPage()
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
    @IBAction func recordAction(_ sender: Any) {
        if audioRecorder == nil {
            let fileName = getDirectory().appendingPathComponent("audio\(UUID().uuidString).m4a")
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            //start audio recording
            do {
                audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
                
                recordAudioButton.setTitle("Parar de gravar", for: .normal)
            } catch {
                displayAlert(title: "Não funcionou", message: "Falha em gravar")
            }
        }
        else {
            // Stopping audio recordig
            audioRecorder.stop()
            audioRecorder = nil
            
            UserDefaults.standard.bool(forKey: "Save")
            
            recordAudioButton.setTitle("Comerçar a Gravar", for: .normal)
        }
    }
    
    
    // Function that gets path to directory
    
    func getDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    //Function that displays an alert
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    @IBAction func replayAction(_ sender: Any) {
        let path = getDirectory().appendingPathComponent("audio\(UUID().uuidString).m4a")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer.play()
        } catch {
            displayAlert(title: "Não funcionou", message: "Falha em reproduzir")
        }

    }
    
}

extension NewPageViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.imgPhoto.image = image
        let newImage: UIImage = imgPhoto.image!
        imageURL = FileHelper.saveToFiles(image: newImage)
    }
}


