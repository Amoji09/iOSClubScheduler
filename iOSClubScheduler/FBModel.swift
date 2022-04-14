//
//  FBModel.swift
//  iOSClubScheduler
//
//  Created by Amogh Mantri on 2/17/22.
//

import Foundation

struct CRN : Identifiable, Hashable{
  var id : String {
    return code
  }
  let code : String
  let infoFound : Bool
}


struct Meeting: Decodable, Hashable{
  var days : String?
  var time : String?
  var location : String?
  var instructors : [String]?
  
  func checkOverlap(time : String) -> Bool{
    return false
  }
}


struct SectionModel: Decodable, Hashable, Identifiable {
  
  var id: String {
    return crn
  }
  
  let section_id: String
  let crn: String
  var meetings : [Meeting]?
}


struct Course: Decodable, Hashable, Identifiable {
  var id: String {
    return self._id
  }
  
  let _id: String
  let semester: String
  let fullname: String
  let school: String
  let course_attributes: String?
  let number: String
  var sections: [SectionModel]?
  var prerequisites: Node?
}

class FBModel: ObservableObject {
  @Published var courses: [Course] = []
  var humanitiesCourses : [Course] {
    courses.filter{$0.course_attributes != nil && $0.course_attributes == "Humanities Requirement"}
  }
  var socialCourses : [Course] {
    courses.filter{$0.course_attributes != nil && $0.course_attributes == "Social Science Requirement"}
  }
  
  var groupedCourses : [String : [Course]] = [:]
  
  //  @Published var timeCRNS : [CRN] = []
  //  @Published var times : [MeetingTime] = []
  //@published var userPrereqs
  static let shared = FBModel()
  
  func loadCourses() {
    let url = URL(string: "https://oscartracker.herokuapp.com/testCourses/100/")!
    let data = try! Data(contentsOf: url)
    let courses = try! JSONDecoder().decode([Course].self, from: data)
    self.courses = courses
    for course in courses {
      course.prerequisites?.printNode()
    }
    self.groupedCourses = Dictionary(grouping:self.courses){$0.school}
    print(groupedCourses)
  }
}
