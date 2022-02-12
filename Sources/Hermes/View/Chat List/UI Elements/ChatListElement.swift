//
//  ChatListElement.swift
//  
//
//  Created by Adrian Haubrich on 20.10.21.
//

import SwiftUI
import Helena

struct ChatListElement: View {
    
    let title: String
    let description: String?
    
    // Body
    var body: some View {
        HelenaCard {
            VStack(alignment: .leading) {
                Text(self.title)
                    .helenaFont(type: .cardTitle)
                
                Text(self.description ?? "")
                    .helenaFont(type: .cardSmall)
                    .foregroundColor(Color.helenaTextSmallAccent)
                
                HStack {
                    Spacer()
                }
            }.padding()
        }
    }
}

/*struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}*/
