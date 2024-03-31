//
//  ContentView.swift
//  Freshzilla
//
//  Created by ramsayleung on 2024-03-26.
//

import SwiftUI
extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    @Environment(\.scenePhase) var scenePhase
    
    @State private var showEditingScreen = false
    @State private var isActive = false
    @State private var cards = [Card]()
    @State private var timeRemaining = 100
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                
                ZStack {
                    ForEach(cards) { card in
                        CardView(card: card) {isCorrect in
                            withAnimation {
                                removeCard(isCorrectAnswer: isCorrect, at: findIndexById(id: card.id))
                            }
                        }
                        .stacked(at: findIndexById(id: card.id), in: cards.count)
                        // only allow to drag the top card
                        .allowsHitTesting(findIndexById(id: card.id) == cards.count - 1)
                        .accessibilityHidden(findIndexById(id: card.id) < cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty {
                    Button("Start again", action: resetCard)
                        .padding()
                        .foregroundColor(.black)
                        .background(.white)
                        .clipShape(Capsule())
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showEditingScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
                Spacer()
            }
            
            if accessibilityDifferentiateWithoutColor || accessibilityVoiceOverEnabled {
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            withAnimation {
                                removeCard(isCorrectAnswer: false, at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect.")
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                removeCard(isCorrectAnswer: true, at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct.")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }.onReceive(timer){time in
            guard isActive else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }.onChange(of: scenePhase){
            if scenePhase == .active {
                if !cards.isEmpty{
                    isActive = true
                }
            } else {
                isActive = false
            }
        }.sheet(isPresented: $showEditingScreen, onDismiss: resetCard) {
            EditCardsView()
        }.onAppear(perform: resetCard)
    }
    
    // O(N) time complexity
    func findIndexById(id target: UUID) -> Int {
        if let index = cards.firstIndex(where: { $0.id == target }) {
            return index
        } else {
            return -1
        }
    }
    
    func removeCard(isCorrectAnswer: Bool, at index: Int){
        guard index >= 0 else { return }
        
        var removedCard = cards[index]
        cards.remove(at: index)
        removedCard.id = UUID()
        
        if !isCorrectAnswer {
            cards.insert(removedCard, at: 0)
            print("insert incorrect card back into cards: \(cards)")
        }
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func loadData() {
        cards = CardStorage.loadData()
    }
    
    func resetCard(){
        loadData()
        timeRemaining = 100
        isActive = true
    }
}

#Preview {
    ContentView()
}
