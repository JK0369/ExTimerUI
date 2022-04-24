//
//  CircularProgressView.swift
//  ExCircularProgress
//
//  Created by 김종권 on 2022/04/24.
//

import UIKit

class CircularProgressView: UIView {
  private let timeLabel: UILabel = {
    let label = UILabel()
    label.textColor = .gray
    label.text = "60s"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let backgroundLayer = CAShapeLayer()
  private let progressLayer = CAShapeLayer()
  private let animationName = "progressAnimation"
  private var timer: Timer?
  private var remainingSeconds: TimeInterval? {
    didSet {
      guard let remainingSeconds = self.remainingSeconds else { return }
      self.timeLabel.text = String(format: "%02ds", Int(remainingSeconds))
    }
  }
  private var circularPath: UIBezierPath {
    UIBezierPath(
      arcCenter: CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height / 2.0),
      radius: 80,
      startAngle: CGFloat(-Double.pi / 2),
      endAngle: CGFloat(3 * Double.pi / 2),
      clockwise: true
    )
  }
  
  required init?(coder: NSCoder) {
    fatalError("not implemented")
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.addSubview(self.timeLabel)
    NSLayoutConstraint.activate([
      self.timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      self.timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
    ])
    
    self.backgroundLayer.path = self.circularPath.cgPath
    self.backgroundLayer.fillColor = UIColor.clear.cgColor
    self.backgroundLayer.lineCap = .round
    self.backgroundLayer.lineWidth = 3.0
    self.backgroundLayer.strokeEnd = 1.0 // 0 ~1사이의 값 (0이면 안채워져 있고, 1이면 다 채워져 있는 것)
    self.backgroundLayer.strokeColor = UIColor.lightGray.cgColor
    self.layer.addSublayer(self.backgroundLayer)
    
    self.progressLayer.path = self.circularPath.cgPath
    self.progressLayer.fillColor = UIColor.clear.cgColor
    self.progressLayer.lineCap = .round
    self.progressLayer.lineWidth = 3.0
    self.progressLayer.strokeEnd = 0
    self.progressLayer.strokeColor = UIColor.blue.cgColor
    self.layer.addSublayer(self.progressLayer)
  }
  deinit {
    self.timer?.invalidate()
    self.timer = nil
  }
  
  override func layoutSublayers(of layer: CALayer) {
    super.layoutSublayers(of: layer)
    self.backgroundLayer.path = self.circularPath.cgPath
    self.progressLayer.path = self.circularPath.cgPath
  }
  
  func start(duration: TimeInterval) {
    self.remainingSeconds = duration
    
    // timer
    self.timer?.invalidate()
    let startDate = Date()
    self.timer = Timer.scheduledTimer(
      withTimeInterval: 1,
      repeats: true,
      block: { [weak self] _ in
        let remainingSeconds = duration - round(abs(startDate.timeIntervalSinceNow))
        guard remainingSeconds >= 0 else {
          self?.stop()
          return
        }
        self?.remainingSeconds = remainingSeconds
      }
    )
    
    // animation
    self.progressLayer.removeAnimation(forKey: self.animationName)
    let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
    circularProgressAnimation.duration = duration
    circularProgressAnimation.toValue = 1.0
    circularProgressAnimation.fillMode = .forwards
    circularProgressAnimation.isRemovedOnCompletion = false
    self.progressLayer.add(circularProgressAnimation, forKey: self.animationName)
  }

  func stop() {
    self.timer?.invalidate()
    self.progressLayer.removeAnimation(forKey: self.animationName)
    self.remainingSeconds = 60
  }
}
