//
//  Meal+Extensions.swift
//  FetchProject
//
//  Created by Craig Swanson on 7/5/24.
//

import Foundation

extension Meal {
    
    func getIngredientsPairs() -> [IngredientPair] {
        var ingredientPairs: [IngredientPair] = []
        let measurements = self.getMeasurements()
        let ingredientArray: [String?] = [self.strIngredient1,
                                          self.strIngredient2,
                                          self.strIngredient3,
                                          self.strIngredient4,
                                          self.strIngredient5,
                                          self.strIngredient6,
                                          self.strIngredient7,
                                          self.strIngredient8,
                                          self.strIngredient9,
                                          self.strIngredient10,
                                          self.strIngredient11,
                                          self.strIngredient12,
                                          self.strIngredient13,
                                          self.strIngredient14,
                                          self.strIngredient15,
                                          self.strIngredient16,
                                          self.strIngredient17,
                                          self.strIngredient18,
                                          self.strIngredient19,
                                          self.strIngredient20]
        
        for (idx, ingredient) in ingredientArray.enumerated() {
            guard let ingredient else { continue }
            if !ingredient.isEmpty {
                ingredientPairs.append(IngredientPair(ingredient: ingredient, measurement: measurements[idx] ?? ""))
            }
        }
        return ingredientPairs
    }
    
    func getMeasurements() -> [String?] {
        return [self.strMeasure1,
                self.strMeasure2,
                self.strMeasure3,
                self.strMeasure4,
                self.strMeasure5,
                self.strMeasure6,
                self.strMeasure7,
                self.strMeasure8,
                self.strMeasure9,
                self.strMeasure10,
                self.strMeasure11,
                self.strMeasure12,
                self.strMeasure13,
                self.strMeasure14,
                self.strMeasure15,
                self.strMeasure16,
                self.strMeasure17,
                self.strMeasure18,
                self.strMeasure19,
                self.strMeasure20]
    }
}
