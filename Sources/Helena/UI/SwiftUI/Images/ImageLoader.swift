//
//  ImageLoader.swift
//  Helena
//
//  Created by Adrian Haubrich on 31.10.21.
//

import Foundation
import SwiftUI

#if os(macOS)
import MacOSCompatibility
#else
import UIKit
#endif

public struct ImageLoader {
    
    static func loadUIImage(with name: String) -> UIImage {
        UIImage(named: name, in: Bundle.module, compatibleWith: nil) ?? UIImage()
    }
    
    static func loadImage(with name: String) -> Image {
        return Image(uiImage: self.loadUIImage(with: name))
    }
    
}
