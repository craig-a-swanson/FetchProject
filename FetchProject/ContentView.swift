//
//  ContentView.swift
//  FetchProject
//
//  Created by Craig Swanson on 7/1/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var desserts: [Meal]?
    
    var body: some View {
        ZStack {
            if let desserts {
                List(desserts, id: \.idMeal) { dessert in
                    HStack {
                        AsyncImage(url: URL(string: dessert.strMealThumb)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)

                        Text(dessert.strMeal)
                    }
                }
            } else {
                Text("Loading desserts.")
                    .font(.largeTitle)
            }
        }
        .task {
            do {
                let meals = try await fetchDesserts()
                desserts = meals
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func fetchDesserts() async throws -> [Meal] {
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
            return results.meals
        } catch {
            throw NetworkError.decodingError
        }
        
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidURLResponseCode
    case decodingError
}
