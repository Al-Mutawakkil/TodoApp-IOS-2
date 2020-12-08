//
//  AddToDoView.swift
//  ToDoList
//
//  Created by Thufail Adib on 05/12/20.
//  Copyright © 2020 Dicoding Academy. All rights reserved.
//

import SwiftUI

struct AddToDoView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var description = ""
    @State private var priority: String = "High"
    
    let priorities = ["High", "Medium", "Low"]
    
    @State private var errorShowing: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMsg: String = ""
    
    var body: some View {
        NavigationView{
            VStack {
                VStack(alignment: .leading, spacing: 20){
                    TextField("Title", text: $name)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 20, weight: .bold, design: .default))
                    
                    TextField("Description", text: $description)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 20, weight: .bold, design: .default))
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Button(action: {
                        if self.name != "" {
                            let todo = Todo(context: self.managedObjectContext)
                            todo.name = self.name
                            todo.desc = self.description
                            todo.priority = self.priority
                            
                            do{
                                try self.managedObjectContext.save()
                            }catch {
                                print(error)
                            }
                        }else {
                            self.errorShowing = true
                            self.errorTitle = "Invalid Data"
                            self.errorMsg = "Please Fill The Blank"
                            return
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Text("Save")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .foregroundColor(Color.white)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 30)
                Spacer()
            }
            .navigationBarTitle("New Todo", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                }
            )
                .alert(isPresented: $errorShowing) {
                    Alert(title: Text(errorTitle), message: Text(errorMsg), dismissButton:
                        .default(Text("OK")))
            }
        }
    }
}

struct AddToDoView_Previews: PreviewProvider {
    static var previews: some View {
        AddToDoView()
    }
}
