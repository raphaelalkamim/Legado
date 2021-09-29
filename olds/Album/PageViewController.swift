//
//  PageViewController.swift
//  olds
//
//  Created by Raphael Alkamim on 16/09/21.
//

import UIKit
import AVFoundation


class PageViewController: UIViewController, UICollectionViewDelegate {
    var date: Date?
    var album: Album?
    var pageIndex: Int?
    var pageData: [Page]?
    var audio: AVAudioPlayer?
   
    @IBOutlet weak var pageCollection: UICollectionView!
    
    
    // MARK: VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        pageCollection.delegate = self
        pageCollection.dataSource = self
    }
    
    // MARK: VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        didRegisterPage()
    }
    
    // MARK: SEGUE NEW PAGE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is NewPageViewController {
            let vc = segue.destination as? NewPageViewController
            vc?.album = album
            //PRECISA CONECTAR!
            vc?.delegate = self
        }
    }
    
    // MARK: CONVERT DATE TO STRING
    func convertDate(date: Date) -> String {
        self.date = date
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.full
        let stringDate = formatter.string(from: date)
        return stringDate
    }
    
    
    // MARK: CHANGE ALBUM
    func changeAlbum(album: Album) {
        self.album = album
    }
    
}

// MARK: EXTENSION VIEW CONTROLLER
extension PageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pageData!.count
    }
    
    // MARK: CONSTRUTOR DAS CELULAS
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let pageDataCell: PageViewCollectionViewCell = pageCollection?.dequeueReusableCell(withReuseIdentifier: "pageCell", for: indexPath as IndexPath) as! PageViewCollectionViewCell
        
        // põe a data na página
        pageDataCell.titleCell.text = convertDate(date: (pageData?[indexPath.row].pageDate)!)
        
        // põe a imagem na página
        if let path = pageData?[indexPath.row].pagePhoto, let image = UIImage(contentsOfFile: FileHelper.getFilePath(fileName: path)) {
            pageDataCell.imgCell.image = image
        }
        
        
        // põe o audio na página
        let audioPath = getDirectory().appendingPathComponent((pageData?[indexPath.row].pageAudio!)!)
        
        pageDataCell.playAudio(url: audioPath)
        
        
        return pageDataCell
        
    }
    
    // MARK: GET DIRECTORY
    func getDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    
    
    // MARK: CONTEXT MENU
    func configureContextMenu(index: Int) -> UIContextMenuConfiguration{
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            
            let delete = UIAction(title: "Apagar Página", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil,attributes: .destructive, state: .off) { (_) in
                let ac = UIAlertController(title: "Deletar Página", message: "Tem certeza que deseja deletar essa Página?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Sim", style: .destructive, handler: { [self] action in
                    
                    if let page = pageData?[index] {
                        try? CoreDataPage.deletePage(page: page)
                    }
                    
                    didRegisterPage()
                    
                }))
                
                ac.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))
                
                self.present(ac, animated: true, completion: nil)
                
            }
            
            return UIMenu(title: "Opções", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [delete])
            
        }
        return context
    }
    
}


extension PageViewController {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        configureContextMenu(index: indexPath.row)
    }
}

// MARK: DID REGISTER
extension PageViewController: NewPageViewControllerDelegate {
    func didRegisterPage() {
        pageData = try! CoreDataPage.getAlbumPages(album: album!)
        pageCollection.reloadData()
    }
}






