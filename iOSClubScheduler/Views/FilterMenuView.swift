//
//  FilterMenuView.swift
//  iOSClubScheduler
//
//  Created by Shreya Malpani on 4/10/22.
//

import Foundation

import SwiftUI

struct FilterMenuView : View {
    @StateObject var model = APIModel.shared
    var attributes = ["All", "Honors Program", "Humanities Requirement", "Low-cost $40 or undr req textbk", "No-cost $0 req'd textbooks", "Social Science Requirement", "Summer Online Course"]
    @State var selectedAttribute = "All"
    @State var selectedSchool = "All"
    @State var schoolsList : [String] = []
    @State private var satisfiesPrereqs = false
    @State private var fitsSchedule = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("Select Attribute:")
                Picker("Selected Attributes", selection: $selectedAttribute) {
                    ForEach(attributes, id: \.self) {
                        Text($0)
                    }
                }
            }.padding([.leading, .trailing], 20)
            HStack{
                Text("Select School:")
                Picker("Selected School", selection: $selectedSchool) {
                  ForEach(schoolsList, id: \.self) {
                        Text($0)
                    }
                }
            }.padding([.leading, .trailing], 20).onAppear(perform: {
                schoolsList = Array(model.groupedCourses.keys)
                schoolsList = schoolsList.sorted()
                schoolsList.insert("All", at: 0)
            })
          
            // satisfies prereqes toggle
            Toggle("Satisfied Prerequisites", isOn: $satisfiesPrereqs).padding([.top, .leading, .trailing], 20)
            
            // fits with schedule toggle
            Toggle("Fits Current Schedule", isOn: $fitsSchedule).padding([.leading, .trailing], 20)
            
            // search button
            NavigationLink(destination: ResultsView(groupedCourses: filterCourses(attribute: selectedAttribute, school: selectedSchool, satisfiesPrereqs: satisfiesPrereqs, fitsSchedule: fitsSchedule))) {
                Text("Search")
            }.padding(20)
        }.padding(20)
        .navigationBarTitle(Text("Search Courses"))
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
        if(satisfiesPrereqs) {
          filteredCourses = model.prereqsMetCourses(inputCourses: filteredCourses)
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
