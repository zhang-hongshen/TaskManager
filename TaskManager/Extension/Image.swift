//
//  Image.swift
//  TaskManager
//
//  Created by 张鸿燊 on 10/10/2023.
//

import Foundation
import SwiftUI

extension Image {
    init?(data: Data){
        #if canImport(AppKit)
        guard let nsImage = NSImage(data: data) else {
            return nil
        }
        self.init(nsImage: nsImage)
        #elseif canImport(UIKit)
        guard let uiImage = UIImage(data: data) else {
            return nil
        }
        self.init(uiImage: uiImage)
        #else
        return nil
        #endif
    }
}
