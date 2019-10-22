//
//  ContentView.swift
//  Till
//
//  Created by Isis Ramirez on 10/16/19.
//  Copyright © 2019 Isis Ramirez. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Event.getAllEvents()) var events: FetchedResults<Event>
    
    @State var showingAdd = false
    @State var showingPreview = false
    @State var showingEdit = false
    @State private var presented_obj: Event?

    var body: some View {
        NavigationView {
            ScrollView {
                if events.count != 0 {
                    VStack {
                        
                        ForEach(events) { box in
                            BoxView(box: box).contextMenu {
                                VStack {
                                    Button(action: {
                                        self.showingEdit.toggle()
                                        self.presented_obj = box
                                    }) {
                                        HStack {
                                            Text("Edit")
                                            Image(systemName: "pencil")
                                        }
                                    }
                                    
                                    Button(action: {
                                        self.managedObjectContext.delete(box)
                                    }) {
                                        HStack {
                                            Text("Remove")
                                            Image(systemName: "trash")
                                        }
                                    }
                                }
                            }.gesture(
                                TapGesture()
                                    .onEnded { _ in
                                        self.showingPreview.toggle()
                                        self.presented_obj = box
                                }
                            ).sheet(isPresented: self.$showingPreview) {
                                EventView(box: self.presented_obj!)
                            }
                        }
                        
                    }
                } else {
                    VStack {
                            Image("iconEmpty").aspectRatio(contentMode: .fit).imageScale(.small)
                            Text("No events").font(.body)
                            Text("Add new events to preview them").font(.caption)
                        }.padding()
                }

            }
            .navigationBarTitle(Text("till."))
            .navigationBarItems(trailing: Button(action: {
                self.showingAdd.toggle()
            }) {
                VStack {
                    Image("iconAdd")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.primary)
                }
            }).sheet(isPresented: $showingAdd) {
                AddView().environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


