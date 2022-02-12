//
//  HelenaSwitchButton.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 26.01.21.
//

import SwiftUI


/// An alternative to SwiftUI's SegmentedControl-Picker.
///
/// Only supports exactly two buttons.
///
/// - WARNING: This UI-Element is badly programmed & in a very early state.
/// Consider carefully if you really want to use it.
public struct HelenaSwitchButtonView: View {
    
    // Values
    @State var isFirstSelected: Bool
    @State var isSecondSelected: Bool
    
    var firstTitle: String
    var firstSystemImageName: String
    
    var secondTitle: String
    var secondSystemImageName: String
    
    // Actions
    var refreshAction: (_ isFirst: Bool) -> Void
    var switchDataAction: () -> Void
    
    // Init
    public init(isFirstSelected: Bool, isSecondSelected: Bool, firstTitle: String, firstSystemImageName: String, secondTitle: String, secondSystemImageName: String, refreshAction: @escaping (_ isFirst: Bool) -> (), switchDataAction: @escaping () -> ()) {
        self._isFirstSelected = State(initialValue: isFirstSelected)
        self._isSecondSelected = State(initialValue: isSecondSelected)
        self.firstTitle = firstTitle
        self.firstSystemImageName = firstSystemImageName
        self.secondTitle = secondTitle
        self.secondSystemImageName = secondSystemImageName
        self.refreshAction = refreshAction
        self.switchDataAction = switchDataAction
    }
    
    // Body
    public var body: some View {
        HStack(spacing: 0) {
            HelenaSwitchButton(selected: $isFirstSelected, title: firstTitle, systemImageName: firstSystemImageName, action: {
                self.tapped(is: self.isFirstSelected)
            })
            
            HelenaSwitchButton(selected: $isSecondSelected, title: secondTitle, systemImageName: secondSystemImageName, action: {
                self.tapped(is: self.isSecondSelected)
            })
        }
    }
    
}

extension HelenaSwitchButtonView {
    private func tapped(is selected: Bool) {
        if selected {
            // Reload Data
            refreshAction(self.isFirstSelected)
        } else {
            // Toggle
            toggleSelectedButton()
            
            // Change Data
            switchDataAction()
        }
    }
    
    private func toggleSelectedButton() {
        self.$isFirstSelected.wrappedValue.toggle()
        self.$isSecondSelected.wrappedValue.toggle()
    }
}


struct HelenaSwitchButton: View {
    
    // Values
    @Binding var selected: Bool
    
    var title: String
    var systemImageName: String
    
    // Action
    var action: () -> Void
    
    var body: some View {
        ZStack {
            Button(action: {
                self.action()
            }) {
                HStack(alignment: .center) {
                    Image(systemName: systemImageName)
                        .foregroundColor(selected ? Color.helenaTextLight : Color.helenaText)
                    Text(title + " ")
                        .foregroundColor(selected ? Color.helenaTextLight : Color.helenaText)
                }
                .frame(maxWidth: selected ? .infinity : nil)
            }
        }
        .padding(6)
        .background(selected ? Color.helenaTextAccent : Color.helenaBackgroundSmallAccent)
        .cornerRadius(HelenaLayout.cornerRadius)
        .padding([.leading, .trailing], 4)
        .animation(.spring(), value: selected)
        
    }
    
}
