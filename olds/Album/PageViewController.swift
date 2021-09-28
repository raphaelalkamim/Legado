//
//  PageViewController.swift
//  olds
//
//  Created by Raphael Alkamim on 16/09/21.
//

import UIKit

class PageViewController: UIViewController, UICollectionViewDelegate {
    var date: Date?
    var album: Album?
    var pageIndex: Int?
    var pageData: [Page]?
    
    @IBOutlet weak var pageCollection: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tentar tirar o try e deixar só no viewWillAppear
        //pageData = try! CoreDataPage.getPage()
        
        
        pageCollection.delegate = self
        pageCollection.dataSource = self
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is NewPageViewController {
            let vc = segue.destination as? NewPageViewController
            vc?.album = album
            //MARK: PRECISA CONECTAR!
            vc?.delegate = self
        }
        
    }
    
    
    func convertDate(date: Date) -> String {
        self.date = date
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.full
        let stringDate = formatter.string(from: date)
        return stringDate
    }
    
    
    
    func changeAlbum(album: Album) {
        self.album = album
    }
    
    override func viewWillAppear(_ animated: Bool) {
        didRegisterPage()
    }
    
    
}


extension PageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print(pageData!.count)
        // fazer guard let pra se pagedata for NIL
        
        return self.pageData!.count
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let pageDataCell: PageViewCollectionViewCell = pageCollection?.dequeueReusableCell(withReuseIdentifier: "pageCell", for: indexPath as IndexPath) as! PageViewCollectionViewCell
        
        
        pageDataCell.titleCell.text = convertDate(date: (pageData?[indexPath.row].pageDate)!)
        
        
        return pageDataCell
    }
    
    
    
    
    // context
    func configureContextMenu(index: Int) -> UIContextMenuConfiguration{
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            
            let delete = UIAction(title: "Apagar Página", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil,attributes: .destructive, state: .off) { (_) in
                let ac = UIAlertController(title: "Deletar Página", message: "Tem certeza que deseja deletar essa Página?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Sim", style: .destructive, handler: { [self] action in
                    didRegisterPage()
                    
                    
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

extension PageViewController: NewPageViewControllerDelegate {
    func didRegisterPage() {
        pageData = try! CoreDataPage.getAlbumPages(album: album!)
        //pageData!.reverse()
        pageCollection.reloadData()
    }
    
 
}
