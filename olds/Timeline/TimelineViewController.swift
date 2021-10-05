//
//  TimelineViewController.swift
//  olds
//
//  Created by Raphael Alkamim on 16/09/21.
//

import UIKit
import AVFoundation
import CoreData

class TimelineViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var timelineCollection: UICollectionView!
    var album: Album?
    var pages: [Page]?
    var audio: AVAudioPlayer?
    var date: Date?
    var pagesSorted: [Page]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timelineCollection.delegate = self
        timelineCollection.dataSource = self

        
    }
    
    // MARK: VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        didRegisterTimeline()
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
        formatter.dateStyle = DateFormatter.Style.long
        formatter.locale = Locale(identifier: "pt_BR")
        let stringDate = formatter.string(from: date)
        return stringDate
    }
    
    
    func didRegisterTimeline() {
        pages = try? CoreDataPage.getPage()
        pages = pages?.sorted(by: { $0.pageDate! < $1.pageDate!})
        timelineCollection.reloadData()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pages!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pageDataCell: TimelineCollectionViewCell = timelineCollection?.dequeueReusableCell(withReuseIdentifier: "timelineCell", for: indexPath as IndexPath) as! TimelineCollectionViewCell
        
        // põe a data na página
        pageDataCell.dateLabelCell.text = convertDate(date: (pages?[indexPath.row].pageDate)!)
        
        // põe a imagem na página
        if let path = pages?[indexPath.row].pagePhoto, let image = UIImage(contentsOfFile: FileHelper.getFilePath(fileName: path)) {
            pageDataCell.imgCell.image = image
        }
        
        
        // põe o audio na página
        let audioPath = getDirectory().appendingPathComponent((pages?[indexPath.row].pageAudio!)!)
        
        pageDataCell.playAudio(url: audioPath)
        
        return pageDataCell
        
    }


}
