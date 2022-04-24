//
//  ViewController.swift
//  ExCircularProgress
//
//  Created by 김종권 on 2022/04/24.
//

import UIKit

final class ViewController: UIViewController {
  private let circularProgressView = CircularProgressView()
  private let startButton: UIButton = {
    let button = UIButton()
    button.setTitle("start", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.setTitleColor(.blue, for: .highlighted)
    button.addTarget(self, action: #selector(start), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  private let stopButton: UIButton = {
    let button = UIButton()
    button.setTitle("stop", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.setTitleColor(.blue, for: .highlighted)
    button.addTarget(self, action: #selector(stop), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.circularProgressView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(self.circularProgressView)
    self.view.addSubview(self.stackView)
    self.stackView.addArrangedSubview(self.startButton)
    self.stackView.addArrangedSubview(self.stopButton)
    
    NSLayoutConstraint.activate([
      self.circularProgressView.heightAnchor.constraint(equalToConstant: 200),
      self.circularProgressView.widthAnchor.constraint(equalToConstant: 200),
      self.circularProgressView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
      self.circularProgressView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
    ])
    NSLayoutConstraint.activate([
      self.stackView.bottomAnchor.constraint(equalTo: self.circularProgressView.topAnchor),
      self.stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
    ])
  }
  
  @objc func start() {
    self.circularProgressView.start(duration: 60.0)
  }
  @objc func stop() {
    self.circularProgressView.stop()
  }
}
