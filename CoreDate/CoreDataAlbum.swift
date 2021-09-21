//
//  CoreDataAlbum.swift
//  olds
//
//  Created by Caroline Taus on 20/09/21.
//

import Foundation
import CoreData

class CoreDataAlbum {
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
    
    // criar Album
    static func createAlbum(title: String, type: String) throws -> Album {
        guard let album = NSEntityDescription.insertNewObject(forEntityName: "Album", into: context) as? Album else { preconditionFailure() }
        album.albumTitle = title
        album.albumType = type
        
        try saveContext()
        return album
    }
    
    // pesquisar album
    static func getAlbum() throws -> [Album] {
        return try context.fetch(Album.fetchRequest())
    }
    
    // deletar album
    static func deleteAlbum(album: Album) throws {
        
        let pages = album.pages
        try pages?.forEach { page in
            guard let x = page as? Page else {
               return
            }
            try CoreDataPage.deletePage(page: x)
        }
        
        context.delete(album)
        try saveContext()
    }
    
    
    
    
}
