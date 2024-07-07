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
    
    /// Network call to the provided URL which returns a data type corresponding to an array of dessert meals.
    func fetchDesserts() async throws {
        let urlString = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
        guard let url = URL(string: urlString) else {
            showError(with: .invalidURL)
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
           (200..<300).contains(response.statusCode) else {
            showError(with: .invalidURLResponseCode)
            throw NetworkError.invalidURLResponseCode
        }
        do {
            let results = try JSONDecoder().decode(Results.self, from: data)
            DispatchQueue.main.async {
                self.meals = results.meals
            }
        } catch {
            showError(with: .decodingError)
            throw NetworkError.decodingError
        }
    }
    
    /// Network call that returns details for the requested meal.
    /// - Parameter meal: The ID for the meal requested.
    func fetchMealDetail(_ meal: Meal) async throws {
        guard let mealID = meal.idMeal else {
            showError(with: .mealNotAvailable)
            throw NetworkError.mealNotAvailable
        }
        var urlString = "https://themealdb.com/api/json/v1/1/lookup.php?i="
        urlString = urlString + mealID
        
        guard let url = URL(string: urlString) else {
            showError(with: .invalidURL)
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              (200..<300).contains(response.statusCode) else {
            showError(with: .invalidURLResponseCode)
            throw NetworkError.invalidURLResponseCode
        }
        
        do {
            let results = try JSONDecoder().decode(Results.self, from: data)
            guard let mealDetail = results.meals.first else {
                showError(with: .mealNotAvailable)
                throw NetworkError.mealNotAvailable
            }
            DispatchQueue.main.async {
                self.mealDetail = mealDetail
                self.ingredientPairs = self.mealDetail?.getIngredientsPairs() ?? []
            }
        } catch {
            showError(with: .decodingError)
            throw NetworkError.decodingError
        }
    }
    
    /// If a NetworkError is encountered, this method will set an alert error message and set a boolean used by the UI to display the message.
    /// - Parameter error: A description of the error message.
    func showError(with error: NetworkError) {
        DispatchQueue.main.async {
            self.errorMessage = error.errorDescription
            self.presentError = true
        }
    }
}
