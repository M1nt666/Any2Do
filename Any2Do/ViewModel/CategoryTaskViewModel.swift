//
//  categoryViewModel.swift
//  Any2Do
//
//  Created by Mint on 2022/3/5.
//

import Foundation
import SwiftUI
import CoreData

class CategoryTaskViewModel: ObservableObject{
    
    @Published var taskArray: [Task] = []
    @Published var categoryArray: [CategoryForTask] = []
    
//    @Published var notifications: [UNNotificationRequest] = []
    
    init() {
        loadData()
    }
    
    func loadData(by category: CategoryForTask? = nil) {
        loadCategory()
        if let currentCategory = category {
            loadTask(by: currentCategory)
        }
    }
    
    func saveData(by category: CategoryForTask? = nil) {
        if CoreDataManager.shared.viewContext.hasChanges {
            do {
                try CoreDataManager.shared.viewContext.save()
                loadData()
                if let currentCategory = category {
                    loadTask(by: currentCategory)
                }
            } catch let error {
                
                print("Error: \(error)")
            }
        }
    }
    
    func addNewCategory(with name: String, and imageName: String) {
        let newCategory = CategoryForTask(context: CoreDataManager.shared.viewContext)
        
        newCategory.categoryId = UUID()
        newCategory.timestamp = Date()
        newCategory.categoryName = name
        newCategory.categoryImageName = imageName
        newCategory.sumOfCategoryTask = 0
        
        saveData()
    }
    
    
    
    func delete(the category: CategoryForTask){
        if let tasks = category.task {
            for task in tasks {
                CoreDataManager.shared.viewContext.delete(task as! NSManagedObject)
            }
        }
        CoreDataManager.shared.viewContext.delete(category)
        saveData()
    }
    
    
    func loadCategory() {
        let request = NSFetchRequest<CategoryForTask>(entityName: "CategoryForTask")
        
        let sort = NSSortDescriptor(keyPath: \CategoryForTask.timestamp, ascending: true)
        
        request.sortDescriptors = [sort]
        
        do {
            try categoryArray = CoreDataManager.shared.viewContext.fetch(request)
        } catch {
            print("Error getting data. \(error.localizedDescription)")
        }
    }
    
    func newCategoryTask(with name: String, and reminder: Date,and note: String, to category: CategoryForTask) {
        let newTask = Task(context: CoreDataManager.shared.viewContext)
        
        newTask.taskId = UUID()
        newTask.timestamp = Date()
        newTask.taskName = name
        newTask.taskReminder = reminder
        newTask.taskNote = note
        newTask.taskDone = false
        newTask.taskFlag = false

        if let categoryIndex = categoryArray.firstIndex(where: { $0.categoryId == category.categoryId }) {
            newTask.category = categoryArray[categoryIndex]
            categoryArray[categoryIndex].sumOfCategoryTask = Int64(categoryArray[categoryIndex].task?.count ?? 0)
        }
        
        saveData(by: category)
        
//        //notification
//        let content = UNMutableNotificationContent()
//        content.title = "You have a task to do!"
//        content.body = name
//        content.sound = .default
//        content.badge = 1
//
//        let openAction = UNNotificationAction(identifier: "open", title: "Open", options: .foreground)
//        let cancelAction = UNNotificationAction(identifier: "cancel", title: "Cancel", options: .destructive)
//        let openAndCancelAction = UNNotificationCategory(identifier: "open and cancel action", actions: [openAction,cancelAction], intentIdentifiers: [])
//        UNUserNotificationCenter.current().setNotificationCategories([openAndCancelAction])
//        content.categoryIdentifier = "open and cancel action"
//
//        let dateComponents =  Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminder)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//        let request = UNNotificationRequest(identifier: name, content: content, trigger: trigger)
//        UNUserNotificationCenter.current().add(request)
        
    }
    

    func loadTask(by category: CategoryForTask) {
        if let currentCategoryIndex = categoryArray.firstIndex(where: { $0.categoryId == category.categoryId }) {
            let request = NSFetchRequest<Task>(entityName: "Task")
            let currentCategory = categoryArray[currentCategoryIndex]
            
            request.predicate = NSPredicate(format:"%K == %@", "category.categoryId", currentCategory.categoryId! as CVarArg)
            
            let sort = NSSortDescriptor(keyPath: \Task.timestamp, ascending: false)
            request.sortDescriptors = [sort]
            
            do {
                try taskArray = CoreDataManager.shared.viewContext.fetch(request)
                categoryArray[currentCategoryIndex].sumOfCategoryTask = Int64(categoryArray[currentCategoryIndex].task?.count ?? 0)
                saveData()
            } catch {
                print("Error getting data. \(error.localizedDescription)")
            }
        }
    }
    
    func deleteTask(by offsets: IndexSet) {
        offsets.map { taskArray[$0] }.forEach(CoreDataManager.shared.viewContext.delete)
        saveData()
    }
}

    
