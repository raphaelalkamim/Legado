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
    }
    func changeAlbum(album: Album?) {
        self.album = album
    }

    

}
