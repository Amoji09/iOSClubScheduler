//
//  ContentView.swift
//  iOSClubScheduler
//
//  Created by Amogh Mantri on 2/17/22.
//

import SwiftUI



struct ContentView: View {
  
  init(){
    UITableView.appearance().backgroundColor = .clear
  }
  
  @StateObject private var prereqData = PrereqStore()
  var body: some View{
    TabView{
      CourseView()
        .tabItem{
          Label("Courses",systemImage: "list.dash")
        }
      PrerequisiteMenuView(prereqs: $prereqData.prereqs) {
        PrereqStore.save(prereqs: prereqData.prereqs) { result in
          if case .failure(let error) = result {
            fatalError(error	.localizedDescription)
          }
        }
      }.onAppear {
        PrereqStore.load { result in
          switch result {
          case .failure(let error):
            fatalError(error.localizedDescription)
          case .success(let prereqs):
            prereqData.prereqs = prereqs
          }
        }
      }
      .tabItem{
        Label("Prereqs", systemImage: "textformat")
      }
      CRNView()
        .tabItem{
          Label("Times", systemImage: "clock")
        }
    }
  }
  
}






struct CRNView : View{
  @StateObject var model = FBModel.shared
  @State var input = ""
  var body: some View{
    VStack{
      Text("Input Taken Classes")
      
      TextField("Course CRN",text : $input).overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(Color.black, lineWidth: 1).frame(width: 300, height: 30, alignment: .center)
      ).padding()
      
      Button("Add Taken Course") {
        addTime()
      }.padding().foregroundColor(Color.yellow).background(Color.blue).cornerRadius(10)
      
      //      List {
      //        ForEach(model.timeCRNS, id : \.self){ crn in
      //          Text(crn.code).foregroundColor(crn.infoFound ? Color.green : Color.red)
      //        }
      //      }
    }
    .padding()
  }
  
  func addTime(){
    //model.searchTime(crn: input)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
