//
//  FirstViewController.swift
//  TestCatalyst
//
//  Created by Harry Ng on 10/1/2020.
//  Copyright © 2020 StaySorted Inc. All rights reserved.
//

import UIKit
import DynamicColor
import BonMot
import SwiftDate
import RxSwift
import GRDB
import RxGRDB

class FirstViewController: UIViewController {
    
    let bag = DisposeBag()
    
    public let serialScheduler = SerialDispatchQueueScheduler(qos: .userInitiated)

    @IBAction func insertRecord(_ sender: UIButton) {
        // 1. Insert new record using object
//        let task = GTask(title: "Test \(Date().second)", date: Date() + 1.days)
//        try! App.db.write { db in
//            try task.save(db)
//        }
        
        let table = GTask.databaseTableName
        
        try! App.db.write { db in
            // 2. Insert record using SQL
//            let offset = Int.random(in: 0..<10)
//
//            let keys: [String] = ["id", "title", "date"]
//            let values: [Any] = [NSUUID().uuidString, "Insert \(Date().second)", Date() + offset.days]
//            if let arguments = StatementArguments(values) {
//                let paramList = keys.joined(separator: ", ")
//                var paramValues: [String] = []
//                for _ in 0..<keys.count {
//                    paramValues.append("?")
//                }
//                let paramValuesList = paramValues.joined(separator: ", ")
//                try db.execute(
//                    sql: "INSERT INTO \(table) (\(paramList)) VALUES (\(paramValuesList))",
//                    arguments: arguments)
//            }

            // 3. Update using SQL
            let id = "TEST"
            
            let keys: [String] = ["title", "completionDate"]
            let values: [Any] = ["Update \(Date().second)", Date()]
            if let arguments = StatementArguments(values + [id]) {
                let paramList = keys
                    .map { $0 + " = ?" }
                    .joined(separator: ", ")
                print("*** update table: \(Date())")
                try db.execute(
                    sql: "UPDATE \(table) SET \(paramList) WHERE id = ?",
                    arguments: arguments)
            }
            
            // 4. Update using SQL (set NULL)
//            let nilKeys = ["completionDate"]
//            let nilList = nilKeys
//                .map { $0 + " = NULL" }
//                .joined(separator: ", ")
//            try db.execute(
//                sql: "UPDATE \(table) SET \(nilList) WHERE id = ?",
//                arguments: [id])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let today = Date()
        print("*** start: \(Date())")
        for i in 0..<10 {
            let date = today + i.days
            GTask.notCompletedResults(for: date)
                .rx.observeCount(
                    in: App.db,
                    startImmediately: true,
                    observeOn: Scheduler.concurrent)
                .subscribe(onNext: { (count) in
                    print("*** observed on \(date.toString()) count: \(count) - main thread: \(Thread.isMainThread)")
                })
                .disposed(by: bag)
        }
        print("*** end: \(Date())")
    }


}

