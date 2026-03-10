//
//  CommentGenerator.swift
//  SequisImage
//
//  Created by Ade Reskita on 10/03/26.
//

import Foundation

final class CommentGenerator {
    private var firstNames: [String] = []
    private var lastNames: [String] = []
    private var verbs: [String] = []
    private var nouns: [String] = []

    init() {
        loadData()
    }

    private func loadData() {
        firstNames = loadJSON(filename: "firstNames")
        lastNames = loadJSON(filename: "lastNames")
        verbs = loadJSON(filename: "verbs")
        nouns = loadJSON(filename: "nouns")
    }

    private func loadJSON(filename: String) -> [String] {
        guard
            let url = Bundle.main.url(
                forResource: filename, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let strings = try? JSONDecoder().decode([String].self, from: data)
        else {
            print("Failed to load \(filename).json")
            return []
        }
        return strings
    }

    func generateComment(forImageId imageId: String) -> CommentItem {
        let firstName = firstNames.randomElement() ?? "Jane"
        let lastName = lastNames.randomElement() ?? "Doe"
        let fullName = "\(firstName) \(lastName)"

        // Initials
        let f = firstName.first.map { String($0) } ?? "J"
        let l = lastName.first.map { String($0) } ?? "D"
        let initials = (f + l).uppercased()

        // Generate random length text of 10 to 20 words mixing verbs and nouns)
        let wordCount = Int.random(in: 10...20)
        var words: [String] = []
        for _ in 0..<wordCount {
            if Bool.random() {
                words.append(verbs.randomElement() ?? "do")
            } else {
                words.append(nouns.randomElement() ?? "thing")
            }
        }
        let text = words.joined(separator: " ")

        return CommentItem(
            id: UUID(),
            imageId: imageId,
            authorInitials: initials,
            authorName: fullName,
            text: text,
            createdAt: Date()
        )
    }
}
