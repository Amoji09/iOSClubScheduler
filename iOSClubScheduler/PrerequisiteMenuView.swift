//
//  PrerequisiteMenuView.swift
//  iOSClubScheduler
//
//  Created by Amogh Mantri on 4/10/22.
//

import SwiftUI


struct PrerequisiteMenuView : View {
  @Binding var prereqs: [String]
  @Environment(\.scenePhase) private var scenePhase
  @StateObject var model = FBModel.shared
  @State var input = ""
  let saveAction: () -> Void
  
  var body: some View{
    VStack {
      HStack {
        Text("Prerequisites")
          .font(.system(size: 30, weight: .semibold, design: .default))
        Spacer()
      }.padding(EdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 0))
      Divider()
      
      HStack {
        TextField("Course Code:",text : $input)
          .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
          .overlay( RoundedRectangle(cornerRadius: 10)
            .stroke(Color.gray, lineWidth: 1).frame(height: 30)
          ).padding(5)
        Button(action: {
          if validateCode() {
            if (!prereqs.contains(input.uppercased())) {
              addPrereq()
              self.input = ""
            }
          }
        }) {
          Image(systemName: "plus")
            .padding(7).foregroundColor(Color.white).background(Color.blue).clipShape(Circle()).frame(width: 12, height: 12)
        }
      }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 20))
      List {
        ForEach(prereqs, id: \.self) { prereq in
          Text(prereq)
        }
        .onDelete(perform: deletePrereq)
      }
      .frame(maxWidth: .infinity)
      .edgesIgnoringSafeArea(.all)
      .listStyle(PlainListStyle())
    }
    .onChange(of: scenePhase) { phase in
      if phase == .inactive {
        saveAction()
      }
    }
    .onDisappear {
      saveAction()
    }
  }
  
  func addPrereq(){
    prereqs.append(input.uppercased())
    prereqs.sort()
  }
  
  func deletePrereq(at offsets: IndexSet) {
    prereqs.remove(atOffsets: offsets)
  }
  
  func validateCode() -> Bool {
    let components = input.components(separatedBy: " ")
    if components.count != 2 {
      return false
    }
    let school = String(components[0])
    let code = String(components[1])
    if let answer = model.groupedCourses[school]?.filter ({
      $0.getNumber.contains(code)
    }) {
      if answer.count == 0 {
        return false
      }
      return true
    } else {
      return false
    }
  }
}

/*struct PrerequisiteMenuView_Previews: PreviewProvider {
 static var previews: some View {
 PrerequisiteMenuView()
 }
 }*/
