//
//  MealListView.swift
//  FetchProject
//
//  Created by Craig Swanson on 7/1/24.
//

import SwiftUI

struct MealListView: View {
    
    @StateObject var mealViewModel = MealViewModel()
    @State var desserts: [Meal]?
    
    var body: some View {
        NavigationView {
            if let desserts {
                List(desserts, id: \.idMeal) { dessert in
                    NavigationLink(destination: MealDetailView(meal: dessert)) {
                        HStack {
                            AsyncImage(url: URL(string: dessert.strMealThumb ?? "")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)

                            Text(dessert.strMeal ?? "")
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
                let meals = try await mealViewModel.fetchDesserts()
                desserts = meals
            } catch {
                print("Error: \(error)")
            }
        }
        .environmentObject(mealViewModel)
    }
}

