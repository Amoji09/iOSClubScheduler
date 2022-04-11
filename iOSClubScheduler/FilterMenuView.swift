//
//  FilterMenuView.swift
//  iOSClubScheduler
//
//  Created by Shreya Malpani on 4/10/22.
//

import Foundation

import SwiftUI

struct FilterMenuView : View {
    @StateObject var model = FBModel.shared
    
    var attributes = ["All", "Honors Program", "Humanities Requirement", "Low-cost $40 or undr req textbk", "No-cost $0 req'd textbooks", "Social Science Requirement", "Summer Online Course"]
    @State private var selectedAttribute = "Humanities Requirement"
    
//    var schools = model.groupedCourses.keys
//    @State private var selectedAttribute = "Humanities Requirement"
    
    var body: some View {
        VStack {
            // attribute selector
            VStack(alignment: .leading) {
                Text("Attributes")
                Picker("Selected Attributes", selection: $selectedAttribute) {
                    ForEach(attributes, id: \.self) {
                        Text($0)
                    }
                }
                Text("You selected: \(selectedAttribute)")
            }
            
            // school selector
        }
    }
}
