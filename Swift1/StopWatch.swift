//
//  StopWatch.swift
//  Swift1
//
//  Created by Florian on 29/01/15.
//  Copyright (c) 2015 Dekibae SAS. All rights reserved.
//

import Foundation
import UIKit

// Calculates elapsed time
// Thanks to https://gist.github.com/kristopherjohnson/7528fbbed80cd74edc69
public struct Stopwatch {
    
    private var startTime: NSTimeInterval
    
    // Initialize with current time as start point
    public init() {
        startTime = CACurrentMediaTime()
    }
    
    // Reset start point to current time
    public mutating func reset() {
        startTime = CACurrentMediaTime()
    }
    
    // Calculate elapsed time since initialization or last call to reset()
    public func elapsedTimeInterval() -> NSTimeInterval {
        return CACurrentMediaTime() - startTime
    }
    
    // Return elapsed time in textual form
    
    // If elapsed time is less than a second, it will be rendered as milliseconds.
    // Otherwise it will be rendered as seconds.
    public func elapsedTimeString() -> NSString {
        let interval = elapsedTimeInterval()
        if interval < 1.0 {
            return NSString(format:"%.1f ms", Double(interval * 1000))
        }
        else {
            return NSString(format:"%.3f s", Double(interval))
        }
    }
}

extension Stopwatch: Printable {
    public var description: String {
        return elapsedTimeString()
    }
}
