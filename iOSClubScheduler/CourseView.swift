//
//  CourseView.swift
//  iOSClubScheduler
//
//  Created by Amogh Mantri on 4/10/22.
//

import SwiftUI

struct CourseView : View{
  
  //TODO: Make a gridview matching the tutorial where each row is a different filter(using the filtered course arrays from FBModel)
  
  
  //var columns: [GridItem] = [GridItem(.flexible(minimum: 0, maximum: .infinity)), GridItem(.flexible(minimum: 0, maximum: .infinity))]
  @StateObject var model = FBModel.shared
  @State var filterHum = false
  @State var filterSoc = false
  
  //TODO: boolean for if filter by meeting prerequisites is true
  var body: some View {
    
    NavigationView {
      VStack{
          HStack {
              Text("All Courses")
              Spacer()
              NavigationLink(destination: FilterMenuView()) {
                  Image(systemName: "magnifyingglass")
              }
          }
        List(Array(model.groupedCourses.keys), id : \.self ) { key in
          Section(header: Text(key)) {
              ForEach(model.groupedCourses[key] ?? [], id: \.self) { course in
                  if (course.sections != nil) {
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
    .navigationBarTitle(Text("Georgia Tech courses"))
  }
  
  
  func displaySelectedCourses() -> [Course]{
    
    //TODO: Modify for accounting for prerequisites
    var coursesOut : [Course] = []
    if(filterHum && filterSoc){
      coursesOut += model.humanitiesCourses
      coursesOut += model.socialCourses
    }
    else if(filterSoc){
      coursesOut += model.socialCourses
    }
    else if(filterHum){
      coursesOut += model.humanitiesCourses
    }
    else{
      coursesOut = model.courses
    }
    return coursesOut
  }
}

struct CourseDetailView: View {
  let course: Course
  
  var body: some View {
    VStack{
      Text(course.fullname)
      if let attribute = course.course_attributes{
        Text(attribute)
      }
      List(course.sections ?? []) { section in
        SectionView(section: section)
      }
    }
  }
}


struct SectionView : View{
  let section : SectionModel
  var body : some View{
    VStack{
      Text(section.crn)
      if let meetings = section.meetings{
        ForEach(meetings, id : \.self){ meeting in
          MeetingView(meeting: meeting)
        }
      }
    }
  }
}

struct MeetingView : View{
  let meeting : Meeting
  var body : some View {
    VStack{
      List(meeting.instructors ?? [], id: \.self){ instructor in
        Text(instructor)
      }
      HStack{
        if let days = meeting.days{
          Text(days)
        }
        Spacer()
        if let time = meeting.time{
          Text(time)
        }
        
        
      }
      if let location = meeting.location{
        Text(location)
      }
    }
  }
}

struct CourseView_Previews: PreviewProvider {
  static var previews: some View {
    CourseView()
  }
}
