//
//  APIKeyView.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 08.12.2023.
//

import SwiftUI

struct APIKeyView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = APIKeyViewModel()
    
    var body: some View {
        VStack {
            Text("Weather API Key:")
                .font(.title.bold())
            SecureField("Enter API Key", text: $viewModel.apiKey)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text(viewModel.apiKey)
                .foregroundStyle(.gray)
            
            HStack {
                Button("Check API Key") {
                    viewModel.saveAPIKey()
                    viewModel.checkApiKey()
                }
                
                Button("Reset API Key") {
                    viewModel.apiKey = ""
                    viewModel.saveAPIKey()
                }
            }
            .padding()
            
            Button("Save API Key") {
                viewModel.saveAPIKey()
                dismiss()
            }
            Button("RC Key") {
                APIManager.shared.updateKey()
                dismiss()
            }
        }
        .padding()
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(AlertManager.shared.alertTitle),
                message: Text(AlertManager.shared.alertMessage),
                dismissButton: .default(Text("OK")) { AlertManager.shared.showAlert = false }
            )
        }
        .onChange(of: viewModel.apiKey) {
            APIManager.shared.apiKey = viewModel.apiKey
        }
    }
}

#Preview {
    APIKeyView()
}
