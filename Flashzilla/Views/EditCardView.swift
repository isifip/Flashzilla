//
//  EditCardView.swift
//  Flashzilla
//
//  Created by Irakli Sokhaneishvili on 12.01.22.
//

import SwiftUI

struct EditCardView: View {
    
    @Environment(\.dismiss) var dismiss

    @State private var cards = DataManager.load()
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    
    var body: some View {
        NavigationView {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add card", action: addCard)
                }
                Section {
                    ForEach(0..<cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(cards[index].prompt)
                                .font(.headline)
                            Text(cards[index].answer)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar {
                Button("Done", action: done)
            }
            
        }
    }
    func done() {
        dismiss()
    }

    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }
        
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        cards.insert(card, at: 0)
        DataManager.save(cards)
        newPrompt = ""
        newAnswer = ""
    }
    func removeCards(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
        DataManager.save(cards)
    }
}

struct EditCardView_Previews: PreviewProvider {
    static var previews: some View {
        EditCardView()
    }
}
