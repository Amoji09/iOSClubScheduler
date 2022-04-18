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
  @StateObject var model = APIModel.shared
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
              APIModel.shared.prerequisiteCodes = prereqs
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


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
