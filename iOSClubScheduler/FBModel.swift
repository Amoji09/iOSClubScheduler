
//
//  FBModel.swift
//  iOSClubScheduler
//
//  Created by Amogh Mantri on 2/17/22.
//

import Foundation

//"sections": [
//{
//"section_id": "A",
//"crn": "81031",
//"meetings": [
//  {
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

//TODO: Set up prerequisites struct that is decodable,hashable
//needs to support types of prerequisites
//after that support nested prerequisites
//hold array of course codes


struct Meeting: Decodable, Hashable{
  var days : String?
  var location : String?
  var instructors : [String]?
}


struct Section: Decodable, Hashable, Identifiable {
    
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
    var sections: [Section]?
    //TODO: Add prerequisites, might need to make optional since it's always not present
}

class FBModel: ObservableObject {
    @Published var courses: [Course] = []
    var humanitiesCourses : [Course] {
      courses.filter{$0.course_attributes != nil && $0.course_attributes == "Humanities Requirement"}
    }
  var socialCourses : [Course] {
    courses.filter{$0.course_attributes != nil && $0.course_attributes == "Social Science Requirement"}
  }
  //@published var userPrereqs
    static let shared = FBModel()
    
    func loadCourses() {
        let url = URL(string: "https://oscartracker.herokuapp.com/testCourses/100/")!
        let data = try! Data(contentsOf: url)
        let courses = try! JSONDecoder().decode([Course].self, from: data)
        self.courses = courses
    }
    
}
