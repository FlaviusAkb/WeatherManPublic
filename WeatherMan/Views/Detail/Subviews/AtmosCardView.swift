//
//  AtmosCardView.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 20.12.2023.
//

import SwiftUI

struct AtmosCardView: View {
    var title: String
    var caption: String
    var background: Color
    var symbol: String
    
    var body: some View {
        VStack{
            HStack {
                Image(systemName: symbol)
                    .symbolRenderingMode(.multicolor)
                    .foregroundColor(.blue)
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .multilineTextAlignment(.leading)
                        .font(.subheadline.bold())
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(caption)
                        .font(.custom("SF Pro Display", size: 13))
                        .fontWeight(.regular)
                        .foregroundColor(Color.atmosCaption)
                        .fixedSize(horizontal: false, vertical: true)
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
