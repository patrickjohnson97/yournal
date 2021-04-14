//
//  WelcomeScreenView.swift
//  yournal
//
//  Created by Patrick Johnson on 3/22/21.
//

import SwiftUI

struct WelcomeScreenView: View {
    @Binding var showWelcomeScreen: Bool
    
    var body: some View {
        ZStack{
            Background()
            VStack {
                Spacer()
                Text("Welcome to")
                    .font(.system(.largeTitle, design: .serif))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 48)
                Text("Yournal")
                    .font(.system(.largeTitle, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(.accentColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 48)
                Spacer()
                
                VStack(spacing: 24) {
                    FeatureCell(image: "doc.append.fill", title: "Capture Moments", subtitle: "Easily record and relive your most treasured memories.", color: .green)
                    
                    FeatureCell(image: "face.smiling.fill", title: "Analyze Mood", subtitle: "Track your mood automatically through an Artificial Assistant.", color: .blue)
                    
                    FeatureCell(image: "lock.fill", title: "Secure Data", subtitle: "Your data belongs to you - no ifs, ands, or buts.", color: .red)
                }
                .padding(.leading)
                
                Spacer()
                Spacer()
                
                Button(action: { self.showWelcomeScreen = false }) {
                    HStack {
                        Spacer()
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
                .frame(height: 50)
                .background(Color.blue)
                .cornerRadius(15)
            }
            .padding()
        }
    }
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreenView(showWelcomeScreen: .constant(true))
    }
}

struct FeatureCell: View {
    var image: String
    var title: String
    var subtitle: String
    var color: Color
    
    var body: some View {
        HStack(spacing: 24) {
            Image(systemName: image)
                //                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(subtitle)
                    .foregroundColor(.secondary)
                    .font(.system(.subheadline, design: .serif))
            }
            
            Spacer()
        }
    }
}
