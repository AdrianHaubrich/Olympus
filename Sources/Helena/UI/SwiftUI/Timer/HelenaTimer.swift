//
//  HelenaTimer.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 26.01.21.
//

import SwiftUI


public struct HelenaTimer: View {
    
    // Values
    @State var timeInterval: TimeInterval
    @State var dateInterval: DateInterval
    
    // Timer
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Actions
    var onEnd: () -> ()
    
    // Init
    public init(duration: Double, onEnd: @escaping () -> ()) {
        self.onEnd = onEnd
        self._timeInterval = State(initialValue: duration)
        self._dateInterval = State(initialValue: DateInterval(start: Date(), duration: duration))
    }
    
    // Body
    public var body: some View {
        
        VStack {
            if !timeInterval.isLess(than: 0) {
                Text("\(timeInterval.format(using: [.hour, .minute, .second])!)")
                    .font(.custom("Helvetica Neue", size: 80))
                    .foregroundColor(.white)
                    .onReceive(timer, perform: { input in
                        timeInterval = Date().distance(to: dateInterval.end)
                        
                        // End
                        if timeInterval.isLessThanOrEqualTo(0) {
                            onEnd()
                        }
                    })
            } else {
                Text("Done")
                    .font(.custom("Helvetica Neue", size: 80))
                    .foregroundColor(.white)
            }
        }
        
    }
    
}


extension TimeInterval {
    func format(using units: NSCalendar.Unit) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .dropLeading
        
        return formatter.string(from: self)
    }
}
