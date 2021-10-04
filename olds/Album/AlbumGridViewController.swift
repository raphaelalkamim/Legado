//
//  AlbumGridViewController.swift
//  olds
//
//  Created by Raphael Alkamim on 16/09/21.
//

import UIKit

class AlbumGridViewController: UIViewController, UICollectionViewDelegate {
    
    // MARK: OUTLETS & VARIÁVEIS
    var album: Album?
    @IBOutlet weak var helperButton: UIBarButtonItem!
    @IBOutlet weak var createAlbumButton: UIBarButtonItem!
    @IBOutlet weak var albumCollection: UICollectionView!
    @IBOutlet weak var segmented: UISegmentedControl!
    var albumData: [Album]?
    var albumsToDisplay: [Album]?
    var elements = [UIAccessibilityElement]()
    
    // MARK: SEGMENTED
    @IBAction func segmented(_ sender: Any) {
        let index = self.segmented.selectedSegmentIndex
        
        if index == 0 {
            albumsToDisplay = albumData?.reversed()
        }
        
        else if index == 1{
            albumsToDisplay = albumData?.filter({
                $0.albumType == "person"
            }).reversed()
        }
        
        else if index == 2 {
            albumsToDisplay = albumData?.filter({
                $0.albumType == "travel"
            }).reversed()
        }
        
        else if index == 3 {
            albumsToDisplay = albumData?.filter({
                $0.albumType == "event"
            }).reversed()
        }
        
        else {
            albumsToDisplay = albumData?.filter({
                $0.albumType == "other"
            }).reversed()
        }
        self.albumCollection?.reloadData()
    }
    
    // MARK: VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumCollection.dataSource = self
        albumCollection.delegate = self
        
        albumData = try! CoreDataAlbum.getAlbum()
        albumsToDisplay = albumData
        albumsToDisplay!.reverse()
        
        //Determinando elementos como de acessibilidade
        helperButton.isAccessibilityElement = true
        createAlbumButton.isAccessibilityElement = true
    }
    
    
    // MARK: VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        didRegister()
    }
  
    
}

extension AlbumGridViewController: UICollectionViewDataSource {
    // MARK: COLLECTION
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumsToDisplay!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let albumDataCell: AlbumCollectionViewCell = albumCollection?.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath as IndexPath) as! AlbumCollectionViewCell
        albumDataCell.albumTitle.text = albumsToDisplay![indexPath.row].albumTitle
        // colocando as capas dos álbuns
        if let img = albumsToDisplay?[indexPath.row].albumType {
            let coverImage: String =  String(img)
            
            if coverImage == "person" {
                albumDataCell.albumCover.image = UIImage(named: "blueAlbum")
                albumDataCell.albumCover.accessibilityValue = "Pessoas"
//                coverImage.accessibilityValue = "Pessoas"
            }
            else if coverImage == "travel"{
                albumDataCell.albumCover.image = UIImage(named: "brownAlbum")
                albumDataCell.albumCover.accessibilityValue = "Viagens"
//                coverImage.accessibilityValue = "Viagens"
            }
            else if coverImage == "event"{
                albumDataCell.albumCover.image = UIImage(named: "greenAlbum")
                albumDataCell.albumCover.accessibilityValue = "Eventos"
//                coverImage.accessibilityValue = "Eventos"
            }
            else {
                albumDataCell.albumCover.image = UIImage(named: "redAlbum")
                albumDataCell.albumCover.accessibilityValue = "Outros"
//                coverImage.accessibilityValue = "Outros"
            }
        }
        let groupedElement = UIAccessibilityElement(accessibilityContainer: self)
        groupedElement.accessibilityLabel = "\(albumDataCell.albumCover.image!), \(albumDataCell.albumTitle.text!)"
        groupedElement.accessibilityFrameInContainerSpace = albumDataCell.albumCover.frame.union(albumDataCell.albumTitle.frame)
        elements.append(groupedElement)

        return albumDataCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "CoverView") as? AlbumViewController {
            vc.album = albumsToDisplay![indexPath.item]
            navigationController?.pushViewController(vc, animated: true)
            
        }
        self.albumCollection?.reloadData()
    }
    
    // MARK: CHANGE ALBUM
    func changeAlbum(album: Album?) {
        self.album = album
    }
    
    // MARK: CONTEXT MENU
    func configureContextMenu(index: Int) -> UIContextMenuConfiguration{
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            
            let edit = UIAction(title: "Editar Álbum", image: UIImage(systemName: "square.and.pencil"), identifier: nil, discoverabilityTitle: nil, state: .off) { (_) in
                if let vc = self.storyboard?.instantiateViewController(identifier: "EditView") as? NewAlbumViewController {
                    vc.changeAlbum(album: self.album)
                    self.navigationController?.pushViewController(vc, animated: true)
                } }
            let delete = UIAction(title: "Apagar Álbum", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil,attributes: .destructive, state: .off) { (_) in
                print("delete button clicked")
                let ac = UIAlertController(title: "Deletar Álbum", message: "Tem certeza que deseja deletar esse álbum?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Sim", style: .destructive, handler: { [self] action in
                    var coreDataAlbums = try? CoreDataAlbum.getAlbum()
                    coreDataAlbums?.reverse()
                    
                    if let albums = coreDataAlbums?[index] {
                        try? CoreDataAlbum.deleteAlbum(album: albums)
                    }
                    
                    didRegister()
                   
                }))
                
                ac.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))
                
                self.present(ac, animated: true, completion: nil)
            }
            
            return UIMenu(title: "Opções", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [edit,delete])
            
        }
        return context
    }
    
}

extension AlbumGridViewController {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        configureContextMenu(index: indexPath.row)
    }
}

// MARK: DID REGISTER
extension AlbumGridViewController: NewAlbumViewControllerDelegate {
    func didRegister() {
        albumData = try! CoreDataAlbum.getAlbum()
        albumsToDisplay = albumData
        albumsToDisplay!.reverse()
        albumCollection.reloadData() // atualiza informações
    }
}


