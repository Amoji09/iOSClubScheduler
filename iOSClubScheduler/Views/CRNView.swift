//
//  CRNView.swift
//  iOSClubScheduler
//
//  Created by Amogh Mantri on 4/18/22.
//

import SwiftUI


struct CRNView : View{
  @StateObject var model = APIModel.shared
  @State var input = ""
  var body: some View{
    VStack{
      HStack {
        Text("Check Time")
          .font(.system(size: 30, weight: .semibold, design: .default))
        Spacer()
      }.padding(EdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 0))
      Divider()
      HStack {
        TextField("Course CRN:",text : $input)
          .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
          .overlay( RoundedRectangle(cornerRadius: 10)
            .stroke(Color.gray, lineWidth: 1).frame(height: 30)
          ).padding(5)
        Button(action: {
          addTime()
        }) {
          Image(systemName: "plus")
            .padding(7).foregroundColor(Color.white).background(Color.blue).clipShape(Circle()).frame(width: 12, height: 12)
        }
      }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 20))
      
      List {
        ForEach(model.userCourses, id : \.self){ userCourse in
          Text(userCourse.course).foregroundColor(userCourse.infoFound ? Color.green : Color.red)
        }.onDelete(perform: deleteTime)
      }
      .frame(maxWidth: .infinity)
      .edgesIgnoringSafeArea(.all)
      .listStyle(PlainListStyle())
    }
  }
  
  func addTime(){
    model.searchTime(crn: input)
  }
  func deleteTime(offset: IndexSet) {
    model.userCourses.remove(atOffsets: offset)
    print(model.userCourses.count)  // Check model.userCourse is actually deleted
  }
}
