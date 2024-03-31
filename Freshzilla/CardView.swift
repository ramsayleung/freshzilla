//
//  CardView.swift
//  Freshzilla
//
//  Created by ramsayleung on 2024-03-28.
//

import SwiftUI
extension RoundedRectangle {
    func fillByOffset(for width: CGFloat)  -> some View {
        if width == 0 {
            return self.fill(.white)
        } else if width > 0 {
            return self.fill(.green)
        } else {
            return self.fill(.red)
        }
    }
}

struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    
    let card: Card
    var removal: ((Bool) -> Void)? = nil
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    accessibilityDifferentiateWithoutColor ? .white:
                    .white.opacity(1 - Double(abs(offset.width / 50))))
                .background(
                    accessibilityDifferentiateWithoutColor ? nil :
                    RoundedRectangle(cornerRadius: 25)
                        .fillByOffset(for: offset.width)
                )
                .shadow(radius: 10)
            
            VStack {
                if accessibilityVoiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                    
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 400, height: 250)
        .rotationEffect(.degrees(offset.width / 5.0))
        .offset(x: offset.width * 5)
        .opacity(2 - Double(abs(offset.width / 50)))
        .accessibilityAddTraits(.isButton)
        .gesture(DragGesture()
            .onChanged { gesture in
                offset = gesture.translation
            }
            .onEnded { _ in
                if abs(offset.width) > 100 {
                    // remove the card
                    let isCorrect = offset.width > 0
                    removal?(isCorrect)
                } else{
                    offset = .zero
                }
            }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.bouncy, value: offset)
    }
}

#Preview {
    CardView(card: Card.example)
}
