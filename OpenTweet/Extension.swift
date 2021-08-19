//
//  Extension.swift
//  OpenTweet
//
//  Created by Lawson Kelly on 8/18/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

extension String {
    static func string(from timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        return DateFormatter.prettyDateFormatter.string(from: date)
    }

    static func highlight(from string: String) -> NSMutableAttributedString {
        let newString = string as NSString
        var att = NSMutableAttributedString(string: newString as String)
        let r = newString.range(of: "@\\w.*?\\b", options: .regularExpression, range: NSMakeRange(0, newString.length))
        if r.length > 0 {
            att.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: r)
            return att
        }
        return att
    }
}

extension DateFormatter {
    static let newsDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()

    static let prettyDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}

extension UIView {
    var width: CGFloat {
        frame.size.width
    }
    var height: CGFloat {
        frame.size.height
    }
    var left: CGFloat {
        frame.origin.x
    }
    var right: CGFloat {
        left + width
    }
    var top: CGFloat {
        frame.origin.y
    }
    var bottom: CGFloat {
        top + height
    }
}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
