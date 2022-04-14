//
//  PrerequisiteMenuView.swift
//  iOSClubScheduler
//
//  Created by Amogh Mantri on 4/10/22.
//

import SwiftUI


struct PrerequisiteMenuView : View{
  @StateObject var model = FBModel.shared
  @State var input = ""
  var body: some View{
    VStack{
      Text("Input Taken Classes")
      
      TextField("Course code",text : $input).overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(Color.black, lineWidth: 1).frame(width: 300, height: 30, alignment: .center)
      ).padding()
      
      Button("Add Taken Course") {
        addPrereq()
      }.padding().foregroundColor(Color.yellow).background(Color.blue).cornerRadius(10)
      
      List {
        ForEach(model.prerequisiteCodes, id : \.self){ code in
          Text(code)
        }
      }
    }
    .padding()
    
  }
  
  func addPrereq(){
    model.prerequisiteCodes.append(input)
  }
  
  func validateCode() -> Bool{
    var parts = input.components(separatedBy: " ")
    var school = String(parts[0])
    var code = String(parts[1])
    
    if(school.count != 2 || school.count != 3 || school.count != 4) {
      return false
    }
    return true
  }
}


struct PrerequisiteMenuView_Previews: PreviewProvider {
  static var previews: some View {
    PrerequisiteMenuView()
  }
}
