//
//  SettingsManager.swift
//  Wordle
//
//  Created by Mari Batilando on 3/19/23.
//

import Foundation

class SettingsManager {

  private var numGuesses = 6
  private var numLetters = 5
  private var wordTheme = WordTheme.normal
  private var isAlienWordle = false
  
  var settingsDictionary: [String: Any] {
    return [kNumGuessesKey: numGuesses,
            kNumLettersKey: numLetters,
            kWordThemeKey: wordTheme.rawValue,
            kIsAlienWordleKey: isAlienWordle]
  }

  static let shared = SettingsManager()
  
  func set(numGuesses: Int) {
    self.numGuesses = max(kMinGuesses, min(kMaxGuesses, numGuesses))
  }
  
  func set(numLetters: Int) {
    self.numLetters = max(kMinLetters, min(kMaxLetters, numLetters))
  }
  
  func set(wordTheme: WordTheme) {
    self.wordTheme = wordTheme
  }
  
  func set(isAlienWordle: Bool) {
    self.isAlienWordle = isAlienWordle
  }
}
