//
//  Date+TimeAgo.swift
//  InstantMac
//
//  Created by Paul Sevilla on 10/07/2018.
//  Copyright © 2018 Monstar Lab Pte Ltd. All rights reserved.
//

import Foundation

enum TimeAgoStyle {
  case short
  case long
}

extension TimeAgoStyle {
  
  var separator: String {
    switch self {
    case .short:
      return ""
    case .long:
      return " "
    }
  }
  
  func lessThanAMinute() -> String {
    return "Less than a minute"
  }
  
  func justNow() -> String {
    return "Just Now"
  }
  
  func minutes(singular: Bool = false) -> String {
    switch self {
    case .short:
      return "m"
    case .long:
      return singular ? "minute" : "minutes"
    }
  }
  
  func hours(singular: Bool = false) -> String {
    switch self {
    case .short:
      return "h"
    case .long:
      return singular ? "hour" : "hours"
    }
  }
  
  func days(singular: Bool = false) -> String {
    switch self {
    case .short:
      return "d"
    case .long:
      return singular ? "day" : "days"
    }
  }
  
  func weeks(singular: Bool = false) -> String {
    switch self {
    case .short:
      return "w"
    case .long:
      return singular ? "week" : "weeks"
    }
  }
  
  func months(singular: Bool = false) -> String {
    switch self {
    case .short:
      return "M"
    case .long:
      return singular ? "month" : "months"
    }
  }
  
  func years(singular: Bool = false) -> String {
    switch self {
    case .short:
      return "y"
    case .long:
      return singular ? "year" : "years"
    }
  }
  
}

extension Date {
  
  func formattedAsTimeAgo(style: TimeAgoStyle = .short, toDate: Date = Date()) -> String {
    let components: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year]
    let dateComponents = Calendar.current.dateComponents(components, from: self, to: toDate)
    let minuteDiff = dateComponents.minute ?? 0
    let hourDiff   = dateComponents.hour ?? 0
    let dayDiff    = dateComponents.day ?? 0
    let weekDiff   = dateComponents.weekOfYear ?? 0
    let monthDiff  = dateComponents.month ?? 0
    let yearDiff   = dateComponents.year ?? 0
  
    if yearDiff > 0 {
      return "\(monthDiff)\(style.separator)\(style.years(singular: monthDiff == 1))"
    } else if monthDiff > 0 && style == .long {
      return "\(monthDiff)\(style.separator)\(style.months(singular: monthDiff == 1))"
    } else if weekDiff > 0 {
      return "\(weekDiff)\(style.separator)\(style.weeks(singular: weekDiff == 1))"
    } else if dayDiff > 0 {
      return "\(dayDiff)\(style.separator)\(style.days(singular: dayDiff == 1))"
    } else if hourDiff > 0 {
      return "\(hourDiff)\(style.separator)\(style.hours(singular: hourDiff == 1))"
    } else if minuteDiff > 0 {
      return "\(minuteDiff)\(style.separator)\(style.minutes(singular: minuteDiff == 1))"
    } else {
      return style.justNow()
    }
  }
  
}
