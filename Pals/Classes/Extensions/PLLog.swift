//
//  PLLog.swift
//  Pals
//
//  Created by ruckef on 29.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

enum PLLogType : Int {
    // bitwise constants!
    case Network = 1
    case Initialization = 2
    case FakeFeed = 4
    case Debug = 8
    case Pushes = 16
    case Deserialization = 32
    var number: Int {return rawValue}
}

func PLLog(items: Any..., type: PLLogType = .Debug) {
    let logger = _PLLogger.shared
    if logger.enabled {
        if logger.level.containsType(type) {
            // TODO: add file logging
            for arg in items {
                print(arg)
            }
        }
    }
}

private class _PLLogger {
    private struct _PLLogLevel {
        let level: Int
        func containsType(type: PLLogType) -> Bool {
            return level & type.number > 0 ? true : false
        }
    }
    
    static let shared = _PLLogger()
    let enabled: Bool
    let level: _PLLogLevel
    init() {
        enabled = PLFacade.instance.settingsManager.loggingEnabled
        level = _PLLogLevel(level: PLFacade.instance.settingsManager.logLevel)
    }
}
