//
//  Extensions.swift
//  TestLabmedia
//
//  Created by Егор Мизюлин on 29.10.2024.
//

extension String {
    func capitalizingFirstWord() -> String {
        guard let firstLetter = self.first else { return self }
        let capitalizedFirstLetter = String(firstLetter).uppercased()
        let remainingString = self.dropFirst()
        return capitalizedFirstLetter + remainingString
    }
}
