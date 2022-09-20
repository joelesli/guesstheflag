//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Joel Martinez on 9/1/22.
//

import SwiftUI

struct FlagButton: View {
    let imageName : String
    let callBack: (() -> Void)
    
    var body: some View {
        Button {
            callBack()
        } label: {
            Image(imageName)
                .renderingMode(.original)
        }
        .cornerRadius(10.0)
        .shadow(radius: 10)
    }
}

struct WhiteForeground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
    }
}

extension View {
    func whiteForeground() -> some View {
        modifier(WhiteForeground())
    }
}

struct ContentView: View {
    @State private var showingFeedback = false
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
                    .whiteForeground()
                Text("Score: \(score)")
                    .font(.title3.bold())
                    .whiteForeground()
                Text("\(questionCount) of \(maxQuestions) flag guesses")
                    .font(.caption.weight(.light))
                    .whiteForeground()
                
                Spacer()
                VStack(spacing: 30) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .whiteForeground()
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.heavy))
                            .whiteForeground()
                    }
                    
                    ForEach(0..<3) { number in
                        FlagButton(imageName: countries[number]) {
                            flagTapped(number)
                        }
                        .opacity(!showingFeedback ? 1 : alphaForFlag(number)) //set wrong answer to 0.5 alpha
                        .animation(.easeInOut, value: showingFeedback)
                    }
                }
                .alert(scoreTitle, isPresented: $showingFeedback) {
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
    
    func alphaForFlag(_ number: Int) -> Double {
        isCorrect(number) ? 1 : 0.25
    }
    
    func isCorrect(_ number: Int) -> Bool {
        number == correctAnswer
    }
    
    func flagTapped(_ number: Int) {
        scoreTitle = isCorrect(number) ? "Correct" : "Wrong, that is the Flag of \(countries[number])"
        score = number == correctAnswer ? score + 1 : score - 2
        showingFeedback = true
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
