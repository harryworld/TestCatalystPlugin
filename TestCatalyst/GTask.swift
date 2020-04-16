//
//  GTask.swift
//  TestCatalyst
//
//  Created by Harry Ng on 16/4/2020.
//  Copyright © 2020 StaySorted Inc. All rights reserved.
//

import GRDB

public struct GTask: Codable, FetchableRecord, PersistableRecord {
    public var id: String = UUID().uuidString
    public var title: String = ""
    public var date: Date? = nil
    public var anytime: Bool = false
    public var sortOrder: Int = 0
    public var listOrder: Int = 0
    public var duration: Int = 0
    public var alertOffset: Int = 0
    public var alertDate: Date? = nil
    public var isDetached: Bool = false
    public var locked: Bool = false
    public var completionDate: Date? = nil
    public var completionType: String = "normal"
    public var deletionDate: Date? = nil
    public var listId: String? = nil
    public var repeatId: String? = nil
    public var encodedSystemFields: Data? = nil
    public var cachedCKRecordData: Data? = nil
    
    public init() {}
}

extension GTask: TableRecord {
    public static let databaseTableName = "task"
//    public static let recordType = databaseTableName.uppercasingFirst
//    public static let list = belongsTo(GList.self)
//    public var list: QueryInterfaceRequest<GList> {
//        return request(for: GTask.list)
//    }
//    public static let taxonomies = hasMany(GTaxonomy.self)
//    public var taxonomies: QueryInterfaceRequest<GTaxonomy> {
//        return request(for: GTask.taxonomies)
//    }
//    public static let tags = hasMany(GTag.self, through: taxonomies, using: GTaxonomy.tag)
//    public var tags: QueryInterfaceRequest<GTag> {
//        return request(for: GTask.tags)
//    }
//    public static let repeatTask = belongsTo(GRepeatTask.self)
//    public var repeatTask: QueryInterfaceRequest<GRepeatTask> {
//        return request(for: GTask.repeatTask)
//    }
}

extension GTask {
    public enum Columns {
        static let id = Column(CodingKeys.id)
        static let title = Column(CodingKeys.title)
        static let date = Column(CodingKeys.date)
        static let anytime = Column(CodingKeys.anytime)
        static let sortOrder = Column(CodingKeys.sortOrder)
        static let listOrder = Column(CodingKeys.listOrder)
        static let duration = Column(CodingKeys.duration)
        static let alertOffset = Column(CodingKeys.alertOffset)
        static let alertDate = Column(CodingKeys.alertDate)
        static let isDetached = Column(CodingKeys.isDetached)
        static let locked = Column(CodingKeys.locked)
        static let completionDate = Column(CodingKeys.completionDate)
        static let deletionDate = Column(CodingKeys.deletionDate)
        static let listId = Column(CodingKeys.listId)
        static let repeatId = Column(CodingKeys.repeatId)
    }
    
    public static let properties: [String] = {
        return [
            "id",
            "title",
            "date",
            "anytime",
            "sortOrder",
            "listOrder",
            "duration",
            "alertOffset",
            "alertDate",
            "isDetached",
            "locked",
            "completionDate",
            "deletionDate",
            "list",
            "repeat",
        ]
    }()
}

extension GTask {
    public init(title: String, date: Date? = nil) {
        self.init()
        self.title = title
        self.date = date
    }
    
    public static func notCompletedResults(for date: Date) -> QueryInterfaceRequest<Self> {
//        let startDate = date.isToday
//            ? LongTimeAgo.endOfDay
//            : date.fastMidnight
        let startDate = date.dateAtStartOf(.day)
        let endDate = date.dateAtEndOf(.day)
        return self.all()
            .filter(self.Columns.date >= startDate)
            .filter(self.Columns.date <= endDate)
            .filter(self.Columns.completionDate == nil)
            .filter(self.Columns.deletionDate == nil)
    }
}
