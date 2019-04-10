//
//  AddTaskViewController.swift
//  TO DO List
//
//  Created by Ibrahim Salah on 4/9/19.
//  Copyright © 2019 Ibrahim Salah. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class AddTaskViewController: UIViewController {
    @IBOutlet weak var taskNameTextField:UITextField!
    @IBOutlet weak var endDataTextField: UITextField!
    @IBOutlet weak var categoryPickUpData: UITextField!
    

    var CategoryPickerView : UIPickerView!
    var categoryPicker = [0:"Study" , 1:"Collage" , 2:"Holiday" , 3:"Exams"]
    var datePicker = UIDatePicker()
    var category = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add new Task"
        // print(Realm.Configuration.defaultConfiguration.fileURL)

        //datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(AddTaskViewController.dateChanged(datePicker:)), for: .valueChanged)

        endDataTextField.inputView = datePicker
        
        // Create toolBar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        
        // add done button to toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneTapped))
        toolBar.setItems([doneButton], animated: true)
        endDataTextField.inputAccessoryView = toolBar
        
        
    }
    
    
    @objc func doneTapped(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
        endDataTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
        endDataTextField.text = dateFormatter.string(from: datePicker.date)
        //view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    @IBAction func addNewTasKButtonTapped(sender:UIButton){
        do{
            // add identifier for notification
            let uuid = NSUUID().uuidString
            //print("uuid: \(uuid)")

            let realm = try Realm()
            let newTask = Task()
            if taskNameTextField.text == "" {return}
            if endDataTextField.text == "" {return}
            if categoryPickUpData.text == "" {return}
            newTask.title = taskNameTextField.text
            newTask.createdAt = endDataTextField.text
            newTask.category = self.category
            newTask.uuid = uuid
            do{
                try realm.write {
                    realm.add(newTask)

                }
                sendNotification(taskName: taskNameTextField.text!, id:uuid , endDate: datePicker.date)
                self.navigationController?.popViewController(animated: true)
            }catch{
                print("Error")
            }
        }catch{
            print("Error")
        }
    }
    
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.CategoryPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.CategoryPickerView.delegate = self
        self.CategoryPickerView.dataSource = self
        self.CategoryPickerView.backgroundColor = UIColor.white
        textField.inputView = self.CategoryPickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddTaskViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(AddTaskViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    @objc func doneClick() {
        categoryPickUpData.resignFirstResponder()
    }
    @objc func cancelClick() {
        categoryPickUpData.resignFirstResponder()
    }

    
    func sendNotification(taskName :String, id: String, endDate:Date) {
        let content = UNMutableNotificationContent()
        content.title = "Uncompeleted Task"
        content.subtitle = "\(taskName)"
        content.sound = .default
        var dateComponents = DateComponents()
        
        

        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let year: String = dateFormatter.string(from: endDate)
        dateFormatter.dateFormat = "MM"
        let month: String =  dateFormatter.string(from: endDate)
        dateFormatter.dateFormat = "dd"
        let day: String =  dateFormatter.string(from: endDate)
        
        dateFormatter.dateFormat = "HH"
        let houre: String =  dateFormatter.string(from: endDate)
        
        dateFormatter.dateFormat = "mm"
        let min: String =  dateFormatter.string(from: endDate)
        
        dateComponents.day = Int(day)!
        dateComponents.year = Int(year)!
        dateComponents.month = Int(month)!
        dateComponents.hour = Int(houre)!
        dateComponents.minute = Int(min)!

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            print(error as Any)
        }
       
    }

}


extension AddTaskViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryPicker.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        category = row
        self.categoryPickUpData.text = categoryPicker[row]
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryPicker[row]
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUp(categoryPickUpData)
    }
    
}
