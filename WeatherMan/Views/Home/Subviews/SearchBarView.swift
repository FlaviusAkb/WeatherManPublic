//
//  SearchView.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 21.12.2023.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var selectedCity: String
    @Binding var isSearching: Bool
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            if isSearching {
                SearchView(searchText: $searchText, isSearching: $isSearching)
            } else {
                SuggestionsView(
                    selectedCity: $selectedCity,
                    isSearching: $isSearching,
                    searchText: $searchText)
                Spacer()
                SearchButtonView(isSearching: $isSearching, searchText: $searchText)
            }
        }
        .padding(.horizontal)
        .foregroundColor(.black)
        .font(.headline.bold())
    }
}

#Preview {
    HomeView()
}

struct SearchView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @Binding var searchText: String
    @Binding var isSearching: Bool
    
    var body: some View {
        TextField("Search for a city", text: $searchText, onCommit: { submit() })
            .textFieldStyle(RoundedBorderTextFieldStyle())
        
        Button(action: {
            withAnimation {
                isSearching = false
            }
        }) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.gray)
                .imageScale(.large)
        }
        Button("Submit") { submit() }
    }
    
    @MainActor func submit() {
        if !searchText.isEmpty {
            viewModel.submitLocation(text:searchText)
        } else {
            print("Enter a city name")
            AlertManager.shared.showAlert(title: "Error", message: "Enter a city name")
        }
    }
}

struct SuggestionsView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    @Binding var selectedCity: String
    @Binding var isSearching: Bool
    @Binding var searchText: String
    
    var body: some View {
        Menu {
            ForEach(Array(CacheManager.shared.suggestions), id: \.self) { city in
                Button(action: {
                    selectedCity = city
                    searchText = city
                    viewModel.submitLocation(text:searchText)
                }) {
                    HStack {
                        Text(city)
                        if selectedCity == city {
                            Image(systemName: "chevron.down")
                        }
                    }
                }
            }

        } label: {
            Image(systemName: "map")
            Text(selectedCity)
                .padding()
            Image(systemName: "arrowtriangle.down.fill")
                .imageScale(.small)
        }
    }
}

struct SearchButtonView: View {
    @Binding var isSearching: Bool
    @Binding var searchText: String
    
    var body: some View {
        Button(action: {
            withAnimation {
                isSearching.toggle()
                if isSearching {
                    searchText = ""
                }
            }
        }) {
            Image(systemName: isSearching ? "chevron.down" : "magnifyingglass")
                .imageScale(.large)
        }
    }
}
