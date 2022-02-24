//
//  FBModel.swift
//  iOSClubScheduler
//
//  Created by Amogh Mantri on 2/17/22.
//

import Foundation
import Firebase

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

struct Section: Decodable, Hashable, Identifiable {
    
    var id: String {
        return crn
    }
    
    let section_id: String
    let crn: String
    let time: String?
    let location: String?
}


struct Course: Decodable, Hashable, Identifiable {
    var id: String {
        return self._id
    }
    
    let _id: String
    let semester: String
    let fullname: String
    let school: String
    let number: String
    var sections: [Section]?
}

class FBModel: ObservableObject {
    @Published var courses: [Course] = []
    let db : Firestore
    
    static let shared = FBModel()
    
    init(){
        FirebaseApp.configure()
        self.db = Firestore.firestore()
    }
    
    func addData(){
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "first": "Ada",
            "last": "Lovelace",
            "born": 1815
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func loadCourses() {
        let url = URL(string: "https://oscartracker.herokuapp.com/testCourses/20/")!
        let data = try! Data(contentsOf: url)
        let courses = try! JSONDecoder().decode([Course].self, from: data)
        self.courses = courses
    }
    
}
