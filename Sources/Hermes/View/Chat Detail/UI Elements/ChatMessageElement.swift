//
//  ChatMessageElement.swift
//  
//
//  Created by Adrian Haubrich on 20.10.21.
//

import SwiftUI
import Helena

struct ChatMessageElement: View {
    
    let senderName: String
    let text: String?
    let isUserOwner: Bool
    let uiImages: [UIImage]?
    
    // Body
    var body: some View {
        VStack(alignment: self.isUserOwner ? .trailing : .leading, spacing: 3) {
            Text(senderName)
                .font(.footnote)
                .foregroundColor(Color.gray)
            
            Text(text ?? "")
                .lineLimit(nil)
                .padding(8)
                .font(.body)
                .background(isUserOwner ? .green : .gray)
                .cornerRadius(8)
            
            if let images = self.uiImages {
                if images.count > 0 {
                    HelenaImageCollage(images.map { Image(uiImage: $0) }, showShadow: true)
                }
            }
            
            HStack {
                Spacer()
            }
        }
    }
}




/*struct ChatMessageElement_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageElement()
    }
}*/
