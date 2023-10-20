//
//  ContentView.swift
//  TaskManager
//
//  Created by 张鸿燊 on 1/10/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var selection: TaskSection? = nil
    
    
    var body: some View {
        NavigationSplitView{
            SideBarView(selection: $selection)
        } detail: {
            if let selection = selection {
                switch selection{
                case .all:
                    AllTaskListView()
                case .completed:
                    CompletedTaskListView()
                case .trash:
                    TrashTaskListView()
                case .group(let taskGroup):
                    GroupedTaskListView(taskGroup: taskGroup)
                }
            }
        }
        .navigationSplitViewStyle(.automatic)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
