//
//  LetterCell.swift
//  Wordle
//
//  Created by Mari Batilando on 2/12/23.
//

import UIKit

enum LetterCellStyle {
  case initial
  case incorrect
  case correctLetterOnly
  case correctLetterAndPosition
}

class LetterCell: UICollectionViewCell {
  
  @IBOutlet weak var letterLabel: UILabel!
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    layer.borderWidth = 2.0
    layer.borderColor = UIColor.gray.cgColor
  }
  
  // MARK: - Public Methods
  func set(letter: String) {
    letterLabel.text = letter
  }
  
  func clearLetter() {
    letterLabel.text = ""
  }
  
  func set(style: LetterCellStyle) {
    switch style {
    case .initial:
      contentView.backgroundColor = .black
      layer.borderColor = UIColor.gray.cgColor
    case .incorrect:
      let color = UIColor(red: 0.23, green: 0.23, blue: 0.24, alpha: 1.0)
      contentView.backgroundColor = color
      layer.borderColor = color.cgColor
    case .correctLetterOnly:
      let color = UIColor(red: 0.69, green: 0.63, blue: 0.30, alpha: 1.0)
      contentView.backgroundColor = color
      layer.borderColor = color.cgColor
    case .correctLetterAndPosition:
      let color = UIColor(red: 0.38, green: 0.55, blue: 0.33, alpha: 1.0)
      contentView.backgroundColor = color
      layer.borderColor = color.cgColor
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    letterLabel.text = nil
    contentView.backgroundColor = .black
    layer.borderColor = UIColor.gray.cgColor
  }
}
