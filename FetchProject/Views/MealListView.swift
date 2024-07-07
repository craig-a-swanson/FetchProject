//
//  MealListView.swift
//  FetchProject
//
//  Created by Craig Swanson on 7/1/24.
//

/// View that displays a list of meal items. Tapping on the item will navigate to the meal detail view.

import SwiftUI

struct MealListView: View {
    
    @StateObject var mealViewModel = MealViewModel()
    
    var body: some View {
        NavigationView {
            
            // If the view has loaded but the meals array is still empty, display an alternate message.
            if !mealViewModel.meals.isEmpty {
                
                // When the meals array is populated, create a list with each row consisting of an image of the meal and the meal name.
                List(mealViewModel.meals, id: \.idMeal) { meal in
                    NavigationLink(destination: MealDetailView(meal: meal)) {
                        HStack {
                            AsyncImage(url: URL(string: meal.strMealThumb ?? "")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)

                            Text(meal.strMeal ?? "")
                        }
                    }
                }
                .navigationTitle("Desserts 🍰")
            } else {
                Text("Loading desserts.")
                    .font(.largeTitle)
            }
        }
        .task {
            do {
                try await mealViewModel.fetchDesserts()
            } catch {
                print("Error: \(error)")
            }
        }
        .environmentObject(mealViewModel)
    }
}

