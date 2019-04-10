//
//  ViewController.swift
//  TO DO List
//
//  Created by Ibrahim Salah on 4/9/19.
//  Copyright © 2019 Ibrahim Salah. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class TasksViewController: UIViewController {
    @IBOutlet weak var tasksTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noTasks:UILabel!
    let realm = try! Realm()
    var tasks: Results<Task>!
    var currentTasks: Results<Task>!
    var taskCategory = [Int]()
    var category = [0:"Study" , 1:"Collage" , 2:"Holiday" , 3:"Exams"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    func getData (){
        tasks =  realm.objects(Task.self)
        currentTasks = tasks
        taskCategory = Set(tasks.value(forKeyPath: "category") as! [Int]).sorted()
        print(taskCategory)
        if tasks.count == 0 {
            noTasks.isHidden = false
        }else{
            noTasks.isHidden = true
        }
        tasksTableView.reloadData()
    }
    


}


extension TasksViewController : UITableViewDataSource, UITableViewDelegate{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskCategory.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return  category[taskCategory[section]]
    }
   
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .lightGray
            headerView.textLabel?.textColor = .darkGray
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return currentTasks.filter("category == %@", taskCategory[section]).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskTableViewCell
        cell.configure(task: currentTasks.filter("category == %@", taskCategory[indexPath.section])[indexPath.row])
        
        if currentTasks.filter("category == %@", taskCategory[indexPath.section])[indexPath.row].done{
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell

    }
    

    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            try! self.realm.write {
                
                self.realm.delete(self.currentTasks.filter("category == %@", self.taskCategory[indexPath.section])[indexPath.row])
                self.taskCategory = Set(self.currentTasks.value(forKeyPath: "category") as! [Int]).sorted()
                
            }
            self.tasksTableView.reloadData()
        }
        delete.backgroundColor = .red
        
        let done = UITableViewRowAction(style: .normal, title: "Done") { action, index in
            try! self.realm.write {
                self.currentTasks.filter("category == %@", self.taskCategory[indexPath.section])[indexPath.row].done = true
                let uuid =  self.currentTasks.filter("category == %@", self.taskCategory[indexPath.section])[indexPath.row].uuid
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:[uuid])
                self.tasksTableView.reloadData()
            }
        }
        done.backgroundColor = .green
        
        return [delete, done]
    }
    
    
}

extension TasksViewController :UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else{
            currentTasks = tasks;
            self.taskCategory = Set(self.currentTasks.value(forKeyPath: "category") as! [Int]).sorted()
            tasksTableView.reloadData()
            return
        }
        currentTasks = realm.objects(Task.self).filter(NSPredicate(format: "title contains[c] %@", "\(searchText)"))
        self.taskCategory = Set(self.currentTasks.value(forKeyPath: "category") as! [Int]).sorted()
        tasksTableView.reloadData()
    }

}

