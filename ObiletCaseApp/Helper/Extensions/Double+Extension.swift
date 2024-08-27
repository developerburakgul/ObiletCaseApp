//
//  Double+Extension.swift
//  ObiletCaseApp
//
//  Created by Burak Gül on 14.08.2024.
//

import Foundation

extension Double {
    var toInt: Int? {
        truncatingRemainder(dividingBy: 1) == .zero ? Int(self): nil
    }
    
    var toString : String {
        String(self)
    }
}
