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
    @State var selectedAttribute = "All"
    @State var selectedSchool = "All"
    @State var schoolsList : [String] = []
    @State private var satisfiesPrereqs = false
    @State private var fitsSchedule = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Filter Courses").font(.system(size: 40)).padding(.leading, 20)
            
            // attribute selector
            HStack{
                Text("Select Attribute:")
                Picker("Selected Attributes", selection: $selectedAttribute) {
                    ForEach(attributes, id: \.self) {
                        Text($0)
                    }
                }
            }.padding([.leading, .trailing], 20)
            
//            VStack(alignment: .leading) {
//                HStack{
//                    Text("Select Attribute:")
//                    Picker("Selected Attributes", selection: $selectedAttribute) {
//                        ForEach(attributes, id: \.self) {
//                            Text($0)
//                        }
//                    }
//                }
//                Text("You selected: \(selectedAttribute)")
//            }.padding(20)
            
            // school selector
            HStack{
                Text("Select School:")
                Picker("Selected School", selection: $selectedSchool) {
                    ForEach(schoolsList, id: \.self) {
                        Text($0)
                    }
                }
            }.padding([.leading, .trailing], 20).onAppear(perform: {
                schoolsList = Array(model.groupedCourses.keys)
                schoolsList.append("All")
            })
//            VStack(alignment: .leading) {
//                HStack{
//                    Text("Select School:")
//                    Picker("Selected School", selection: $selectedSchool) {
//                        ForEach(schoolsList, id: \.self) {
//                            Text($0)
//                        }
//                    }
//                }
//                Text("You selected: \(selectedSchool)")
//            }.padding(20).onAppear(perform: {
//                schoolsList = Array(model.groupedCourses.keys)
//                schoolsList.append("All")
//            })
            
            
            // satisfies prereqes toggle
            Toggle("Satisfied Prereqs", isOn: $satisfiesPrereqs).padding([.top, .leading, .trailing], 20)
            
            // fits with schedule toggle
            Toggle("Fit Schedule", isOn: $fitsSchedule).padding([.leading, .trailing], 20)
            
            // search button
            NavigationLink(destination: ResultsView(groupedCourses: filterCourses(attribute: selectedAttribute, school: selectedSchool, satisfiesPrereqs: satisfiesPrereqs, fitsSchedule: fitsSchedule))) {
                Text("Search")
            }.padding(20)
        }.padding(20)
    }
    
    func filterCourses(attribute: String, school: String, satisfiesPrereqs: Bool, fitsSchedule: Bool) -> [String : [Course]] {
        var filteredCourses = model.courses.filter{$0.sections != nil}
        if (attribute != "All") {
            filteredCourses = filteredCourses.filter{$0.course_attributes == attribute}
        }
        if (school != "All") {
            filteredCourses = filteredCourses.filter{$0.school == school}
        }
        if (fitsSchedule) {
            filteredCourses = filteredCourses.filter{model.checkNoOverlap(userCourses: model.userCourses, course: $0)}
        }
        
        let groupedCourses = Dictionary(grouping:filteredCourses){$0.school}
        return groupedCourses
    }
}


struct FilterView_Previews : PreviewProvider {
    static var previews: some View {
        FilterMenuView()
    }
}
