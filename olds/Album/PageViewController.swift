//
//  PageViewController.swift
//  olds
//
//  Created by Raphael Alkamim on 16/09/21.
//

import UIKit

class PageViewController: UIViewController, UICollectionViewDelegate {
    var page: Page?
    var date: Date?
    var album: Album?
    var pageIndex: Int?

    var pageData: [Page]?

    @IBOutlet weak var pageCollection: UICollectionView!

    
    @IBAction func newPage(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destVC = storyboard.instantiateViewController(withIdentifier: "ModalNewPage")
        
        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        changeAlbum(album: album)

        self.present(destVC, animated: true, completion: nil)
        
    }
    
    func convertDate(date: Date) -> String {
        self.date = date
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.full
        let stringDate = formatter.string(from: date)
        return stringDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageData = try! CoreDataPage.getPage()
        
        date = page?.pageDate
        
        pageCollection.delegate = self
        pageCollection.dataSource = self
       
    
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        didRegister()
    }
    
    

    func changeAlbum(album: Album?) {
        self.album = album
    }
    
   
    @IBAction func goBackToAlbums(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func didRegister() {
        pageData = try! CoreDataPage.getPage()
        pageData!.reverse()
        pageCollection.reloadData()
    }
}
    
    
    extension PageViewController: UICollectionViewDataSource {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return pageData!.count
            
            
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let pageDataCell: PageViewCollectionViewCell = pageCollection?.dequeueReusableCell(withReuseIdentifier: "PageCell", for: indexPath as IndexPath) as! PageViewCollectionViewCell
            
            didRegister()
            
            pageDataCell.titleCell.text = convertDate(date: (pageData?[indexPath.row].pageDate)!)
            
            
            return pageDataCell
        }
        
        
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        }
        
        
        
        // context
        func configureContextMenu(index: Int) -> UIContextMenuConfiguration{
            let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
                
                let delete = UIAction(title: "Apagar Página", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil,attributes: .destructive, state: .off) { (_) in
                    let ac = UIAlertController(title: "Deletar Página", message: "Tem certeza que deseja deletar essa Página?", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Sim", style: .destructive, handler: { [self] action in
                        didRegister()
                        
                        
                        if let page = pageData?[index] {
                            try? CoreDataPage.deletePage(page: page)
                        }
                        
                        didRegister()
                       
                    }))
                    
                    ac.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))
                    
                    self.present(ac, animated: true, completion: nil)
                    
                    
                    
                }
                
                return UIMenu(title: "Opções", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [delete])
                
            }
            return context
        }
        
    }

