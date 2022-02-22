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
                        NavigationLink(destination: CourseDetailView(course: course) ){
                            VStack {
                                Text(course.school + " " + course.number)
                                    .foregroundColor(Color(uiColor: UIColor.systemBackground))
                            }
                            .padding()
                            .background([Color.yellow, Color.green, Color.blue, Color.red].randomElement()!)
                            .cornerRadius(16)
                        }
    //                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 120)
                    }
                }
            }
            .navigationBarTitle(Text("Georgia Tech courses"))
        }
    }
}

struct CourseDetailView: View {
    let course: Course
    
    var body: some View {
        List(course.sections ?? []) { section in
            Text(section.crn)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
