//
//  ViewController.swift
//  Swift1
//
//  Created by Florian on 28/12/14.
//  Copyright (c) 2014 Dekibae SAS. All rights reserved.
//

import UIKit
import CoreData

let EMPLOYEE_ENTITY = "Employee"

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var homeView: UIView!
    
    // MARK: - Accessors
    var appDelegate: AppDelegate {
        get {
            return UIApplication.sharedApplication().delegate as AppDelegate
        }
    }

    var context: NSManagedObjectContext {
        get {
            return appDelegate.managedObjectContext!
        }
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let databaseURL = self.appDelegate.applicationDocumentsDirectory.URLByAppendingPathComponent("data.sqlite")
        
        // Delete any previously set database
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        
        if fileManager.fileExistsAtPath(databaseURL.path!) {
            fileManager.removeItemAtURL(databaseURL, error: nil)
        }
    }
    
    // MARK: - Target Action
    @IBAction func run() {
        self.setupDatabase();
        
        // Sleep a little bit
        NSThread.sleepForTimeInterval(5)

        var stopwatch = Stopwatch()
        
        self.updateEntriesWithBatchRequest()
        
        println("Batch Request   - Elapsed time: \(stopwatch.elapsedTimeString())")
        
        // Sleep a little bit
        NSThread.sleepForTimeInterval(5)
        
        stopwatch = Stopwatch()
        
        self.updateEntriesWithRegularRequest()
        
        println("Regular Request - Elapsed time: \(stopwatch.elapsedTimeString())")
    }
    
    // MARK: - Core Data
    func setupDatabase() {
        
        // Create entries in the database
        for employeeId in 1...100000 {
            
            let entity = NSEntityDescription.entityForName(EMPLOYEE_ENTITY, inManagedObjectContext: context)
            
            let employee = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)
            
            employee.setValue(1, forKey: "dirty")
        }
        
        self.appDelegate.saveContext()
        self.context.reset()
    }
    
    func updateEntriesWithBatchRequest() {
        
        // Reset the dirty flag of all the entries
        let batchRequest = NSBatchUpdateRequest(entityName: EMPLOYEE_ENTITY)
        
        batchRequest.includesSubentities = false
        
        // We want the number of rows which have been updated as a result type
        batchRequest.resultType = .UpdatedObjectsCountResultType
        
        // Fetch only the dirty entries
        batchRequest.predicate = NSPredicate(format: "dirty == 1")
        
        // Reset the dirty flag
        batchRequest.propertiesToUpdate = [ "dirty" : 0 ]
        
        var batchError: NSError?
        
        // Return the number of rows updated
        let result = self.context.executeRequest(batchRequest, error:&batchError) as NSBatchUpdateResult
        
        if result.result == nil {
            println(batchError)
        }
    }
    
    func updateEntriesWithRegularRequest() {
        
        let fetchRequest: NSFetchRequest = NSFetchRequest(entityName: EMPLOYEE_ENTITY)
        
        // We only want the dirty entries
        fetchRequest.predicate = NSPredicate(format: "dirty == 0")
        
        var error: NSError?
        
        // Fetch objects from the database
        let results = self.context.executeFetchRequest(fetchRequest, error: &error) as Array!
        
        var batchError: NSError?
        
        if error == nil {
            
            // Update each object property
            for managedObject in results {
                managedObject.setValue(1, forKey: "dirty")
            }
            
            self.appDelegate.saveContext()
        } else {
            println(error)
        }
    }
}

