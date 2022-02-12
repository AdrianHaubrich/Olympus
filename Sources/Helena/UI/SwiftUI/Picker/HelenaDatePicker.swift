//
//  HelenaDatePicker.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 26.01.21.
//

import SwiftUI


/// A date picker that can be collapsed without a Form.
///
/// *Parameter* date: The Date bound to the picker.
///
/// *Parameter* minDate: The minimal value the date can have.
public struct HelenaDatePicker: View {
    
    // Data
    @Binding var date: Date
    var minDate: Date
    
    // Values
    var title: String
    var isRequired: Bool
    
    @State var showPicker = false
    
    
    // Init
    public init(date: Binding<Date>, minDate: Date? = nil, title: String, isRequired: Bool? = nil) {
        self._date = date
        self.minDate = minDate ?? Date()
        self.title = title
        self.isRequired = isRequired ?? false
    }
    
    // Body
    public var body: some View {
        VStack {
            HStack {
                Text(title)
                    .helenaFont(type: .cardText)
                    .foregroundColor(Color.helenaText)
                Spacer()
                
                VStack {
                    if handleDate() == minDate && !isRequired {
                        Text("---")
                    } else {
                        Text(self.dateToString(self.date))
                        
                    }
                }
                .helenaFont(type: .cardText)
                .foregroundColor(!showPicker ? Color.helenaTextSmallAccent : Color.helenaTextAccent)
                
            }.onTapGesture {
                withAnimation(.easeInOut) {
                    self.showPicker.toggle()
                }
            }
            
            if showPicker {
                if #available(iOS 14.0, *) {
                    DatePicker(title, selection: $date, in: minDate...)
                        .labelsHidden()
                        .datePickerStyle(GraphicalDatePickerStyle())
                } else {
                    DatePicker(title, selection: $date, in: minDate...)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
            }
        }
    }
    
}

extension HelenaDatePicker {
    
    func handleDate() -> Date {
        if minDate > date {
            // date = minDate
            return minDate
        }
        return date
    }
    
    // TODO: Use Prometheus
    func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter.string(from: date)
    }
    
}
