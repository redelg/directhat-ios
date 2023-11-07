//
//  LocalizedString.swift
//  Direct Chat
//
//  Created by Renzo Delgado on 26/02/22.
//

import UIKit


struct LocalizedString {
    
    static func getString(value: String) -> String{
        return NSLocalizedString(value, comment: "")
    }
    
}
