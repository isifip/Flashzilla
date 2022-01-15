//
//  ContentView.swift
//  Flashzilla
//
//  Created by Irakli Sokhaneishvili on 12.01.22.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView: View {
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @State private var cards = [Card]()
    
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    
    @State private var showingEditScreen = false

    var body: some View {
        
        ZStack {
            Color.purple
                .ignoresSafeArea()
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle).fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .background(.gray.opacity(0.7))
                    .cornerRadius(20)
                    .shadow(radius: 12)
                ZStack {
                    ForEach(Array(cards.enumerated()), id: \.element) { item in
                        //let index = cards.firstIndex(of: card)!
                        CardView(card: item.element) { reinsert in
                            withAnimation {
                                removeCard(at: item.offset, reinsert: reinsert)
                            }
                        }
                        .stacked(at: item.offset, in: cards.count)
                        .allowsTightening(item.offset == cards.count - 1)
                        .accessibilityHidden(item.offset < cards.count - 1)
                    }
                }
                .allowsTightening(timeRemaining > 0)
                if cards.isEmpty {
                    Button {
                        resetcards()
                    } label: {
                        Text("Start again")
                            .font(.headline)
                            .padding()
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                    }

                }
            }
            .onReceive(timer) { time in
                guard isActive else { return }
                if timeRemaining > 0 {
                    timeRemaining -= 1
                }
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    if cards.isEmpty == false {
                        isActive = true
                    }
                } else {
                    isActive = false
                }
            }
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(.gray.opacity(0.7))
                            .clipShape(Circle())
                            .shadow(radius: 12)
                    }
                    .padding()
                }
                Spacer()
            }
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1, reinsert: true)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect")
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1, reinsert: false)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct")
                    }
                    .foregroundColor(.white)
                    .font(.title2)
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetcards, content: EditCardView.init)
        .onAppear(perform: resetcards)
    }
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }
    func removeCard(at index: Int, reinsert: Bool) {
        guard index >= 0 else { return }
        if reinsert {
            cards.move(fromOffsets: IndexSet(integer: index), toOffset: 0)
        } else {
            cards.remove(at: index)
        }
        if cards.isEmpty {
            isActive = false
        }
    }
    func resetcards() {
        timeRemaining = 100
        isActive = true
        loadData()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            //.preferredColorScheme(.dark)
            .previewInterfaceOrientation(.landscapeRight)
    }
}
