//
//  DataManager.swift
//  seopMemo
//
//  Created by Minseop Kim on 2020/02/21.
//  Copyright © 2020 Minseop Kim. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    
    static let shared = DataManager()
    private init() {
        // Singleton 방식으로 진행 한 것
    }
    
    var mainContenxt: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var memoList = [Memo]()
    
    func fetchMemo()  {
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        
        let sortByDateDesc = NSSortDescriptor(key: "insertDate", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        
        do {
            memoList =  try mainContenxt.fetch(request)
        }catch{
            print(error)
        }
        
    }
    
    func addNewMemo( _ memo: String?, _ memoTitle: String?, _ memoImage: Data?){
        let newMemo = Memo(context: mainContenxt)
        newMemo.content = memo
        newMemo.memoTitle = memoTitle
        newMemo.insertDate = Date()
        newMemo.memoImage = memoImage
            
        memoList.insert(newMemo, at: 0)
        saveContext()
    }
    
    func delectMemo(_ memo: Memo?){
        if let memo = memo {
            mainContenxt.delete(memo)
            saveContext()
        }
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

     
        let container = NSPersistentContainer(name: "seopMemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
