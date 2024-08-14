//
//  Double+Extension.swift
//  ObiletCaseApp
//
//  Created by Burak Gül on 14.08.2024.
//

import Foundation


extension Double {
    var toInt: Int? {
        if self.truncatingRemainder(dividingBy: 1) == 0 {
            return Int(self)
        } else {
            return nil
        }
    }
    
    var toString : String {
        return String(self)
    }
}
