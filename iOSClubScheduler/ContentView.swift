//
//  ContentView.swift
//  iOSClubScheduler
//
//  Created by Amogh Mantri on 2/17/22.
//

import SwiftUI

struct ContentView: View {
    var columns: [GridItem] = [GridItem(.flexible(minimum: 0, maximum: .infinity)), GridItem(.flexible(minimum: 0, maximum: .infinity))]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(FBModel.shared.courses) { course in
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
            .navigationBarTitle(Text("Georgia Tech courses"))
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


struct CourseDetailView: View {
    let course: Course
    
    var body: some View {
      VStack{
        Text(course.fullname)
        List(course.sections ?? []) { section in
          VStack{
            Text(section.crn)
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
