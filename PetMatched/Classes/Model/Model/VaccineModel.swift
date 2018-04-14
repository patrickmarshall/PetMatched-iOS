//
//  VaccineModel.swift
//  PetMatched
//
//  Created by Patrick Marshall on 4/9/18.
//  Copyright © 2018 Patrick Marshall. All rights reserved.
//

import Foundation

public struct VaccineModel {
    public var id: Int?
    public var name: String?
    public var selected: Bool?
    
    public init(id: Int?, name: String?) {
        self.id = id
        self.name = name
        self.selected = false
    }
}
