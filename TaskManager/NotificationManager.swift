//
//  NotificationManager.swift
//  TaskManager
//
//  Created by 张鸿燊 on 9/10/2023.
//

import Foundation
import UserNotifications
import CoreLocation

class TaskNotificationManager {
    static let shared = TaskNotificationManager()
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, err in
            if let err = err {
                print("error \(err)")
            }
        }
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }
    
    func sendCanlendarNotification(task: Task){
        requestAuthorization()
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id])
        debugPrint("remove task notification success, task.id \(task.id)")
        if !task.hasDueDate || task.dueDate == nil {
            return
        }
        
        guard let notificationDate = Calendar.current.date(
            byAdding: task.notificationTimeInterval.unit.toCalendarComponent(),
            value: task.notificationTimeInterval.position == .after ? task.notificationTimeInterval.value : -task.notificationTimeInterval.value,
            to: task.dueDate!) else {
            print("notification date is nil")
            return
        }
        
        // expired
        if notificationDate < .now {
            print("notification date is earlier than now")
            return
        }
        let content = UNMutableNotificationContent()
        content.title = task.title
        content.subtitle = dateFormatter.string(from: task.dueDate!)
        content.sound = .default
        let trigger = UNCalendarNotificationTrigger(dateMatching: notificationDate.toDataComponents(), repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { err in
            if let err = err {
                print("error \(err)")
            }
        }
        print("send task notification success, task.id \(task.id), notification date \(notificationDate.description)")
    }
    
}
