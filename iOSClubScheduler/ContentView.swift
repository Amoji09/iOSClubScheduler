//
//  ContentView.swift
//  iOSClubScheduler
//
//  Created by Amogh Mantri on 2/17/22.
//

import SwiftUI



struct ContentView: View {
  
  init(){
    UITableView.appearance().backgroundColor = .clear
  }
  
  @StateObject private var courseData = CourseStore()
  @StateObject private var prereqData = PrereqStore()
  @StateObject var model = FBModel.shared
  var body: some View{
    TabView{
      CourseView(courses: $courseData.courses) {
        CourseStore.refresh(courses: courseData.courses) { result in
          if case .failure(let error) = result {
            fatalError(error.localizedDescription)
          }
        }
      }.onAppear {
        CourseStore.load { result in
          switch result {
          case .failure(let error):
            fatalError(error.localizedDescription)
          case .success(let courses):
            courseData.courses = courses
          }
        }
        if model.groupedCourses.isEmpty {
          CourseStore.refresh(courses: courseData.courses) { result in
            if case .failure(let error) = result {
              fatalError(error.localizedDescription)
            }
          }
        }
      }
      .tabItem{
        Label("Courses",systemImage: "list.dash")
      }
      PrerequisiteMenuView(prereqs: $prereqData.prereqs) {
        PrereqStore.save(prereqs: prereqData.prereqs) { result in
          if case .failure(let error) = result {
            fatalError(error.localizedDescription)
          }
        }
      }.onAppear {
        PrereqStore.load { result in
          switch result {
          case .failure(let error):
            fatalError(error.localizedDescription)
          case .success(let prereqs):
            prereqData.prereqs = prereqs
              FBModel.shared.prerequisiteCodes = prereqs
          }
        }
      }
      .tabItem{
        Label("Prereqs", systemImage: "textformat")
      }
      CRNView()
        .tabItem{
          Label("Times", systemImage: "clock")
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

//struct PrerequisiteMenuView : View{
//  @StateObject var model = FBModel.shared
//  @State var input = ""
//  var body: some View{
//    VStack{
//      Text("Input Taken Classes")
//
//      TextField("Course CRN",text : $input).overlay(
//        RoundedRectangle(cornerRadius: 10)
//          .stroke(Color.black, lineWidth: 1).frame(width: 300, height: 30, alignment: .center)
//      ).padding()
//
//      Button("Add Taken Course") {
//        addPrereq()
//      }.padding().foregroundColor(Color.yellow).background(Color.blue).cornerRadius(10)
//
//      List {
//        ForEach(model.prerequisiteCodes, id : \.self){ code in
//          Text(code)
//        }
//      }
//    }
//    .padding()
//
//  }
//
//  func addPrereq(){
//    model.prerequisiteCodes.append(input)
//  }
//
//  func validateCode() -> Bool{
//    var parts = input.components(separatedBy: " ")
//    var school = String(parts[0])
//    var code = String(parts[1])
//
//    if(school.count != 2 || school.count != 3 || school.count != 4) {
//      return false
//    }
//    return true
//  }
//}


//struct CourseView : View{
//
//  //TODO: Make a gridview matching the tutorial where each row is a different filter(using the filtered course arrays from FBModel)
//
//
//  var columns: [GridItem] = [GridItem(.flexible(minimum: 0, maximum: .infinity)), GridItem(.flexible(minimum: 0, maximum: .infinity))]
//  @StateObject var model = FBModel.shared
//  @State var filterHum = false
//  @State var filterSoc = false
//
//  //TODO: boolean for if filter by meeting prerequisites is true
//  var body: some View {
//
//    NavigationView {
//      VStack{
//        Toggle(isOn: $filterHum) {
//          Text("Show Humanities")
//        }
//        Toggle(isOn: $filterSoc) {
//          Text("Show Social Sciences")
//        }
//        ScrollView {
//          LazyVGrid(columns: columns) {
//            ForEach(displaySelectedCourses()) { course in
//              //                Color.red
//              if course.sections != nil{
//                NavigationLink(destination: CourseDetailView(course: course) ){
//                  VStack {
//                    Text(course.school + " " + course.number)
//                      .foregroundColor(Color(uiColor: UIColor.systemBackground))
//                  }
//                  .padding()
//                  .background([Color.yellow, Color.green, Color.blue, Color.red].randomElement()!)
//                  .cornerRadius(16)
//                }
//              }
//              //                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 120)
//            }
//          }
//        }
//      }
//    }
//    .navigationBarTitle(Text("Georgia Tech courses"))
//  }
//
//
//  func displaySelectedCourses() -> [Course]{
//
//    //TODO: Modify for accounting for prerequisites
//    var coursesOut : [Course] = []
//    if(filterHum && filterSoc){
//      coursesOut += model.humanitiesCourses
//      coursesOut += model.socialCourses
//    }
//    else if(filterSoc){
//      coursesOut += model.socialCourses
//    }
//    else if(filterHum){
//      coursesOut += model.humanitiesCourses
//    }
//    else{
//      coursesOut = model.courses
//    }
//    return coursesOut
//  }
//}

//struct CourseDetailView: View {
//  let course: Course
//
//  var body: some View {
//    VStack{
//      Text(course.fullname)
//      if let attribute = course.course_attributes{
//        Text(attribute)
//      }
//      List(course.sections ?? []) { section in
//        SectionView(section: section)
//      }
//    }
//  }
//}


//struct SectionView : View{
//  let section : SectionModel
//  var body : some View{
//    VStack{
//      Text(section.crn)
//      if let meetings = section.meetings{
//        ForEach(meetings, id : \.self){ meeting in
//          MeetingView(meeting: meeting)
//        }
//      }
//    }
//  }
//}
//
//struct MeetingView : View{
//  let meeting : Meeting
//  var body : some View {
//    VStack{
//      List(meeting.instructors ?? [], id: \.self){ instructor in
//        Text(instructor)
//      }
//      HStack{
//        if let days = meeting.days{
//          Text(days)
//        }
//        Spacer()
//        if let time = meeting.time{
//          Text(time)
//        }
//
//
//      }
//      if let location = meeting.location{
//        Text(location)
//      }
//    }
//  }
//}


struct CRNView : View{
  @StateObject var model = FBModel.shared
  @State var input = ""
  var body: some View{
    VStack{
      Text("Input Current Schedule")
      
      TextField("Course CRN",text : $input).overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(Color.black, lineWidth: 1).frame(width: 300, height: 30, alignment: .center)
      ).padding()
      
      Button("Add Course") {
        addTime()
      }.padding().foregroundColor(Color.yellow).background(Color.blue).cornerRadius(10)
      
      List {
        ForEach(model.userCourses, id : \.self){ userCourse in
          Text(userCourse.course).foregroundColor(userCourse.infoFound ? Color.green : Color.red)
        }
      }
      
      List {
        ForEach(model.noConflictCourses, id : \.self){ course in
          Text(course.fullname)
        }
      }
    }
    .padding()
    
  }
  
  func addTime(){
    model.searchTime(crn: input)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
