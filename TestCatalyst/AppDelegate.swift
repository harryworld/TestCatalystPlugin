//
//  AppDelegate.swift
//  TestCatalyst
//
//  Created by Harry Ng on 10/1/2020.
//  Copyright © 2020 StaySorted Inc. All rights reserved.
//

import UIKit
import GRDB
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GRDBManager.setup(in: application)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

public struct GRDBManager {
    public static func setup(in application: UIApplication) {
        App.setup()
        App.db.setupMemoryManagement(in: application)
    }
}

public struct App {
    
    public static let dbURL = try! FileManager.default
        .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent("db.sqlite")
    
    public static let db: DatabasePool = {
        var config = Configuration()
        print("*** sqlite: \(dbURL.path)")
        config.trace = {
            print("main: \(Thread.isMainThread) - \($0)")
        }
        let pool = try! DatabasePool(path: dbURL.path, configuration: config)
        return pool
    }()
    
    public static func setup(_ database: DatabaseWriter = db) {
        do {
            return try migrator.migrate(database)
        } catch let error as DatabaseError {
            print("error sql: \(String(describing: error.sql))")
            print("error description: \(error.description)")
        } catch let error {
            print("error: \(error)")
        }
    }
    
    private static var migrator: DatabaseMigrator {
        var migrator: DatabaseMigrator = DatabaseMigrator()
        
        migrator.registerMigration("1569026727543 - createTask") { db in
            try db.create(table: "task") { t in
                t.primaryKey(["id"])
                t.column("id", .text).notNull()
                t.column("title", .text).notNull().defaults(to: "")
                t.column("date", .datetime).indexed()
                t.column("anytime", .boolean).notNull().defaults(to: false)
                t.column("sortOrder", .integer).notNull().defaults(to: 0)
                t.column("listOrder", .integer).notNull().defaults(to: 0)
                t.column("duration", .integer).notNull().defaults(to: 0)
                t.column("alertOffset", .integer).notNull().defaults(to: 0)
                t.column("alertDate", .datetime).indexed()
                t.column("repeatId", .text)
                t.column("isDetached", .boolean).notNull().defaults(to: false)
                t.column("locked", .boolean).notNull().defaults(to: false)
                t.column("completionDate", .datetime).indexed()
                t.column("completionType", .text).defaults(to: "normal")
                t.column("deletionDate", .datetime).indexed()
                t.column("listId", .text)
                t.column("encodedSystemFields", .blob)
                t.column("cachedCKRecordData", .blob)
            }
        }
        
        return migrator
    }
}

public enum Scheduler {
    public static let concurrent = ConcurrentDispatchQueueScheduler(qos: .userInitiated)
}
