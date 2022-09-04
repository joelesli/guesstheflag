//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Joel Martinez on 9/1/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score: Int = 0
    let maxQuestions = 8
    @State private var questionCount = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0..<3)
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                Text("Guess the flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                Text("Score: \(score)")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                Text("\(questionCount) of \(maxQuestions) flag guesses")
                    .font(.caption.weight(.light))
                    .foregroundColor(.white)
                
                Spacer()
                VStack(spacing: 30) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(Color.white)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(Color.white)
                            .font(.largeTitle.weight(.heavy))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                        }
                        .cornerRadius(10.0)
                        .shadow(radius: 10)
                    }
                }
                .alert(scoreTitle, isPresented: $showingScore) {
                    let buttonTitle = canKeepPlaying() ? "Continue" : "Play again"
                    let action = canKeepPlaying() ? askQuestion : restartGame
                    Button(buttonTitle, action: action)
                } message: {
                    let message = canKeepPlaying() ? "Your score is \(score)" : "Your final score is \(score)"
                    Text(message)
                }
                
                
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        scoreTitle = number == correctAnswer ? "Correct" : "Wrong that is the Flag of \(countries[number])"
        score = number == correctAnswer ? score + 1 : score - 2
        showingScore = true
        questionCount += 1
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0..<3)
    }
    
    func restartGame() {
        questionCount = 0
        score = 0
        askQuestion()
    }
    
    func canKeepPlaying() -> Bool {
        questionCount < maxQuestions
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
