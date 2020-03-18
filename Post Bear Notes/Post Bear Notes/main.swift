//
//  main.swift
//  Post Bear Notes
//
//  Created by Tianyun Shan on 2019-09-22.
//  Copyright © 2019 Hourglass Lab. All rights reserved.
//

import Foundation

if CommandLine.argc < 2 {
    // We expect user to input the file path for bear.
    // E.g. ./bear-post xxx.md (assume ./bear-post is our script name);
    print("No arguments are passed. Expect file path for the exported post. Usually in ~/Downloads folder.")
} else {
    let bearPostPath = CommandLine.arguments[1]
    let sourceUrl = URL(fileURLWithPath: bearPostPath)
    let destinationUrl = FileManager.default.currentDirectoryPath

}

