//
//  MealDetailView.swift
//  FetchProject
//
//  Created by Craig Swanson on 7/5/24.
//

/// View that shows the details of a meal. Elements displayed are an image of the meal, ingredients and measurements, and instructions for the meal.

import SwiftUI

struct MealDetailView: View {
    
    @EnvironmentObject var mealViewModel: MealViewModel
    @State var meal: Meal
    
    var body: some View {
        ScrollView {
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
                
                // If the view has loaded but the ingredients array is still empty, display an alternate message.
                if !mealViewModel.ingredientPairs.isEmpty {
                    // When the ingredients array is populated, create HStack views with each one consisting of the ingredient name followed by the measurement amount.
                    ForEach(mealViewModel.ingredientPairs) { pair in
                        HStack {
                            Text(pair.ingredient)
                            Text(pair.measurement)
                                .padding(.horizontal )
                            Spacer()
                        }
                    }
                } else {
                    Text("Loading dessert details.")
                        .font(.largeTitle)
                }
                
                // Instructions
                Text("Instructions")
                    .font(.headline)
                    .padding(.vertical)
                Text(mealViewModel.mealDetail?.strInstructions ?? "No instructions were found.")
            }
        }
        .padding()
        .navigationTitle(meal.strMeal ?? "")
        .multilineTextAlignment(.leading)
        .task {
            do {
                try await mealViewModel.fetchMealDetail(meal)
            } catch {
                // If an error is encountered, print a message to the console.
                print(error)
            }
        }
        // If an error is encountered, present a message to the user.
        .alert("Error", isPresented: $mealViewModel.presentError, actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text(mealViewModel.errorMessage)
        })
    }
}
