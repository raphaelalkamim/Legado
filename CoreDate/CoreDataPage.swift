//
//  CoreDataPage.swift
//  olds
//
//  Created by Caroline Taus on 20/09/21.
//

import Foundation
import CoreData

class CoreDataPage {
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "olds")
        container.loadPersistentStores{ _, error in
            if let erro = error {
                preconditionFailure(erro.localizedDescription)
            }
            
        }
        return container
    }()
    static var context: NSManagedObjectContext = CoreDataAlbum.context
//    static var context: NSManagedObjectContext {
//        return persistentContainer.viewContext
//    }
    
    // salvar
    static func saveContext() throws{
        if context.hasChanges{
            try context.save()
        }
    }
    
    // criar Página
    static func createPage(album: Album, date: Date, photo: String, audio: String) throws -> Page {
//        guard let page = NSEntityDescription.insertNewObject(forEntityName: "Page", into: context) as? Page else { preconditionFailure() }
        let page = Page(context: context)
        
        page.pageAudio = audio
        page.pageDate = date
        page.pagePhoto = photo
        album.addToPages(page)
    
        try saveContext()
        return page
    }
    
    // pesquisar páginas (traz todas as páginas do CoreData)
    static func getPage() throws -> [Page] {
        return try context.fetch(Page.fetchRequest())
    }
    
    
    static func getAlbumPages(album: Album) throws -> [Page] {
        let allPages = try context.fetch(Page.fetchRequest()) as? [Page]
        let albumPages = allPages?.filter({
            $0.album == album
        })
        var pages: [Page] = []
        if let safePages = albumPages {
            pages = safePages
        }
        return pages
    }
    
    
    
    // deletar página
    static func deletePage(page: Page) throws {
        if page.pagePhoto != nil{
            let _ = FileHelper.deleteImage(path: page.pagePhoto!)
        }
        if page.pageAudio != nil {
            let audioPath = getDirectory().appendingPathComponent(page.pageAudio!)
            if FileManager.default.fileExists(atPath: audioPath.relativePath){
                try! FileManager.default.removeItem(at: audioPath)
            }
            
               
            
        }
        context.delete(page)
        try saveContext()
        
    }
    
    
    
    static func getDirectory() -> URL{
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentDirectory = paths[0]
            return documentDirectory
        }
}
