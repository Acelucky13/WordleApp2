//
//  KeyboardCell.swift
//  Wordle
//
//  Created by Mari Batilando on 2/12/23.
//

import UIKit

class KeyboardCell: UICollectionViewCell {
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var labelContainerView: UIView!
  private var string: String!
  var didSelectString: ((String) -> Void)!
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapString))
    contentView.addGestureRecognizer(tapGestureRecognizer)
  }

  func configure(with string: String) {
    labelContainerView.layer.cornerRadius = 4.0
    labelContainerView.backgroundColor = .gray
    self.string = string
    label.text = string
  }

  @objc private func didTapString() {
    didSelectString(string)
  }
}
