//
//  KeyboardController+Extensions.swift
//  Wordle
//
//  Created by Mari Batilando on 3/1/23.
//

import Foundation
import UIKit

extension KeyboardController {
  
  var itemPadding: Double { 6 }
  var sectionPadding: Double { 8 }
  var numSections: Int { 3 }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 3
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: sectionPadding, left: 0, bottom: 0, right: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return itemPadding
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
      
    let numItemsInRow = Double(numItems(in: indexPath.section))

    let horizontalPadding = itemPadding * (numItemsInRow - 1)
    let horizontalSpace = collectionView.frame.size.width - horizontalPadding
    let cellWidth = (horizontalSpace / numItemsInRow).rounded(.down)

    let verticalPadding = sectionPadding * CGFloat(numSections)
    let verticalSpace = collectionView.frame.size.height - verticalPadding
    let cellHeight = (verticalSpace / CGFloat(numSections)).rounded(.down)

    return CGSize(width: cellWidth, height: cellHeight)
  }
}
