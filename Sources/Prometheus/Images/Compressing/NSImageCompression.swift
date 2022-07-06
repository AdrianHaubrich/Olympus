//
//  NSImageCompression.swift
//  
//
//  Created by Adrian Haubrich on 06.07.22.
//

import Foundation

#if canImport(AppKit)
import AppKit

extension NSImage {
    func compressUnderMegaBytes(megabytes: CGFloat) -> NSImage? {

        var compressionRatio = 1.0
        guard let tiff = self.tiffRepresentation, let imageRep = NSBitmapImageRep(data: tiff) else { return nil }
        var compressedData = imageRep.representation(using: .jpeg, properties: [.compressionFactor : compressionRatio])
        if compressedData == nil { return self }
        while CGFloat(compressedData!.count) > megabytes * 1024 * 1024 {
            compressionRatio = compressionRatio * 0.9
            let newCompressedData = imageRep.representation(using: .jpeg, properties:  [.compressionFactor : compressionRatio])
            if compressionRatio <= 0.4 || newCompressedData == nil {
                break
            }
            compressedData = newCompressedData
        }
        return NSImage(data: compressedData!)
    }
}

#endif
