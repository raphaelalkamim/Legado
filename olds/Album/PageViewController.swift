//
//  PageViewController.swift
//  olds
//
//  Created by Raphael Alkamim on 16/09/21.
//

import UIKit

class PageViewController: UIViewController {
    var page: Page?
    var date: Date?
    var album: Album?
    var pageIndex: Int?

    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
   
    
    @IBAction func goNext(_ sender: Any) {
        print("fui pra next")
        if let vc = storyboard?.instantiateViewController(identifier: "pageView") as? PageViewController {
            vc.changeAlbum(album: album)
            let index = pageIndex!+1
            vc.page = album?.pages?.allObjects[index] as? Page
            vc.pageIndex = pageIndex!+1
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    @IBAction func goPrevious(_ sender: Any) {
        print("previ")
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
        date = page?.pageDate
        
        title = convertDate(date: (page?.pageDate)!)
        print("title: ",title)
        print("AAAAA PAGINA", page)
        
        let numberOfPages = album?.pages?.count
        print("NUMPAGES",numberOfPages)
        print("PAGESINDEX",pageIndex)
        print(album)
        print(album?.pages)
        if pageIndex == (numberOfPages! - 1) {
            nextButton.isHidden = true

        }
        
        
    }
    func changeAlbum(album: Album?) {
        self.album = album
    }
    
   
    @IBAction func goBackToAlbums(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    

}
