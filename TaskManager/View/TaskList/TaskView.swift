//
//  TaskView.swift
//  TaskManager
//
//  Created by 张鸿燊 on 2/10/2023.
//

import SwiftUI

struct TaskView: View {
    
    @Bindable var task: Task
    @State private var showInfoButton: Bool = false
    
    
    #if os(macOS)
    @Environment(\.openWindow) private var openWindow
    #elseif os(iOS)
    @State private var showSheet: Bool = false
    #endif
    
    var body: some View {
        HStack(alignment: .top){
            Image(systemName: task.completed ? "largecircle.fill.circle":"circle")
                .onTapGesture {
                    withAnimation {
                        task.completed.toggle()
                    }
                }
            VStack(alignment: .leading) {
                HStack {
                    TextField(LocalizedStringKey("New Task"), text: $task.title, onEditingChanged: { value in
                        debugPrint(value)
                        showInfoButton = true
                    })
                        
                    if showInfoButton {
                        Image(systemName:  "info.circle")
                            .onTapGesture {
                                #if os(macOS)
                                openWindow(value: task)
                                #elseif os(iOS)
                                showSheet = true
                                #endif
                            }
                    }
                }
                if task.hasDueDate {
                    Text(task.dueDate != nil ? task.dueDate!.formatted() : "")
                        .foregroundStyle(task.dueDate != nil && task.dueDate! < Date.now ? .red : .primary)
                }
            }
        }
        .draggable(task.id)
        #if os(macOS)
        .onHover { hovering in
            showInfoButton.toggle()
        }
        #elseif os(iOS)
        .sheet(isPresented: $showSheet, content: {
            TaskDetailView(task: task)
        })
        #endif
    }
}

#Preview {
    TaskView(task: Task.example())
}
