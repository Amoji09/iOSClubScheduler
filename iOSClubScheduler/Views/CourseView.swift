//
//  CourseView.swift
//  iOSClubScheduler
//
//  Created by Amogh Mantri on 4/10/22.
//

import SwiftUI

struct CourseView : View {
  @StateObject var model = APIModel.shared
  @Binding var courses: [Course]
  let refreshAction: ()->Void
  var body: some View {
    if(model.progress == 1.0){
      NavigationView {
        VStack{
          HStack {
            Text("GT Courses")
              .font(.system(size: 30, weight: .semibold, design: .default))
            Spacer()
          }.padding(.horizontal,12)
          Divider()
          HStack {
            
            Button(action: {
              refreshCourses()
            }) {
              Image(systemName: "goforward")
                .padding(7).foregroundColor(Color.white).background(Color.blue).clipShape(Circle()).frame(width: 8, height: 8)
            }.padding().padding(.leading, 20)
            
            Spacer()
            NavigationLink(destination: FilterMenuView()) {
              Image(systemName: "magnifyingglass").padding(7).foregroundColor(Color.white).background(Color.blue).clipShape(Circle()).frame(width: 8, height: 8)
            }.padding().padding(.trailing, 20)
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
          }
        }
        
      }
    } else {
      ProgressView(value: model.progress).progressViewStyle(GaugeProgressStyle()).frame(width: 50, height: 50)
        .contentShape(Rectangle())
    }
  }
  
  func refreshCourses() {
    refreshAction()
  }
}


struct CourseDetailView: View {
  let course: Course
  
  var body: some View {
    VStack{
      HStack {
        Text(course.fullname)
          .font(.system(size: 30, weight: .semibold, design: .default))
        Spacer()
      }.padding(EdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 0))
      Divider()
      
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
      ScrollView{
        VStack{
          ForEach(course.sections ?? []) { section in
            SectionView(section: section).padding()
          }
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
    }.padding().background(Color.blue).cornerRadius(10)
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


struct GaugeProgressStyle: ProgressViewStyle {
  var strokeColor = Color.blue
  var strokeWidth = 6.0
  
  func makeBody(configuration: Configuration) -> some View {
    let fractionCompleted = configuration.fractionCompleted ?? 0
    
    return ZStack {
      Circle()
        .trim(from: 0, to: CGFloat(fractionCompleted))
        .stroke(strokeColor, style: StrokeStyle(lineWidth: CGFloat(strokeWidth), lineCap: .round))
        .rotationEffect(.degrees(-90))
    }
  }
}
