//
//  PrereqStore.swift
//  iOSClubScheduler
//
//  Created by Eric Zhou on 4/7/22.
//
import Foundation
import SwiftUI

class PrereqStore: ObservableObject {
  @Published var prereqs : [String] = []
  
  private static func fileURL() throws -> URL {
    try FileManager.default.url(for: .documentDirectory,
                                in: .userDomainMask, appropriateFor: nil, create: false)
    .appendingPathComponent("prereq.data")
  }
  
  static func load(completion: @escaping (Result<[String], Error>)-> Void) {
    DispatchQueue.global(qos: .background).async {
      do {
        let fileURL = try fileURL()
        guard let file = try? FileHandle(forReadingFrom: fileURL) else {
          DispatchQueue.main.async {
            completion(.success([]))
            
          }
          return
        }
        let prereqData = try JSONDecoder().decode([String].self, from: file.availableData)
        DispatchQueue.main.async {
          completion(.success(prereqData))
        }
      } catch {
        DispatchQueue.main.async {
          completion(.failure(error))
        }
      }
    }
  }
  
  static func save(prereqs: [String], completion: @escaping (Result<Int, Error>)->Void) {
    DispatchQueue.global(qos: .background).async {
      do {
        let data = try JSONEncoder().encode(prereqs)
        let outfile = try fileURL()
        try data.write(to: outfile)
        DispatchQueue.main.async {
          completion(.success(prereqs.count))
        }
      } catch {
        DispatchQueue.main.async {
          completion(.failure(error))
        }
      }
    }
  }
}
