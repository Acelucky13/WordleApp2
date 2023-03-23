//
//  BoardController+Extensions.swift
//  Wordle
//
//  Created by Mari Batilando on 3/1/23.
//

import Foundation
import UIKit

extension BoardController {
  var letterCellIdentifier: String { "LetterCell" }
  var itemPadding: Double { 3.0 }
  
  func enter(_ string: String) {
    guard numTimesGuessed < numItemsPerRow * numRows else { return }
    guard string.count == 1 else {
      assertionFailure("Expecting string of size 1")
      return
    }
    let cell = collectionView.cellForItem(at: IndexPath(item: numTimesGuessed, section: 0)) as! LetterCell
    cell.set(letter: string)
    UIView.animate(withDuration: 0.1,
                   delay: 0.0,
                   options: [.autoreverse],
                   animations: {
      cell.transform = cell.transform.scaledBy(x: 1.05, y: 1.05)
    }, completion: { finished in
      cell.transform = CGAffineTransformIdentity
    })
    if isFinalGuessInRow() {
      markLettersInRow()
      if isAlienWordle {
        var shouldGenerateAnotherWord = true
        repeat {
          let rawTheme = SettingsManager.shared.settingsDictionary[kWordThemeKey] as! String
          let theme = WordTheme(rawValue: rawTheme)!
          let newGoalWord = WordGenerator.generateGoalWord(with: theme)
          shouldGenerateAnotherWord = newGoalWord == goalWord
          if !shouldGenerateAnotherWord {
            goalWord = newGoalWord
          }
        } while shouldGenerateAnotherWord
      }
    }
    numTimesGuessed += 1
  }
  
  func deleteLastCharacter() {
    guard numTimesGuessed > 0 && numTimesGuessed % numItemsPerRow != 0 else { return }
    let cell = collectionView.cellForItem(at: IndexPath(item: numTimesGuessed - 1, section: 0)) as! LetterCell
    numTimesGuessed -= 1
    cell.clearLetter()
    cell.set(style: .initial)
  }
  
  func isFinalGuessInRow() -> Bool {
    if numTimesGuessed == 0 {
      return false
    }
    return (numTimesGuessed + 1) % numItemsPerRow == 0
  }
  
  func markLettersInRow() {
    let countedSet = NSCountedSet(array: goalWord)
    var remainingIndexPaths = Set(getIndexPaths(for: currRow))
    let correctLetterAndPosition = getCorrectLettersAndPosition(countedSet: countedSet,
                                                                remainingIndexPaths: &remainingIndexPaths)
    for indexPath in correctLetterAndPosition {
      let cell = collectionView.cellForItem(at: indexPath) as! LetterCell
      cell.set(style: .correctLetterAndPosition)
    }
    
    let correctLetterOnly = getCorrectLettersOnly(countedSet: countedSet,
                                                  remainingIndexPaths: &remainingIndexPaths)
    for indexPath in correctLetterOnly {
      let cell = collectionView.cellForItem(at: indexPath) as! LetterCell
      cell.set(style: .correctLetterOnly)
    }
    
    let notCorrect = getIncorrectLetters(correctLetters: Set(correctLetterOnly + correctLetterAndPosition),
                                         remainingIndexPaths: &remainingIndexPaths)
    for indexPath in notCorrect {
      let cell = collectionView.cellForItem(at: indexPath) as! LetterCell
      cell.set(style: .incorrect)
    }
  }
  
  func getCorrectLettersAndPosition(countedSet: NSCountedSet,
                                    remainingIndexPaths: inout Set<IndexPath>) -> [IndexPath] {
    var res = [IndexPath]()
    for indexPath in remainingIndexPaths {
      let cell = collectionView.cellForItem(at: indexPath) as! LetterCell
      let letterInCell = cell.letterLabel.text!
      if goalWord[indexPath.item % numItemsPerRow] == letterInCell {
        res.append(indexPath)
        remainingIndexPaths.remove(indexPath)
        countedSet.remove(letterInCell)
      }
    }
    return res
  }
  
  func getCorrectLettersOnly(countedSet: NSCountedSet,
                             remainingIndexPaths: inout Set<IndexPath>) -> [IndexPath] {
    var res = [IndexPath]()
    for indexPath in remainingIndexPaths {
      let cell = collectionView.cellForItem(at: indexPath) as! LetterCell
      let letterInCell = cell.letterLabel.text!
      if countedSet.contains(letterInCell) {
        res.append(indexPath)
        remainingIndexPaths.remove(indexPath)
        countedSet.remove(letterInCell)
      }
    }
    return res
  }
  
  func getIncorrectLetters(correctLetters: Set<IndexPath>,
                           remainingIndexPaths: inout Set<IndexPath>) -> [IndexPath] {
    return remainingIndexPaths.filter { !correctLetters.contains($0) }
  }
  
  func getIndexPaths(for row: Int) -> [IndexPath] {
    var res = [IndexPath]()
    for i in numItemsPerRow * row..<numItemsPerRow * row + numItemsPerRow {
      res.append(IndexPath(item: i, section: 0))
    }
    return res
  }
  
  // MARK: - Collection View Methods
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return collectionView.dequeueReusableCell(withReuseIdentifier: letterCellIdentifier, for: indexPath)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return numItemsPerRow * numRows
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.size.width / Double(numItemsPerRow) - (Double(numItemsPerRow) - 1.0) * itemPadding
    let height = collectionView.frame.size.height / Double(numRows) - (Double(numRows) - 1.0) * itemPadding
    return CGSize(width: width, height: height)
  }
}
