//
//  TimelineResponse.swift
//  OpenTweet
//
//  Created by Lawson Kelly on 8/17/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

struct Timeline: Codable {
    let timeline: [Tweet]?
}

struct Tweet: Codable {
    let id: String?
    let author: String?
    let content: String?
    let avatar: String?
    let inReplyTo: String?
    let date: String

    public func getHeight(model: Tweet) -> CGFloat {
        guard let count = model.content?.count else {
            return 140
        }
        if count > 20 && count < 70 {
            return 120
        } else if count > 70 && count < 100 {
            return 160
        } else if count > 100 && count < 140 {
            return 200
        }
        return 100
    }

    public func getDate(_ string: String) -> Date {
        let dateFormatter = ISO8601DateFormatter()
        let otherDateFormatter = DateFormatter()
        otherDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        guard let date = dateFormatter.date(from: string) else { return otherDateFormatter.date(from: string)! }
        return date
    }
}
