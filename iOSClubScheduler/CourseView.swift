//
//  CourseView.swift
//  iOSClubScheduler
//
//  Created by Amogh Mantri on 4/10/22.
//

import SwiftUI

struct CourseView : View{
  @StateObject var model = FBModel.shared
  @State var filterHum = false
  @State var filterSoc = false
  
  @Binding var courses: [Course]
  let refreshAction: ()->Void
  
  //TODO: boolean for if filter by meeting prerequisites is true
  var body: some View {
    NavigationView {
      VStack{
        HStack {
          
          Button(action: {
            refreshCourses()
          }) {
            Image(systemName: "goforward")
              .padding(7).foregroundColor(Color.white).background(Color.blue).clipShape(Circle()).frame(width: 8, height: 8)
          }.padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
          Text("All Courses")
          Spacer()
          NavigationLink(destination: FilterMenuView()) {
            Image(systemName: "magnifyingglass")
          }
        }
        List(Array(model.groupedCourses.keys).sorted(), id : \.self ) { key in
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
          }.listStyle(.grouped)
//          List(model.prereqsMetCourses, id : \.self ) { course in
//            Text(course.fullname)
//          }
        }
      }
    }
    .navigationBarTitle(Text("Georgia Tech courses"))
  }
  
  func refreshCourses() {
    refreshAction()
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
}


struct CourseDetailView: View {
    let course: Course
    
    var body: some View {
        VStack{
            Text(course.fullname)
            Spacer()
            HStack{
                Text("Attributes:")
                if let attribute = course.course_attributes{
                    let str = String(attribute)
                    let replaced = str.replacingOccurrences(of: "&amp;", with: "&")
                    Text(replaced)
                } else {
                    Text("None")
                }
            }
            
            List(course.sections ?? []) { section in
                VStack{
                    
                    SectionView(section: section)
                    Spacer()
                }
            }
        }
    }
}

struct SectionView : View{
    let section : SectionModel
    var body : some View{
        VStack{
            if let meetings = section.meetings{
                ForEach(meetings, id : \.self){ meeting in
                    MeetingView(meeting: meeting)
                }
            }
            Spacer()
            HStack{
                Spacer()
                Text("CRN: " + section.crn)
                Spacer()
            }
        }
    }
}

struct MeetingView : View{
    let meeting : Meeting
    var body : some View {
        
        VStack{
            Spacer()
            HStack{
                Text("Days: ")
                Spacer()
                if let days = meeting.days{
                    Text(days)
                } else {
                    Text("Not found")
                }
            }
            HStack{
                Text("Time: ")
                Spacer()
                if let time = meeting.time{
                    Text(time)
                } else {
                    Text("Not found")
                }
            }
            Spacer()
            
            HStack{
                Text("Location: ")
                Spacer()
                if let location = meeting.location{
                    Text(location).fixedSize(horizontal: false, vertical: true)
                } else {
                    Text("Not found")
                }
            }
            
            HStack{
                Text("Taught by: ")
                Spacer()
                if (meeting.instructors == nil) {
                    Text("Not found")
                } else {
                    List(meeting.instructors ?? [], id: \.self){ instructor in
                        Text(instructor)
                    }
                }
                
            }
            
            
        }
    }
}

struct CourseView_Previews: PreviewProvider {
    static var previews: some View {
        CourseView()
    }
}
