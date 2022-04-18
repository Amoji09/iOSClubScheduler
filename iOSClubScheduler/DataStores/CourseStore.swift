//
//  CourseStore.swift
//  iOSClubScheduler
//
//  Created by Eric Zhou on 4/12/22.
//
import Foundation
import SwiftUI
class CourseStore: ObservableObject {
  
  @Published var courses: [Course] = []
  
  internal static func fileURL() throws -> URL {
    try FileManager.default.url(for: .documentDirectory,
                                in: .userDomainMask, appropriateFor: nil, create: false)
    .appendingPathComponent("course.data")
  }
  
  static func load(completion: @escaping (Result<[Course], Error>)-> Void) {
    DispatchQueue.global(qos: .background).async {
      do {
        let fileURL = try fileURL()
        guard let file = try? FileHandle(forReadingFrom: fileURL) else {
          DispatchQueue.main.async {
            completion(.success([]))
          }
          return
        }
        let courseData = try JSONDecoder().decode([Course].self, from: file.availableData)
        DispatchQueue.main.async {
          completion(.success(courseData))
        }
      } catch {
        DispatchQueue.main.async {
          completion(.failure(error))
        }
      }
    }
  }
  
  static func refresh(courses: [Course], completion: @escaping (Result<Int, Error>)->Void) {
    DispatchQueue.global(qos: .background).async {
      do {
        let url = URL(string: "https://oscartracker.herokuapp.com/testCourses/100/")!
        let data = try! Data(contentsOf: url)
        let outfile = try fileURL()
        try data.write(to: outfile)
        DispatchQueue.main.async {
          completion(.success(courses.count))
        }
      } catch {
        DispatchQueue.main.async {
          completion(.failure(error))
        }
      }
    }
  }
}
