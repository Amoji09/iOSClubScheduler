//
//  Course.swift
//  iOSClubScheduler
//
//  Created by Amogh Mantri on 4/18/22.
//

import SwiftUI

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


struct Meeting: Codable, Hashable{
  var days : String?
  var time : String?
  var location : String?
  var instructors : [String]?
  
  func checkOverlap(time : String) -> Bool{
    return false
  }
}


struct SectionModel: Codable, Hashable, Identifiable {
  
  var id: String {
    return crn
  }
  
  let section_id: String
  let crn: String
  var meetings : [Meeting]?
}


struct Course: Codable, Hashable, Identifiable {
  var id: String {
    return self._id
  }
  
  var getNumber: String {
    return self.number
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
