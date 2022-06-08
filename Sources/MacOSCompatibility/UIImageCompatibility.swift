//
//  UIImageCompatibility.swift
//  
//
//  Created by Adrian Haubrich on 08.06.22.
//

// Either put this in a separate file that you only include in your macOS target or wrap the code in #if os(macOS) / #endif

#if os(macOS)
import Cocoa

// Step 1: Typealias UIImage to NSImage
typealias UIImage = NSImage

// Step 2: You might want to add these APIs that UIImage has but NSImage doesn't.
extension NSImage {
    var cgImage: CGImage? {
        var proposedRect = CGRect(origin: .zero, size: size)

        return cgImage(forProposedRect: &proposedRect,
                       context: nil,
                       hints: nil)
    }

    convenience init?(named name: String) {
        self.init(named: Name(name))
    }
}

// Step 3: Profit - you can now make your model code that uses UIImage cross-platform!
struct User {
    let name: String
    let profileImage: UIImage
}
#endif
