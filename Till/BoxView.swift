//
//  BoxView.swift
//  Till
//
//  Created by Isis Ramirez on 18/10/19.
//  Copyright © 2019 Isis Ramirez. All rights reserved.
//

import Foundation
import SwiftUI

struct BoxView: View {
    
    let box: Event
    var image = UIImage()
    @State var s = UUID()
    @State var showingAdd = false
    
    init(box: Event, s: UUID) {
        self.box = box
        _s = State(initialValue: s)
        self.image = ImageHelper().getSavedImage(named:box.image ?? "")!
    }

    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        VStack {
            ZStack(alignment: Alignment.init(horizontal: .leading, vertical: .bottom)) {
                Image(uiImage: self.image)
                    .resizable()
                    .aspectRatio(self.image.size, contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 400, alignment: .topLeading)
                    .cornerRadius(10)
                if box.future() {
                    Color.black.opacity(0.4).cornerRadius(10)
                } else {
                    Color.gray.opacity(0.4).cornerRadius(10)
                }
                VStack (alignment: .leading) {
                    Text((self.s) != nil ? "" : "")
                        if box.calendarEventIdentifier != nil {
                            Image.init(systemName: "calendar")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20, alignment: .center)
                        }
                        Text(box.name!)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        Text("\(box.daysUntil())")
                            .font(.title)
                            .foregroundColor(.white)
                            .fontWeight(.medium)
                        Text("\(box.date!, formatter: Self.taskDateFormat)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .fontWeight(.light)
                    }.padding()
            }.padding()
        }
    }
}
