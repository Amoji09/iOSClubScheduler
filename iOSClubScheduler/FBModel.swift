//
//  FBModel.swift
//  iOSClubScheduler
//
//  Created by Amogh Mantri on 2/17/22.
//

import Foundation


/*
 import UIKit
 import Foundation

 let json = """
 [
     {
         "identifier": "COA 8843",
         "prerequisites": {
             "type": "and",
             "courses": [
                 {
                     "type": "or",
                     "courses": [
                         "CHEM 1212K",
                         "CHEM 1312",
                         "CHEM 1313",
                         "CHEM 2211"
                     ]
                 },
                 "CHEM 2311",
                 {
                     "type": "or",
                     "courses": [
                         "CHEM 2312",
                         "CHEM 2313"
                     ]
                 }
             ]
         }
     }
 ]
 """.data(using: .utf8)!

 // This code fails for more than one level of nesting
 struct CourseInformation: Decodable {
     let className: String
     // add all fields
     let prereq: Prerequisite

     enum CodingKeys: String, CodingKey {
         case className = "identifier"
         case prereq = "prerequisites"
     }
 }

 struct Prerequisite: Decodable {
     let type: String
     let courseList: MixedObjectCourseList
     
     enum CodingKeys: String, CodingKey {
         case type = "type"
         case courseList = "courses"
     }
 }

 struct MixedObjectCourseList: Decodable {
     var objects: [ObjectType] = []
     
     var flatten: [ObjectType] {
         var flatPrereqs: [ObjectType] = []
         for prereq in self.objects {
             switch (prereq) {
             case .innerItem(let innerItem):
                 if innerItem.innerType == "and" {
                     innerItem.innerCourseList.map {
                         flatPrereqs.append(ObjectType.course($0))
                     }
                 } else if innerItem.innerType == "or" {
                     flatPrereqs.append(ObjectType.innerItem(innerItem))
                 }
             case .course(_):
                 flatPrereqs.append(prereq)
             }
         }
         return flatPrereqs
     }
     
     init(from decoder: Decoder) throws {
         var container = try decoder.unkeyedContainer()
         while !container.isAtEnd {
             if let x = try? container.decodeIfPresent(String.self) {
                 objects.append(.course(x))
             } else if let x = try? container.decodeIfPresent(InnerItem.self) {
                 objects.append(.innerItem(x))
             } else {
                 throw DecodingError.typeMismatch(Prerequisite.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "courses[] contains item that is not a course, like ECE 2020 or another list of courses, like {{type : or}, {courses : [ECE 2020, ECE 3020]}}"))
             }
         }
     }
 }
         
 struct InnerItem: Decodable {
     let innerType: String
     let innerCourseList: [String]
             
     enum CodingKeys: String, CodingKey {
         case innerType = "type"
         case innerCourseList = "courses"
     }
 }
     
 enum ObjectType {
     case course(String)
     case innerItem(InnerItem)
 }

 let decoder = JSONDecoder()
 let payload = try decoder.decode([CourseInformation].self, from: json)
 let prereqs = payload[0].prereq
 var flatPrereqs: [ObjectType] = []
 for prereq in prereqs.courseList.objects {
     switch (prereq) {
     case .innerItem(let innerItem):
         flatPrereqs.append(prereqs.courseList.flatten( [ObjectType](innerItem.innerCourseList)))
     case .course(let course):
         flatPrereqs.append(prereq)
     }
 }
 print(flatPrereqs)



 
 
 
 */



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

struct Prerequisites: Decodable, Hashable {
  let type : String
  //let courses : [String]
}


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
  
  
//  func meetsPrereq(taken : [String]) -> Bool {
//    if(prerequisites.courses is [String]) {
//      if(prerequisites.type == "and"){
//        for i in 0..<prerequisites.courses
//      }
//      else if(Prerequisites.type == "or") {
//
//      }
//
//    }
//  }
}

class FBModel: ObservableObject {
    @Published var courses: [Course] = []
    var humanitiesCourses : [Course] {
      courses.filter{$0.course_attributes != nil && $0.course_attributes == "Humanities Requirement"}
    }
  var socialCourses : [Course] {
    courses.filter{$0.course_attributes != nil && $0.course_attributes == "Social Science Requirement"}
  }
  
  @Published var prerequisiteCodes : [String] = []
  
  //@published var userPrereqs
    static let shared = FBModel()
    
    func loadCourses() {
        let url = URL(string: "https://oscartracker.herokuapp.com/testCourses/100/")!
        let data = try! Data(contentsOf: url)
        let courses = try! JSONDecoder().decode([Course].self, from: data)
        self.courses = courses
    }
    
}
