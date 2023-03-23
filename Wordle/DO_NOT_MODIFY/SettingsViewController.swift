//
//  SettingsViewController.swift
//  Wordle
//
//  Created by Mari Batilando on 3/19/23.
//

import UIKit

protocol SettingsViewControllerDelegate: NSObject {
  func didChangeSettings(with settings: [String: Any])
}

class SettingsViewController: UIViewController {
  
  weak var delegate: SettingsViewControllerDelegate?
  var didChangeSettings = false
  
  @IBOutlet weak var numGuessesStepper: UIStepper!
  @IBOutlet weak var numGuessesLabel: UILabel!
  
  @IBOutlet weak var numLettersStepper: UIStepper!
  @IBOutlet weak var numLettersLabel: UILabel!
  
  @IBOutlet weak var wordThemeButton: UIButton!
  @IBOutlet weak var isAlienWordleSwitch: UISwitch!
  
  private var normalThemeAction: UIAction!
  private var countryThemeAction: UIAction!
  private var animalThemeAction: UIAction!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back",
                                                       style: .plain,
                                                       target: self,
                                                       action: #selector(didTapBackButton))
    navigationItem.leftBarButtonItem?.tintColor = .white
    
    let settingsDictionary = SettingsManager.shared.settingsDictionary
    let numGuesses = settingsDictionary[kNumGuessesKey] as! Int
    numGuessesStepper.value = Double(numGuesses)
    numGuessesLabel.text = "\(numGuesses)"
    
    let numLetters = settingsDictionary[kNumLettersKey] as! Int
    numLettersStepper.value = Double(numLetters)
    numLettersLabel.text = "\(numLetters)"
    
    isAlienWordleSwitch.setOn(settingsDictionary[kIsAlienWordleKey] as! Bool, animated: false)
    
    let rawTheme = settingsDictionary[kWordThemeKey] as! String
    let theme = WordTheme(rawValue: rawTheme)
    normalThemeAction = UIAction(title: "Normal",
                                 state: theme == .normal ? .on : .off,
                                 handler: { [unowned self] action in
      self.didTapNormalThemeButton()
    })
    countryThemeAction = UIAction(title: "Countries",
                                 state: theme == .countries ? .on : .off,
                                 handler: { [unowned self] action in
      self.didTapCountriesThemeButton()
    })
    animalThemeAction = UIAction(title: "Animals",
                                 state: theme == .animals ? .on : .off,
                                 handler: { [unowned self] action in
      self.didTapAnimalsThemeButton()
    })
    wordThemeButton.menu = UIMenu(children: [normalThemeAction, countryThemeAction, animalThemeAction])
    wordThemeButton.showsMenuAsPrimaryAction = true
  }
  
  @IBAction func numGuessesStepperValueChanged(_ sender: UIStepper) {
    didChangeSettings = true
    SettingsManager.shared.set(numGuesses: Int(sender.value))
    let numGuesses = SettingsManager.shared.settingsDictionary[kNumGuessesKey] as! Int
    numGuessesStepper.value = Double(numGuesses)
    numGuessesLabel.text = "\(numGuesses)"
  }
  
  @IBAction func numLettersStepperValueChanged(_ sender: UIStepper) {
    didChangeSettings = true
    SettingsManager.shared.set(numLetters: Int(sender.value))
    let numLetters = SettingsManager.shared.settingsDictionary[kNumLettersKey] as! Int
    numLettersStepper.value = Double(numLetters)
    numLettersLabel.text = "\(numLetters)"
  }
  
  @IBAction func isAlienWordleSwitchValueChanged(_ sender: UISwitch) {
    didChangeSettings = true
    SettingsManager.shared.set(isAlienWordle: sender.isOn)
    isAlienWordleSwitch.setOn(SettingsManager.shared.settingsDictionary[kIsAlienWordleKey] as! Bool,
                              animated: true)
  }
  
  private func didTapNormalThemeButton() {
    turnOnTheme(theme: .normal)
  }
  
  private func didTapCountriesThemeButton() {
    turnOnTheme(theme: .countries)
  }
  
  private func didTapAnimalsThemeButton() {
    turnOnTheme(theme: .animals)
  }
  
  private func turnOnTheme(theme: WordTheme) {
    didChangeSettings = true
    normalThemeAction.state = theme == .normal ? .on : .off
    countryThemeAction.state = theme == .countries ? .on : .off
    animalThemeAction.state = theme == .animals ? .on : .off
    SettingsManager.shared.set(wordTheme: theme)
  }
  
  @objc private func didTapBackButton() {
    if didChangeSettings {
      delegate?.didChangeSettings(with: SettingsManager.shared.settingsDictionary)
    }
    navigationController?.popViewController(animated: true)
  }
}
