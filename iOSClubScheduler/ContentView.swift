//
//  ContentView.swift
//  iOSClubScheduler
//
//  Created by Amogh Mantri on 2/17/22.
//

import SwiftUI



struct ContentView: View {
  var body: some View{
    TabView{
      CourseView()
        .tabItem{
          Label("Courses",systemImage: "list.dash")
        }
      PrequisiteMenuView()
        .tabItem{
          Label("Prereqs", systemImage: "textformat")
        }
    }
  }
  
}


//"sections": [
//{
//"section_id": "A",
//"crn": "81031",
//"meetings": [
//{
//"time": "12:30 pm - 1:20 pm",
//"days": "MWF",
//"location": "Engr Science & Mech 202",
//"type": "Lecture*",
//"instructor": [
//"Yi-Hsien   Ho"
//]
//}
//],
//"instructors": [
//"Yi-Hsien   Ho"
//]
//}
//]

struct PrequisiteMenuView : View{
  @State var input = ""
  var body: some View{
    VStack{
    Text("Input Taken Classes")
      TextField("Course code",text : $input)
        .padding()
        .background(Color.gray)
        .cornerRadius(10)
      
      //TODO: Add a button that calls addPrereq with input
    }
    .padding()
  }
  
  func addPrereq(code : String){
    //TODO: Add code to some kind of [String]
    //the array should be in the model(FBModel)
  }
}


struct CourseView : View{
  
  //TODO: Make a gridview matching the tutorial where each row is a different filter(using the filtered course arrays from FBModel)
  
  
  var columns: [GridItem] = [GridItem(.flexible(minimum: 0, maximum: .infinity)), GridItem(.flexible(minimum: 0, maximum: .infinity))]
  @StateObject var model = FBModel.shared
  @State var filterHum = false
  @State var filterSoc = false
  
  //TODO: boolean for if filter by meeting prerequisites is true
  var body: some View {
    
    NavigationView {
      VStack{
        Toggle(isOn: $filterHum) {
          Text("Show Humanities")
        }
        Toggle(isOn: $filterSoc) {
          Text("Show Social Sciences")
        }
        ScrollView {
          LazyVGrid(columns: columns) {
            ForEach(displaySelectedCourses()) { course in
              //                Color.red
              if course.sections != nil{
                NavigationLink(destination: CourseDetailView(course: course) ){
                  VStack {
                    Text(course.school + " " + course.number)
                      .foregroundColor(Color(uiColor: UIColor.systemBackground))
                  }
                  .padding()
                  .background([Color.yellow, Color.green, Color.blue, Color.red].randomElement()!)
                  .cornerRadius(16)
                }
              }
              //                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 120)
            }
          }
        }
      }
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
  let section : Section
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
        if let location = meeting.location{
          Text(location)
        }
      }
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
