//
//  TaskGroupDetailView.swift
//  TaskManager
//
//  Created by 张鸿燊 on 9/10/2023.
//

import SwiftUI

struct TaskGroupDetailView: View {
    
    @Bindable var taskGroup : TaskGroup
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(LocalizedStringKey("taskgroup.title"), text: $taskGroup.title)
                .font(.title2)
                .textFieldStyle(.plain)
            Divider()
            HStack {
                Text(LocalizedStringKey("taskgroup.createdAt"))
                    .font(.title2)
                Text(" \(taskGroup.createdAt.formatted())")
                    .font(.title2)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    TaskGroupDetailView(taskGroup: .example())
}
