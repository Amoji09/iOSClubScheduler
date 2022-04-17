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
        NavigationView {
          VStack{
              List(Array(groupedCourses.keys), id : \.self ) { key in
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
                
                
            }
          }.listStyle(.grouped)
        }
        .navigationBarTitle(Text("Filtered Courses"))
    }
    
//    func displaySelectedCourses() -> [Course]{
//
//      //TODO: Modify for accounting for prerequisites
//      var coursesOut : [Course] = []
//      if(filterHum && filterSoc){
//        coursesOut += model.humanitiesCourses
//        coursesOut += model.socialCourses
//      }
//      else if(filterSoc){
//        coursesOut += model.socialCourses
//      }
//      else if(filterHum){
//        coursesOut += model.humanitiesCourses
//      }
//      else{
//        coursesOut = model.courses
//      }
//      return coursesOut
//    }
}
