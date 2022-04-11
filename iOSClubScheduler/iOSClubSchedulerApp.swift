//
//  iOSClubSchedulerApp.swift
//  iOSClubScheduler
//
//  Created by Amogh Mantri on 2/17/22.
//

import SwiftUI

@main
struct iOSClubSchedulerApp: App {
    
    @StateObject private var prereqData = PrereqStore()
    
    init() {
        FBModel.shared.loadCourses()
    }
    var body: some Scene {
        WindowGroup {
            NavigationView {
                PrerequisiteMenuView(prereqs: $prereqData.prereqs) {
                    PrereqStore.save(prereqs: prereqData.prereqs) { result in
                        if case .failure(let error) = result {
                            fatalError(error.localizedDescription)
                        }
                    }
                }
            }
            .onAppear {
                PrereqStore.load { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(let prereqs):
                        prereqData.prereqs = prereqs
                    }
                }
            }
        }
    }
}
