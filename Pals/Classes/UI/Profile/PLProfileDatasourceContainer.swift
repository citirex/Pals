//
//  PLProfileDatasourceContainer.swift
//  Pals
//
//  Created by ruckef on 19.09.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLProfileDatasourceSwitcher {
    
    struct PLProfileDatasourceContainer {
        let datasource: PLOrderDatasource
        var offset = CGPointZero
        
        init(){
            datasource = PLOrderDatasource()
        }
        
        init(datasource: PLOrderDatasource) {
            self.datasource = datasource
        }
        
        mutating func clean() {
            offset = CGPointZero
            datasource.clean()
        }
    }
    
    private var drinks = PLProfileDatasourceContainer(datasource: PLOrderDatasource(orderType: .Drinks))
    private var covers = PLProfileDatasourceContainer(datasource: PLOrderDatasource(orderType: .Covers))
    private var currentDatasourceC = PLProfileDatasourceContainer()

    var currentDatasource: PLOrderDatasource { return currentDatasourceC.datasource }
    var currentOffset: CGPoint { return currentDatasourceC.offset }
    
    func updateUserId(id: UInt64) {
        drinks.datasource.userId = id
        covers.datasource.userId = id
    }
    
    func switchDatasource(orderSection: PLOrderSection) {
        switch orderSection {
        case .Drinks:
            currentDatasourceC = drinks
        case .Covers:
            currentDatasourceC = covers
        }
    }
    
    func saveOffset(offset: CGPoint, inSection orderSection: PLOrderSection) {
        switch orderSection {
        case .Drinks:
            drinks.offset = offset
        case .Covers:
            covers.offset = offset
        }
    }
    
    func resetOffset(inSection orderSection: PLOrderSection) {
        saveOffset(CGPointZero, inSection: orderSection)
    }
    
    func clear() {
        drinks.clean()
        covers.clean()
    }
    
}
