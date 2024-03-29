//
//  CardView.swift
//  Freshzilla
//
//  Created by ramsayleung on 2024-03-28.
//

import SwiftUI

struct CardView: View {
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    let card: Card
    var removal: (() -> Void)? = nil
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(.white)
                .shadow(radius: 10)
            
            VStack {
                Text(card.prompt)
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                
                if isShowingAnswer {
                    Text(card.answer)
                        .font(.title)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 400, height: 250)
        .rotationEffect(.degrees(offset.width / 5.0))
        .offset(x: offset.width * 5)
        .opacity(2 - Double(abs(offset.width / 50)))
        .gesture(DragGesture()
            .onChanged { gesture in
                offset = gesture.translation
            }
            .onEnded { _ in
                if abs(offset.width) > 100 {
                    // remove the card
                    removal?()
                } else{
                    offset = .zero
                }
            }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
    }
}

#Preview {
    CardView(card: Card.example)
}
