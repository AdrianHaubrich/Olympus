//
//  HelenaLinearStepProgressIndicator.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 26.01.21.
//

import SwiftUI


public struct HelenaLinearStepProgressIndicator: View {
    
    // Values
    var numberOfElements: Int
    @Binding var progress: CGFloat
    var showPercentage: Bool
    
    // Init
    public init(numberOfElements: Int, progress: Binding<CGFloat>, showPercentage: Bool? = nil) {
        self.numberOfElements = numberOfElements
        self._progress = progress
        self.showPercentage = showPercentage ?? false
    }
    
    public var body: some View {
        VStack {
            if showPercentage {
                Text(String(format: "%.0f", progress * 100) + "%")                
            }
            HStack {
                ForEach(0..<numberOfElements) { index in
                    if index < Int(progress * CGFloat(numberOfElements)) {
                        HelenaLinearStepProgressIndicatorStep(checked: true)
                    } else {
                        HelenaLinearStepProgressIndicatorStep()
                    }
                }
            }
        }
    }
    
}


struct HelenaLinearStepProgressIndicatorStep: View {
    
    var checked: Bool = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 6).fill(checked ? Color.helenaTextAccent : Color.helenaBackgroundSmallAccent)
            .frame(height: 10)
    }
    
}
