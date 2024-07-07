//
//  IngredientPair.swift
//  FetchProject
//
//  Created by Craig Swanson on 7/5/24.
//

/// Object used to couple meal ingredients with their corresponding measurement amounts.

import Foundation

struct IngredientPair: Identifiable, Hashable {
    let ingredient: String
    let measurement: String
    var id: String { ingredient + measurement }
}
