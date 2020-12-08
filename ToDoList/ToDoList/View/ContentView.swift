//
//  ContentView.swift
//  ToDoList
//
//  Created by Thufail Adib on 05/12/20.
//  Copyright © 2020 Dicoding Academy. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true)]) var todos: FetchedResults<Todo>
    
    @State private var showingAddTodoView: Bool = false
    @State private var animatingButton: Bool = false
    
    var body: some View {
        NavigationView{
            ZStack {
                List{
                    ForEach(self.todos, id: \.self) { todo in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(todo.name ?? "Unknown").font(.headline).lineLimit(nil)
                                Spacer()
                                Text(todo.desc ?? "Unknown").font(.caption).lineLimit(2)
                            }
                            Spacer()
                            Text(todo.priority ?? "Unknown")
                        }
                    }
                    .onDelete(perform: deleteTodo)
            
                }
                .navigationBarTitle("Todo", displayMode: .inline)
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button(action: {
                        self.showingAddTodoView.toggle()
                    }){
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $showingAddTodoView) {
                        AddToDoView().environment(\.managedObjectContext, self.managedObjectContext)
                    }
                )
                
            }
            .sheet(isPresented: $showingAddTodoView) {
                AddToDoView().environment(\.managedObjectContext, self.managedObjectContext)
            }
            .overlay(
                ZStack {
                    Group{
                        Circle()
                            .fill(Color.blue)
                            .opacity(self.animatingButton ? 0.2: 0)
                            .scaleEffect(self.animatingButton ? 1 : 0)
                            .frame(width: 68, height: 68, alignment: .center)
                        Circle()
                            .fill(Color.blue)
                            .opacity(self.animatingButton ?  0.15 : 0)
                            .scaleEffect(self.animatingButton ? 1 : 0)
                            .frame(width: 88, height: 88, alignment: .center)
                    }.animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true))
                    
                    Button(action: {
                        self.showingAddTodoView.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: .center)
                    }.onAppear(perform: {
                        self.animatingButton.toggle()
                    })
                }
                .padding(.bottom, 15)
                .padding(.trailing, 15)
                , alignment: .bottomTrailing
            )
        }
    }
    
    private func deleteTodo(at offsets: IndexSet) {
        for index in offsets {
            let todo = todos[index]
            managedObjectContext.delete(todo)
            
            do{
                try managedObjectContext.save()
            }catch {
                print(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView()
            .environment(\.managedObjectContext, context)
    }
}
