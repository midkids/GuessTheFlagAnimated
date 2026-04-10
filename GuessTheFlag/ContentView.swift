//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Myron Snelson on 8/23/25.
//

import SwiftUI

//  added this View Composition via Project 3 Part 2
// Views and modifiers: Wrap up
struct FlagImage: View {
    var imageString: String
    
    var body: some View {
        Image(imageString)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct CapsuleText: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .padding()
// can apply colors on a case by case basis
//            .foregroundStyle(.white)
            .background(.blue)
            .clipShape(.capsule)
    }
}


struct ContentView: View {
    // These array entries match our image assets
    @State private var countries: [String] = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var numberQuestionsAnswered = 0
    @State private var endingRound = false
    
    
    var body: some View {
        ZStack {
            /*
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
             */
            RadialGradient(stops: [
                // two stops with the same location
                // causes the colors to switch immediately (no gradient)
                // custom colors
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.5), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
                ],
                center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                // Spacer helps spacing on all size devices
                // use all available space neatly
                Spacer()
                Text("Guess the Flag")
                // using shortcut for .weight(bold)
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                // Outer VStack with controlled spacing
                VStack(spacing: 15) {
                    // Innner VStack using default spacing
                    VStack {
                        Text("Tap the flag of")
                        // Secondary is a semantic color
                        // which signifies its use rather than
                        // its hue. Here, secondary lets the
                        // background slightly shine through
                        // when used with a background of
                        // regular material
                            .foregroundStyle(.secondary)
                        // subheadline is a dynamic type
                        // it gets bigger or smaller
                        // according to the user settings
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                        // largeTitle is a dynamic type also
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            // There are four types of shapes
                            // rectangle, rounded rectangle
                            // circle, and capsule
                            // capsule looks good for buttons
                            //
                            // commented this out for Project 3
                            // Views and modifiers: wrap up
                            // Image(countries[number])
                            //    .clipShape(.capsule)
                            //    .shadow(radius: 5)
                            
                            // added this View Composition for Project 3 Part 2
                            // Views and modifiers: Wrap up
                            FlagImage(imageString: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                // helps spacing on all size devices
                // use all available space neatly
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                // divide themselves up neatly
                // In this case, we have four Spacers
                // They will divide up all the remaining space
                // Each Spacer will receive 1/4 the remaining space
                Spacer()
            }
            .padding()
        }
        // showingScore automatically set back to false
        // after alert dismissed by user
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            if scoreTitle == "Wrong!" {
                Text("That's not the flag of \(countries[correctAnswer])")
            } else {
                Text("Your score is: \(score)")
            }
        }
        
        // endingRound automatically set back to false
        // after alert dismissed by user
        .alert("Final Score", isPresented: $endingRound) {
            Button("Reset Game", action: resetGame)
        } message: {
                Text("After \(numberQuestionsAnswered) questions, your final score was: \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        numberQuestionsAnswered += 1
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
            } else {
                scoreTitle = "Wrong!"
                score -= 1
        }
        // causes alert by making the isPresented
        // condition (in this case showingScore) true
        showingScore = true
    }
    
    func askQuestion() {
        // set up new alert and condition if true here
        if numberQuestionsAnswered >= 8 {
            // causes alert by making the isPresented
            // condition (in this case endingRound) true
            endingRound = true
        } else {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
    }
    
    func resetGame() {
        score = 0
        numberQuestionsAnswered = 0
        askQuestion()
    }
}

#Preview {
    ContentView()
}
