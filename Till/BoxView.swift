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
    @State var showingAdd = false

    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        VStack {
            ZStack(alignment: Alignment.init(horizontal: .leading, vertical: .bottom)) {
                Image(uiImage: ImageHelper().getSavedImage(named:box.image!)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 400, alignment: .topLeading)
                    .cornerRadius(10)
                Color.gray.opacity(0.4).cornerRadius(10)
                VStack (alignment: .leading) {
                        Text(box.name!)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        Text("\(box.daysUntil()) days left")
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
