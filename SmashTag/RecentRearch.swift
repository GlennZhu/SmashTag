//
//  RecentRearch.swift
//  SmashTag
//
//  Created by Ziliang Zhu on 10/25/15.
//  Copyright (c) 2015 Austurela. All rights reserved.
//

import Foundation

class RecentSearches {
    
    private struct Const {
        static let ValuesKey = "RecentSearches.Values"
        static let NumberOfSearches = 100
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    private var values: [String] {
        get {
            return defaults.objectForKey(Const.ValuesKey) as? [String] ?? [String]()
        }
        set {
            defaults.setObject(newValue, forKey: Const.ValuesKey)
            println("newValue \(newValue)")
        }
    }
    
    func getSearch() -> [String] {
        return values
    }
    
    func addSearch(search: String) {
        var thisValues = values
        if let index = find(thisValues, search) {
            thisValues.removeAtIndex(index)
        }
        thisValues.insert(search, atIndex: 0)
        while thisValues.count > Const.NumberOfSearches {
            thisValues.removeLast()
        }
        values = thisValues
    }
}