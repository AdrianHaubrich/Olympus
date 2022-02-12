//
//  HelenaCircularSlider.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 26.01.21.
//

import SwiftUI


public struct HelenaCircularSlider: View {
    
    @State var size = UIScreen.main.bounds.width - 100
    @State var progress: CGFloat = 0
    @State var angle: Double = 0
    
    var validValues = Array(21...90) // [1.2, 1.3, 1.4, 1.5, 1.6]
    @State var selectedValue: Double = 31
    
    public init(validValues: [Int], preSelectedValue: Double) {
        self.validValues = validValues
        self.selectedValue = preSelectedValue
    }
    
    public var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color(.lightGray), style: StrokeStyle(lineWidth: 55, lineCap: .round, lineJoin: .round))
                    .frame(width: size, height: size)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color(.systemGreen), style: StrokeStyle(lineWidth: 55, lineCap: .butt))
                    .frame(width: size, height: size)
                    .rotationEffect(.init(degrees: -90))
                
                Circle()
                    .fill(Color(.lightGray))
                    .frame(width: 55, height: 55)
                    .offset(x: size / 2)
                    .rotationEffect(.init(degrees: -90))
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 55, height: 55)
                    .offset(x: size / 2)
                    .rotationEffect(.init(degrees: angle))
                    .gesture(DragGesture().onChanged(onDrag(value:)))
                    .rotationEffect(.init(degrees: -90))
                
                // Text(String(format: "%.1f", selectedValue))
                Text("\(selectedValue)")
                
            }
        }.onAppear {
            setStartValue(value: selectedValue)
        }
    }
    
    private func onDrag(value: DragGesture.Value) {
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        let radians = atan2(vector.dy - 27.5, vector.dx - 27.5)
        var angle = radians * 180 / .pi
        
        if angle < 0 {
            angle = 360 + angle
        }
        
        let progress = angle / 360
        
        // Select Value in Array
        selectValue(progress: progress)
        
        withAnimation(Animation.linear(duration: 0.15)) {
            self.progress = progress
            self.angle = Double(angle)
        }
    }
    
    private func selectValue(progress: CGFloat) {
        let segments: CGFloat = CGFloat(validValues.count - 1)
        let indexLimit: CGFloat = 100 / segments
        let index = Int(round((progress / indexLimit) * 100))
        selectedValue = Double(validValues[index])
    }
    
    private func setStartValue(value: Double) {
        
        // Transform value to progress
        if let index = validValues.firstIndex(of: Int(value)) {
            progress = CGFloat(index) / CGFloat(validValues.count)
            print(progress)
            
            withAnimation(Animation.linear(duration: 0.15)) {
                self.progress = CGFloat(progress)
                self.angle = Double(self.progress * 360)
            }
        }
        
    }
    
}


/*struct HelenaCircularSlider: View {
 
 @State var size = UIScreen.main.bounds.width - 100
 @State var progress: CGFloat = 0
 @State var angle: Double = 0
 
 var body: some View {
 VStack {
 ZStack {
 Circle()
 .stroke(Color(.lightGray), style: StrokeStyle(lineWidth: 55, lineCap: .round, lineJoin: .round))
 .frame(width: size, height: size)
 
 Circle()
 .trim(from: 0, to: progress)
 .stroke(Color(.systemGreen), style: StrokeStyle(lineWidth: 55, lineCap: .butt))
 .frame(width: size, height: size)
 .rotationEffect(.init(degrees: -90))
 
 Circle()
 .fill(Color(.lightGray))
 .frame(width: 55, height: 55)
 .offset(x: size / 2)
 .rotationEffect(.init(degrees: -90))
 
 Circle()
 .fill(Color.white)
 .frame(width: 55, height: 55)
 .offset(x: size / 2)
 .rotationEffect(.init(degrees: angle))
 .gesture(DragGesture().onChanged(onDrag(value:)))
 .rotationEffect(.init(degrees: -90))
 
 //example from 0 to 100%
 Text(String(format: "%.0f", progress * 100 /*>= 50 ? round(progress * 10) / 100 : progress * 100*/) + "%")
 // Text(String(format: "%f", round(progress * 10) / 10))
 
 // Calculate progress from 0.21 to 90
 // Text(String(format: "%.0f", calculateProgressInRange(progress: progress) * 100) + "%")
 
 }
 }.onAppear {
 setStartValue(value: 0.32)
 }
 }
 
 func onDrag(value: DragGesture.Value) {
 let vector = CGVector(dx: value.location.x, dy: value.location.y)
 let radians = atan2(vector.dy - 27.5, vector.dx - 27.5)
 var angle = radians * 180 / .pi
 
 if angle < 0 {
 angle = 360 + angle
 }
 
 let progress = angle / 360
 
 // "10 Steps"
 /*if progressInRange >= 0.5 {
 // Round & update angle
 progress = round(progress * 10) / 10
 angle = progress * 360
 }
 
 if progressInRange < 0.21 {
 progress = 0.21 * (10/9)
 angle = progress * 360
 }*/
 
 // Boundaries
 /*let minValue: CGFloat = 0.21
 let maxValue: CGFloat = 0.9
 
 if progress < minValue {
 progress = minValue
 angle = progress * 360
 } else if progress > maxValue {
 progress = maxValue
 angle = progress * 360
 }*/
 
 // Calc with Array
 let validValues = [1.2, 1.3, 1.4, 1.5, 1.6]
 let segments: CGFloat = CGFloat(validValues.count - 1)
 let indexLimit: CGFloat = 100 / segments
 let index = Int(round((progress / indexLimit) * 100))
 print("Value: \(validValues[index])")
 
 withAnimation(Animation.linear(duration: 0.15)) {
 self.progress = progress
 self.angle = Double(angle)
 }
 }
 
 
 func setStartValue(value: CGFloat) {
 withAnimation(Animation.linear(duration: 0.15)) {
 progress = value
 angle = Double(progress * 360)
 }
 }
 
 /*func calculateProgressInRange(progress: CGFloat) -> CGFloat {
 return progress / (10/9)
 }*/
 
 }*/
