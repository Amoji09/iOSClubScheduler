//
//  ResultsView.swift
//  iOSClubScheduler
//
//  Created by Shreya Malpani on 4/10/22.
//

import Foundation

import SwiftUI

struct ResultsView : View {
    var groupedCourses : [String : [Course]]
    var body: some View {
        VStack{
            List(Array(groupedCourses.keys).sorted(), id : \.self ) { key in
                Section(header: Text(key)) {
                    ForEach(groupedCourses[key] ?? [], id: \.self) { course in
                        if (course.sections != nil ) {
                            NavigationLink(destination: CourseDetailView(course: course)){
                                HStack{
                                    Text(course.fullname)
                                }
                            }
                        }
                    }
                }
            }.listStyle(.grouped)
        }
        .navigationBarTitle(Text("Results"))
    }
}
