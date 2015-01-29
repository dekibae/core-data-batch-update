//
//  Employee.swift
//  Swift1
//
//  Created by Florian on 07/01/15.
//  Copyright (c) 2015 Dekibae SAS. All rights reserved.
//

import Foundation
import CoreData

// Wonder why this is needed, if not there, the following warning is issued:
// CoreData: warning: Unable to load class named 'Employee' for entity 'Employee'. Class not found, using default NSManagedObject instead.
@objc (Employee)

class Employee: NSManagedObject {

    @NSManaged var dirty: NSNumber

}
