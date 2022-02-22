//
//  iOSClubSchedulerApp.swift
//  iOSClubScheduler
//
//  Created by Amogh Mantri on 2/17/22.
//

import SwiftUI

@main
struct iOSClubSchedulerApp: App {
    init() {
        FBModel.shared.loadCourses()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
