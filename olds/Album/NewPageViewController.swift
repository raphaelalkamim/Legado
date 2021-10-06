//
//  NewPageViewController.swift
//  olds
//
//  Created by Raphael Alkamim on 16/09/21.
//

import UIKit
import AVFoundation
import Photos


protocol NewPageViewControllerDelegate: AnyObject {
    func didRegisterPage()
}

class NewPageViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    weak var delegate: NewPageViewControllerDelegate?
    var album: Album!
    var dateInput: String = ""
    var date: Date?
    var pages: [Page] = []
    var imagePicker: ImagePicker!
    var imageURL: String?
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker?
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var newPhotoButton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
    
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var playLabel: UILabel!
    
    var audioURL: String!
    
    
    // MARK: VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        checkMicrophoneAccess() // chama permissão pra usar o mic
        checkPermissions()
        // MARK: IMAGE PICKER
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        audioRecorderFunc()
        
        //Determinando elementos como de acessibilidade
        //        playButton.isAccessibilityElement = true
        //        stopButton.isAccessibilityElement = true
        //        datePicker?.isAccessibilityElement = true
        //        imgPhoto.isAccessibilityElement = true
        //        newPhotoButton.isAccessibilityElement = true
        //        recordAudioButton.isAccessibilityElement = true
        //        recordAudioLabel.isAccessibilityElement = true
        //        playAudioLabel.isAccessibilityElement = true
        //        stopAudioLabel.isAccessibilityElement = true
        
        
        //o que o voice over fala
        playButton.accessibilityLabel = "Reproduzir audio"
        recordAudioButton.accessibilityLabel = "Gravar audio"
        
    }
    
    // MARK: AUDIO RECORD
    func audioRecorderFunc() {
        //Set arquivo do audio para armazenar no coreData
        let audioFileName = UUID().uuidString + ".m4a"
        let audioFileURL = getDirectory().appendingPathComponent(audioFileName)
        audioURL = audioFileName
        
        
        //sessão de audio
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category(rawValue: AVAudioSession.Category.playAndRecord.rawValue), mode: .default)
        } catch _ {
        }
        
        // Define the recorder setting
        let recorderSetting = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
        
        audioRecorder = try? AVAudioRecorder(url: audioFileURL, settings: recorderSetting)
        audioRecorder?.delegate = self
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.prepareToRecord()
    }
    
    
    
    
    // MARK: SHOW IMAGE PICKER
    @IBAction func showImagePicker(_ sender: Any) {
        self.imagePicker.present(from: sender as! UIView)
    }
    
    // MARK: PAGE SAVE
    @IBAction func pageSave(_ sender: Any) {
        let page = try! CoreDataPage.createPage(album: album, date: Date(), photo: "", audio: "")
        
        if date != nil {
            page.pageDate = date
        }
        
        if imageURL !=  nil {
            page.pagePhoto = imageURL
        }
        
        if audioURL != nil {
            page.pageAudio = audioURL
        }
        
        pages.append(page)
        
        try? CoreDataPage.saveContext()
        print(page)
        
        // mostra a collection de pages
        if let vc = storyboard?.instantiateViewController(identifier: "pageView") as? PageViewController {
            vc.changeAlbum(album: album)
            self.dismiss(animated: true, completion: nil)
            delegate?.didRegisterPage()
        }
        
        
    }
    
    // MARK: GET DIRECTORY
    func getDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    // MARK: CONVERT DATE TO STRING
    func convertDate(date: Date) -> String {
        self.date = date
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.full
        let stringDate = formatter.string(from: date)
        return stringDate
    }
    
    
    // MARK: DATE PICKER
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.full
        formatter.locale = Locale(identifier: "pt_BR")
        let stringDate = formatter.string(from: datePicker!.date)
        date = datePicker!.date
        dateInput = stringDate
    }
    
    // MARK: CANCEL
    @IBAction func creationCancel(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Cancelar Página", message: "Todas suas mudanças serão perdidas.\nTem certeza que deseja cancelar?", preferredStyle: .alert)
        refreshAlert.addAction(UIAlertAction(title: "Sim", style: .destructive, handler: { [self] action in
            self.dismiss(animated: true, completion: nil)
        }))
        refreshAlert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    // MARK: RECORD AUDIO
    @IBAction func recordAction(_ sender: Any) {
        if let player = audioPlayer {
            if player.isPlaying {
                player.stop()
                playButton.setImage(UIImage(systemName: "play.circle"), for: UIControl.State())
                playButton.isSelected = false
            }
        }
        
        if let recorder = audioRecorder {
            if !recorder.isRecording {
                let audioSession = AVAudioSession.sharedInstance()
                
                do {
                    try audioSession.setActive(true)
                } catch _ {
                }
                
                // Começa a gravar
                recorder.record()
                print("To gravando")
                recordAudioButton.setImage(UIImage(systemName: "record.circle"), for: UIControl.State.selected)
                playButton.setImage(UIImage(systemName: "play.circle"), for: UIControl.State())
                recordLabel.text = "Parar de Gravar"
                
                recordAudioButton.isSelected = true
                playButton.isEnabled = false
                
            } else {
                
                recordAudioButton.setImage(UIImage(systemName: "mic.circle"), for: UIControl.State())
                playButton.setImage(UIImage(systemName: "play.circle"), for: UIControl.State())
                recordLabel.text = "Regravar Áudio"
                
                recordAudioButton.isSelected = false
                playButton.isSelected = false
                
                playButton.isEnabled = true
                recordAudioButton.isEnabled = true
                
                if let recorder = audioRecorder {
                    if recorder.isRecording {
                        audioRecorder?.stop()
                        let audioSession = AVAudioSession.sharedInstance()
                        do {
                            try audioSession.setActive(false)
                        } catch _ {
                        }
                    }
                }
                
                // Parando de gravar
                if let player = audioPlayer {
                    if player.isPlaying {
                        player.stop()
                    }
                }
                
            }
        }
    }
    
    
    // MARK: PLAY AUDIO
    @IBAction func playReplayAction(_ sender: Any) {
        if let recorder = audioRecorder {
            if !recorder.isRecording {
                audioPlayer = try? AVAudioPlayer(contentsOf: recorder.url)
                audioPlayer?.delegate = self
                audioPlayer?.play()
                playButton.setImage(UIImage(systemName: "play.circle"), for: UIControl.State.selected)
                playButton.isSelected = true
                
                recordAudioButton.setImage(UIImage(systemName: "record.circle"), for: UIControl.State())
                //recordAudioButton.isEnabled = false
            }
        }
    }
    
    
    // MARK: CHECK MIC
    func checkMicrophoneAccess() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            print(#function, " Microphone Permission Granted")
            break
            
        case AVAudioSession.RecordPermission.denied:
            UIApplication.shared.sendAction(#selector(UIView.endEditing(_:)), to:nil, from:nil, for:nil)
            
            let alert = UIAlertController(title: "Error", message: "Code is Not Authorized to Access the Microphone!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
            
            
            return
            
        case AVAudioSession.RecordPermission.undetermined:
            UIApplication.shared.sendAction(#selector(UIView.endEditing(_:)), to:nil, from:nil, for:nil)
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                if granted {
                    print(#function, " Now Granted")
                } else {
                    print("Pemission Not Granted")
                }
            })
        @unknown default:
            print("ERROR! Unknown Default. Check!")
        }
        
    }
    
    
    //MARK: Check Album permission
    func checkPermissions() {
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in ()
            })
        }
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            print("Access granted to use Photo Library")
        } else {
            print("We don't have access to yout Photos")
        }
    }
    
    
}

//MARK: EXTENSION IMAGE PICKER
extension NewPageViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.imgPhoto.image = image
        guard let newImage: UIImage = imgPhoto.image else {
            return
        }
        imageURL = FileHelper.saveToFiles(image: newImage)
    }
    
    
}


