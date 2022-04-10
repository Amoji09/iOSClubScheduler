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

//TODO: Custom tree

struct MeetingTime {
  let days : String
  let time : String
    
}

struct CRN : Identifiable, Hashable{
  var id : String {
    return code
  }
  let code : String
  let infoFound : Bool
}

struct Prerequisites: Decodable, Hashable {
  let type : String
  //let courses :
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
  @Published var timeCRNS : [CRN] = []
  @Published var times : [MeetingTime] = []
  //@published var userPrereqs
    static let shared = FBModel()
    
    func loadCourses() {
        let url = URL(string: "https://oscartracker.herokuapp.com/testCourses/100/")!
        let data = try! Data(contentsOf: url)
        let courses = try! JSONDecoder().decode([Course].self, from: data)
        self.courses = courses
    }
    
    
    /*
    "meetings": [
     {
         "time": "2:00 pm - 3:15 pm",
         "days": "TR",
         "location": "Instr Center 111",
         "type": "Lecture*",
         "instructor": ["Ling   Liu"]
     }
    ]
     
   
     func (MeetingTime a, MeetingTime b)
    if a and b days do not match, then no issue
     if they match
      parse the time(12:30 pm - 1:20 pm), parse (b time)
     check if they overlap, and if they do return false

     */
    
    func checkOverLap(_ x: MeetingTime, y: MeetingTime) -> Bool {
        if (x == nil || y == nil) {
            return false
        }
        let xDays = Array(x.days)
        let yDays = Array(y.days)
        for xDay in xDays {
            for yDay in yDays { // "12:30 pm - 1:45 pm"
                // Obtain the hour and minutes of x, obtain just the prefix of the hour if its just one char
                var xTimeHour = x.time.prefix(2)
                if (xTimeHour.suffix(1) == ":") {
                    xTimeHour = xTimeHour.prefix(1)
                }
                
                // Obtain the hour and minutes of y, same with x, make sure that colon is not assigned
                var xTimeMin = Array(y.time)[3] + Array(x.time)[4]
                var yTimeHour = y.time.suffix(2)
            }
        }
        return false;
    }
    
    
    func searchTime(crn : String) {
        for course in courses {
          if let sections = course.sections {
            for section in sections{
              if(section.crn == crn){
                if let meetings = section.meetings{
                  for meeting in meetings{
                    if let days = meeting.days, let time = meeting.time{
                      print(days)
                      print(time)
                      times.append(MeetingTime(days: days, time: time))
                      timeCRNS.append(CRN(code: crn, infoFound: true))
                      return
                    }
                  }
                }
              }
            }
          }
        }
        print("failed")
        timeCRNS.append(CRN(code: crn, infoFound: false))
        return
    }
}
