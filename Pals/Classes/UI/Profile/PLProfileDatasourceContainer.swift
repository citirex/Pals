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
            self.datasource = PLOrderDatasource()
        }
        
        init(datasource: PLOrderDatasource) {
            self.datasource = datasource
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
    
    func switchDatasource(type: PLCollectionSectionType) {
        switch type {
        case .Drinks:
            currentDatasourceC = drinks
        case .Covers:
            currentDatasourceC = covers
        }
    }
    
    func saveOffset(offset: CGPoint, forType type:PLCollectionSectionType) {
        switch type {
        case .Drinks:
            drinks.offset = offset
        case .Covers:
            covers.offset = offset
        }
    }
    
}
