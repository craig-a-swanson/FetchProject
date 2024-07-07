//
//  MealDetailView.swift
//  FetchProject
//
//  Created by Craig Swanson on 7/5/24.
//

import SwiftUI

struct MealDetailView: View {
    
    @EnvironmentObject var mealViewModel: MealViewModel
    @State var meal: Meal
    @State var mealDetails: Meal?
    @State var ingredientPairs: [IngredientPair]?
    
    var body: some View {
        ScrollView {
            if let ingredientPairs {
                VStack {
                    // Image of dessert
                    AsyncImage(url: URL(string: meal.strMealThumb ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 250, height: 250)
                    
                    // Ingredients and measurements
                    Text("Ingredients")
                        .font(.headline)
                        .padding(.vertical)
                    
                    ForEach(ingredientPairs) { pair in
                        HStack {
                            Text(pair.ingredient)
                            Text(pair.measurement)
                                .padding(.horizontal )
                            Spacer()
                        }
                    }
                    
                    // Instructions
                    Text("Instructions")
                        .font(.headline)
                        .padding(.vertical)
                    Text(self.mealDetails?.strInstructions ?? "No instructions were found.")
                }
            }
        }
        .padding()
        .navigationTitle(meal.strMeal ?? "")
        .multilineTextAlignment(.leading)
        .task {
            do {
                self.mealDetails = try await mealViewModel.fetchMealDetail(meal)
                self.ingredientPairs = self.mealDetails?.getIngredientsPairs()
            } catch {
                print(error)
            }
        }
    }
}
