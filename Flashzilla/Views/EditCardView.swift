//
//  EditCardView.swift
//  Flashzilla
//
//  Created by Irakli Sokhaneishvili on 12.01.22.
//

import SwiftUI

struct EditCardView: View {
    
    @Environment(\.dismiss) var dismiss

    @State private var cards = [Card]()
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
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }
    func saveData() {
        if let data = try? JSONEncoder().encode(cards) {
            UserDefaults.standard.set(data, forKey: "Cards")
        }
    }
    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }
        
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        cards.insert(card, at: 0)
        saveData()
        newPrompt = ""
        newAnswer = ""
    }
    func removeCards(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
        saveData()
    }
}

struct EditCardView_Previews: PreviewProvider {
    static var previews: some View {
        EditCardView()
    }
}
