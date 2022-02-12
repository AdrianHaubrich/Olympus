//
//  HelenaImagesDetailView.swift
//  
//
//  Created by Adrian Haubrich on 14.11.21.
//

import SwiftUI
import Prometheus

// TODO: pass all images with index and show them all...
struct HelenaImagesDetailView: View {
    
    @Binding var isPresented: Bool
    let image: UIImage
    @State var isSharePresented = false
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color.black)
            
            HelenaZoomableScrollView {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            VStack {
                // Close
                HStack {
                    Spacer()
                    Image(systemName: "xmark")
                        .font(.system(size: 20))
                        .padding(10)
                        .background {
                            Circle()
                                .fill(Color.helenaBackgroundAccent)
                                .frame(width: 50, height: 50)
                        }
                        .onTapGesture {
                            self.isPresented.toggle()
                            
                        }
                }
                .padding()
                .padding(.top, 25)
                
                Spacer()
                
                // Share
                HStack {
                    Spacer()
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 20))
                        .padding(10)
                        .background {
                            Circle()
                                .fill(Color.helenaBackgroundAccent)
                                .frame(width: 50, height: 50)
                        }
                        .onTapGesture {
                            self.isSharePresented.toggle()
                            
                        }
                    
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
        }
        .foregroundColor(.helenaTextLight)
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $isSharePresented) {
            ActivityViewController(activityItems: [self.image])
        }
    }
    
}
