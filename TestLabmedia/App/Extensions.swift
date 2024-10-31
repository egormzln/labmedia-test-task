//
//  Extensions.swift
//  TestLabmedia
//
//  Created by Егор Мизюлин on 29.10.2024.
//

import UIKit

extension String {
    func capitalizingFirstWord() -> String {
        guard let firstLetter = self.first else { return self }
        let capitalizedFirstLetter = String(firstLetter).uppercased()
        let remainingString = self.dropFirst()
        return capitalizedFirstLetter + remainingString
    }
}

extension UIImageView {
    func loadImage(_ url: String) {
        if let imageUrl = URL(string: url) {
            URLSession.shared.dataTask(with: imageUrl) { [weak self] data, _, error in
                guard let self = self, let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
