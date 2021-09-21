//
//  AlbumGridViewController.swift
//  olds
//
//  Created by Raphael Alkamim on 16/09/21.
//

import UIKit

class AlbumGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    

    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var editAlbumButton: UIBarButtonItem!
    @IBOutlet weak var createAlbumButton: UIBarButtonItem!
    @IBOutlet weak var albumCollection: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumCollection.dataSource = self
        albumCollection.delegate = self
        
        

     
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let albumData = try! CoreDataAlbum.getAlbum()
        return albumData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let albumDataCell: AlbumCollectionViewCell = albumCollection?.dequeueReusableCell(withReuseIdentifier: "albumDataCell", for: indexPath as IndexPath) as! AlbumCollectionViewCell
        var albumData = try! CoreDataAlbum.getAlbum()
        albumData.reverse()
        
        albumDataCell.albumTitle.text = albumData[indexPath.row].albumTitle
        
        // FALTA COLOCAR A IMAGEM DE CAPA
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
    


}

extension AlbumGridViewController: NewAlbumViewControllerDelegate {
    func didRegister() {
        albumCollection.reloadData() // atualiza informações
    }
    
    
}
