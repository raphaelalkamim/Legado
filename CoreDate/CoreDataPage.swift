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
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // salvar
    static func saveContext() throws{
        if context.hasChanges{
            try context.save()
        }
    }
    
    // criar Página
    static func createPage(date: Date, photo: String, audio: String) throws -> Page {
        guard let page = NSEntityDescription.insertNewObject(forEntityName: "Page", into: context) as? Page else { preconditionFailure() }
        page.pageAudio = audio
        page.pageDate = date
        page.pagePhoto = photo
       
        try saveContext()
        return page
    }
    
    // pesquisar página
    static func getPage() throws -> [Page] {
        return try context.fetch(Page.fetchRequest())
    }
    
    // deletar página
    static func deletePage(page: Page) throws {
        if page.pagePhoto != nil{
            let _ = FileHelper.deleteImage(path: page.pagePhoto!)
        }
        context.delete(page)
        try saveContext()
    }
    
}
