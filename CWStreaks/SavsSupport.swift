//
//  SavsSupport.swift
//  CWStreaks
//
//  Created by Mensah Shadrach on 3/26/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

import Foundation


func documentsDirectory()->String{
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    return paths[0]
}
func dataFilePath(key:NSString)->String{
    return(documentsDirectory() as NSString)
        .appendingPathComponent("messages.plist")
}




