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

struct UserCourse : Identifiable, Hashable{
  var id : String {
    return crn
  }
  let crn : String
  let course : String
  let section : SectionModel
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
  
  var noConflictCourses : [Course]
  {
    courses.filter{checkNoOverlap(userCourses: userCourses, course: $0)}
  }
  
  @Published var prerequisiteCodes : [String] = []
  @Published var userCourses : [UserCourse] = []
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
  
  func checkNoOverlap(userCourses: [UserCourse], course: Course) -> Bool {
    if let sections = course.sections {
      for section in sections{
        if let meetings = section.meetings{
          for meeting in meetings{
            if let days = meeting.days, let time = meeting.time{
              var noOverlapWithCourses = true
              for userCourse in userCourses {
                if(userCourse.infoFound){
                  let dateFormatter = DateFormatter()
                  let dayUser = userCourse.section.meetings![0].days!
                  let dayCourse = days
                  let timeUser = userCourse.section.meetings![0].time
                  let timeCourse = time
                  
                  let userDays = Array(dayUser)
                  var noMatches = true
                  for day in userDays{
                    if(dayCourse.contains(day)){
                      noMatches = false
                    }
                  }
                  if(!noMatches){
                    dateFormatter.dateFormat = "hh:mm a"
                    var userTime = timeUser!.split(separator: "-").map( {
                      $0.trimmingCharacters(in: .whitespacesAndNewlines)
                    })
                    
                    if(userTime[0].count != 8) {
                      userTime[0] = "0" + userTime[0]
                      print(userTime[0])
                    }
                    if(userTime[1].count != 8) {
                      userTime[1] = "0" + userTime[1]
                      print(userTime[1])
                    }
                    
                    var courseTime = timeCourse.split(separator: "-").map( {
                      $0.trimmingCharacters(in: .whitespacesAndNewlines)
                    })
                    
                    if(courseTime[0].count != 8) {
                      courseTime[0] = "0" + courseTime[0]
                      print(courseTime[0])
                    }
                    if(courseTime[1].count != 8) {
                      courseTime[1] = "0" + courseTime[1]
                      print(courseTime[1])
                    }
                    
                    
                    
                    let startTime1 = dateFormatter.date(from: userTime[0])!
                    let endTime1 = dateFormatter.date(from: userTime[1])!
                    let startTime2 = dateFormatter.date(from: courseTime[0])!
                    let endTime2 = dateFormatter.date(from: courseTime[1])!
                    
                    let range1 = startTime1...endTime1
                    let range2 = startTime2...endTime2
                    
                    if(range1.overlaps(range2)){
                      noOverlapWithCourses = false
                      break
                    }
                  }
                }
              }
              if(noOverlapWithCourses) {
                return true
              }
            } else {
              return true
            }
          }
        }
      }
    }
    return false
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
                  let courseName = course.school + " " + String(course.number)
                  userCourses.append(UserCourse(crn: crn, course: courseName, section: section, infoFound: true))
                  return
                }
              }
            }
            let courseName = course.school + " " + String(course.number)
            userCourses.append(UserCourse(crn: crn, course: courseName, section: section, infoFound: false))
            return
          }
        }
      }
    }
    self.groupedCourses = Dictionary(grouping:self.courses){$0.school}
    print(groupedCourses)
  }
}
