//
//  InputViewController.swift
//  taskapp
//
//  Created by yuji on 2018/01/19.
//  Copyright © 2018年 yuji. All rights reserved.
//

import UIKit
import RealmSwift // 追加
import UserNotifications //追加

class InputViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var contentsTextView: UITextView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    
    var task: Task! //追加する
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date as Date
        categoryTextField.text = task.category
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool){
        
        try! realm.write{
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date as NSDate
            self.task.category = self.categoryTextField.text!
            self.realm.add(self.task, update: true)
            
        }
        
        setNotification(task: task)
        
        super.viewWillDisappear(animated)
        
    }
    
    func dismissKeyboard(){
        //キーボードを閉じる
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //タスクのローカル通知を登録する
    func setNotification(task: Task){
        let content = UNMutableNotificationContent()
        content.title = task.title
        content.body = task.contents //body　が空だと音しか出ない
        content.sound = UNNotificationSound.default()
        
        //ローカル通知が発動するtrigger（日付マッチ）を作成
        let calendar = NSCalendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date as Date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        //identifier, content, trigger からローカル通知を作成（identifier が同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest.init(identifier: String(task.id), content: content, trigger: trigger)
        
        //ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録　OK") // errorがnilならローカル通知の登録に成功したと表示します。　errorが存在すればerrorを返します
        }
            // み通知のローカル通知一覧をログ出力
            
            center.getPendingNotificationRequests {  (requests: [UNNotificationRequest]) in
                for request in requests{
                    print("/------------")
                    print(request)
                    print("/------------")
                }
            }
        }
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destinationViewController.
         // Pass the selected object to the new view controller.
         }
         */
        
}
