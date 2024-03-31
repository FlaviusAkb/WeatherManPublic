//
//  AlertCardView.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 19.12.2023.
//

import SwiftUI

struct AlertCardView: View {
    var title: String
    var caption: String
    var background: Color
    var symbol: String
    
    var body: some View {
        VStack{
            HStack {
                Image(systemName: symbol)
                    .symbolRenderingMode(.multicolor)
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .multilineTextAlignment(.leading)
                        .font(.title3.bold())
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(caption)
                }
                Spacer()
            }
            
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(background))
        .foregroundStyle(Color.black)
    }
}

#Preview {
    HomeView()
}
