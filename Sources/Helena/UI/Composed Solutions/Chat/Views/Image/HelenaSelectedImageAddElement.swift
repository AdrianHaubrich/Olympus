//
//  HelenaSelectedImageAddElement.swift
//  
//
//  Created by Adrian Haubrich on 14.11.21.
//

import SwiftUI

struct HelenaSelectedImageAddElement: View {
    
    let limit: Int
    var onSelection: (_ image: UIImage) -> ()
    
    var body: some View {
        HelenaPhotoPickerButton(self.limit, systemImage: "plus", onSelection: { image in
            self.onSelection(image)
        })
            .padding(.top, -8)
            .padding(10)
            .background {
                VisualEffects()
                    .clipShape(Circle())
            }
            .padding(5)
    }
    
}
