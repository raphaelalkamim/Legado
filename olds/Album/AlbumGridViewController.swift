//
//  AlbumGridViewController.swift
//  olds
//
//  Created by Raphael Alkamim on 16/09/21.
//

import UIKit

class AlbumGridViewController: UIViewController, UICollectionViewDelegate {
    

 
    @IBOutlet weak var editAlbumButton: UIBarButtonItem!
    @IBOutlet weak var createAlbumButton: UIBarButtonItem!
    @IBOutlet weak var albumCollection: UICollectionView!
    @IBOutlet weak var segmented: UISegmentedControl!
    
    @IBAction func segmented(_ sender: Any) {
        let index = self.segmented.selectedSegmentIndex

        if index == 0 {

        print("item 0")

        }

        else if index == 1{

        print("item 1")

        }

        else{

        print("ffffffffff")

        }

        self.albumCollection?.reloadData()
    }
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumCollection.dataSource = self
        albumCollection.delegate = self
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        didRegister()
    }
    
    


}

extension AlbumGridViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let albumData = try! CoreDataAlbum.getAlbum()
        return albumData.count

//        var qtd: Int = 0
//        if let albumData = try? CoreDataAlbum.getAlbum() {
//            if albumData == nil {
//                qtd = 0
//
//            }
//            else {
//                qtd = albumData.count
//            }
//
//        }
//        print(qtd)
//        return qtd
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let albumDataCell: AlbumCollectionViewCell = albumCollection?.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath as IndexPath) as! AlbumCollectionViewCell
        var albumData = try! CoreDataAlbum.getAlbum()
        albumData.reverse()
        
        albumDataCell.albumTitle.text = albumData[indexPath.row].albumTitle
        let coverImage: String? = String?((albumData[indexPath.row].albumType)!)
        if coverImage == "person" {
            albumDataCell.albumCover.image = UIImage(named: "blueAlbum")
        }
        else if coverImage == "travel"{
            albumDataCell.albumCover.image = UIImage(named: "brownAlbum")
        }
        else if coverImage == "event"{
            albumDataCell.albumCover.image = UIImage(named: "greenAlbum")
        }
        else {
            albumDataCell.albumCover.image = UIImage(named: "redAlbum")
        }
        
        return albumDataCell
    }
    
  
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "CoverView") as? AlbumViewController {
            var albumData = try! CoreDataAlbum.getAlbum()
            albumData.reverse()
            vc.album = albumData[indexPath.item]
            navigationController?.pushViewController(vc, animated: true)
            
        }
        self.albumCollection?.reloadData()
    }
    
    // context
    func configureContextMenu(index: Int) -> UIContextMenuConfiguration{
            let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
                
                let edit = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil"), identifier: nil, discoverabilityTitle: nil, state: .off) { (_) in
                    print("edit button clicked")
                }
                let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil,attributes: .destructive, state: .off) { (_) in
                    print("delete button clicked")
                }
                
                return UIMenu(title: "Options", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [edit,delete])
                
            }
            return context
        }
    
}

extension AlbumGridViewController: NewAlbumViewControllerDelegate {
    func didRegister() {
        albumCollection.reloadData() // atualiza informações
    }
}

// context menu
extension AlbumGridViewController{
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        configureContextMenu(index: indexPath.row)
    }
}
