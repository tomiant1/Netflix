//
//  DataPersistenceManager.swift
//  Nextflix-Clone-App
//
//  Created by Tomi Antoljak on 12/2/22.
//
// DataPersistenceManager is a class that handles downloading and saving data locally into the database and fetching it from database

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    
    enum DatabaseError: Error {
        
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
        
    }
    
    static let shared = DataPersistenceManager()
    
    func downloadTitle(with model: Title, completion: @escaping (Result<Void, Error>) -> Void ) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        item.original_title = model.original_title
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.id = Int64(model.id)
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average
        item.original_name = model.original_name
        item.media_type = model.media_type
        
        do {
            
            try context.save()
            
            completion(.success(()))
            
        } catch {
            
            completion(.failure(DatabaseError.failedToSaveData))
            
        }
        
    }
    
    func fetchingData(completion: @escaping (Result<[TitleItem], Error>) -> Void ) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        
        do {
            
            let titleItems = try context.fetch(request)
            
            completion(.success(titleItems))
            
        } catch {
            
            completion(.failure(DatabaseError.failedToFetchData))
            
        }
        
    }
    
    func deleteTitle(with model: TitleItem, completion: @escaping (Result<Void, Error>) -> Void ) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            
            try context.save()
            
            completion(.success(()))
            
        } catch {
            
            completion(.failure(DatabaseError.failedToDeleteData))
            
        }
        
    }
    
}
