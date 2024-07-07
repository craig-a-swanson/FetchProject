//
//  MealViewModel.swift
//  FetchProject
//
//  Created by Craig Swanson on 7/5/24.
//

import SwiftUI

final class MealViewModel: ObservableObject {
    
    @Published var meals: [Meal] = []
    @Published var mealDetail: Meal?
    @Published var ingredientPairs: [IngredientPair] = []
    @Published var presentError = false
    @Published var errorMessage = ""
    
    func fetchDesserts() async throws {
        let urlString = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
           (200..<300).contains(response.statusCode) else {
            throw NetworkError.invalidURLResponseCode
        }
        do {
            let results = try JSONDecoder().decode(Results.self, from: data)
            DispatchQueue.main.async {
                self.meals = results.meals
            }
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func fetchMealDetail(_ meal: Meal) async throws {
        guard let mealID = meal.idMeal else {
            throw NetworkError.mealNotAvailable
        }
        var urlString = "https://themealdb.com/api/json/v1/1/lookup.php?i="
        urlString = urlString + mealID
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              (200..<300).contains(response.statusCode) else {
            throw NetworkError.invalidURLResponseCode
        }
        
        do {
            let results = try JSONDecoder().decode(Results.self, from: data)
            guard let mealDetail = results.meals.first else {
                throw NetworkError.mealNotAvailable
            }
            DispatchQueue.main.async {
                self.mealDetail = mealDetail
                self.ingredientPairs = self.mealDetail?.getIngredientsPairs() ?? []
            }
        } catch {
            throw NetworkError.decodingError
        }
    }
}
