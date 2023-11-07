//
//  AppInstalled.swift
//  Direct Chat
//
//  Created by Renzo Delgado on 24/03/22.
//

import Foundation
import UIKit

func isAppInstalled() -> Bool{

    let appScheme = "whatsapp://app"
    let appUrl = URL(string: appScheme)

    if UIApplication.shared.canOpenURL(appUrl! as URL){
        return true
    } else {
        return false
    }

}
