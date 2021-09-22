//
//  AlbumGridViewController.swift
//  olds
//
//  Created by Raphael Alkamim on 16/09/21.
//

import UIKit

class AlbumGridViewController: UIViewController, UICollectionViewDelegate {
    var album: Album?
    
    @IBOutlet weak var editAlbumButton: UIBarButtonItem!
    @IBOutlet weak var createAlbumButton: UIBarButtonItem!
    @IBOutlet weak var albumCollection: UICollectionView!
    @IBOutlet weak var segmented: UISegmentedControl!
    var albumData: [Album]?
    var albumsToDisplay: [Album]?
    
    @IBAction func segmented(_ sender: Any) {
        let index = self.segmented.selectedSegmentIndex
        
        if index == 0 {
            
            albumsToDisplay = albumData
            albumsToDisplay!.reverse()
            
        }
        
        else if index == 1{
            albumsToDisplay = albumData?.filter({
                $0.albumType == "person"
            })
            albumsToDisplay!.reverse()
            
        }
        
        else if index == 2 {
            
            albumsToDisplay = albumData?.filter({
                $0.albumType == "travel"
            })
            albumsToDisplay!.reverse()
            
        }
        
        else if index == 3 {
            albumsToDisplay = albumData?.filter({
                $0.albumType == "event"
            })
            albumsToDisplay!.reverse()
            
        }
        
        else {
            albumsToDisplay = albumData?.filter({
                $0.albumType == "other"
            })
            albumsToDisplay!.reverse()
            
        }
        
        self.albumCollection?.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumCollection.dataSource = self
        albumCollection.delegate = self
        
        albumData = try! CoreDataAlbum.getAlbum()
        albumsToDisplay = albumData
        albumsToDisplay!.reverse()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        didRegister()
    }
    
    
    
    
}

extension AlbumGridViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return albumsToDisplay!.count
        
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
        
        //albumsToDisplay!.reverse()
        
        albumDataCell.albumTitle.text = albumsToDisplay![indexPath.row].albumTitle
        let coverImage: String? = String?((albumsToDisplay![indexPath.row].albumType)!)
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
            //var albumData = try! CoreDataAlbum.getAlbum()
            //albumsToDisplay!.reverse()
            vc.album = albumsToDisplay![indexPath.item]
            navigationController?.pushViewController(vc, animated: true)
            
        }
        self.albumCollection?.reloadData()
    }
    
    func changeAlbum(album: Album?) {
        self.album = album
    }
    
    // context
    func configureContextMenu(index: Int) -> UIContextMenuConfiguration{
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            
            let edit = UIAction(title: "Editar Álbum", image: UIImage(systemName: "square.and.pencil"), identifier: nil, discoverabilityTitle: nil, state: .off) { (_) in
                if let vc = self.storyboard?.instantiateViewController(identifier: "EditView") as? NewAlbumViewController {
                    vc.changeAlbum(album: self.album)
                    self.navigationController?.pushViewController(vc, animated: true)
                } }
            let delete = UIAction(title: "Apagar Álbum", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil,attributes: .destructive, state: .off) { (_) in
                print("delete button clicked")
            }
            
            return UIMenu(title: "Opções", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [edit,delete])
            
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
