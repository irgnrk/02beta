//
//  ViewController.swift
//  uitimer.uikit.learning
//
//  Created by Иван Быховский on 24.12.22.
//
import UIKit

class ViewController: UIViewController {
    
    //MARK: - UI elements
    
    private lazy var shapeView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ellipse")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    private lazy var workCondition: UILabel = {
        let label = UILabel()
        label.text = "Lets's go!"
        label.textColor = .red
        label.font = .systemFont(ofSize: 60, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    } ()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "Hi!"
        label.font = .systemFont(ofSize: 80, weight: .black)
        label.textColor = .yellow
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .black)
        button.setTitleColor(.yellow, for: .normal)
        button.setTitleColor(.red, for: .highlighted)
        button.backgroundColor = .black
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pressStartButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var canselButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .black)
        button.setTitleColor(.yellow, for: .normal)
        button.setTitleColor(.red, for: .highlighted)
        button.backgroundColor = .black
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pressCanselButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var timer = Timer()
    private var timerIsOn = false
    let shapeLayer = CAShapeLayer()
    
    // массив на время, цвет и состояние - расписание
    
    let timetable = [
        (20, UIColor.red, "work"),         // work
        (5, UIColor.yellow, "rest"),      // rest
        (20, UIColor.red, "work"),         // work
        (40, UIColor.green, "big rest")    // bigrest
    ]
    
    var timetableCounter = 0
    
    private var counterTimer = 20
    private var colorTimer = UIColor.red
    
    //MARK: - Life Cycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.animationOfRoundTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
        view.backgroundColor = .systemOrange
    }
    
    //MARK: - Setup
    
    private func setupView() {
        resetTimer()
    }
    
    private func setupHierarchy() {
        view.addSubview(shapeView)
        view.addSubview(timerLabel)
        view.addSubview(startButton)
        view.addSubview(workCondition)
        view.addSubview(canselButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            shapeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shapeView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            shapeView.heightAnchor.constraint(equalToConstant: 300),
            shapeView.widthAnchor.constraint(equalToConstant: 300),
            
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            startButton.topAnchor.constraint(equalTo: shapeView.bottomAnchor, constant: 40),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 60),
            startButton.widthAnchor.constraint(equalToConstant: 200),
            
            workCondition.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            workCondition.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            
            canselButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            canselButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20),
            canselButton.heightAnchor.constraint(equalToConstant: 60),
            canselButton.widthAnchor.constraint(equalToConstant: 200)
            
        ])
    }
    
    //MARK: - Actions
    
    @objc func pressStartButton() {
        timerLabel.text = formatTime()  // "\(counterTimer)"
            timerIsOn.toggle()
            if timerIsOn {
                workCondition.text = timetable[timetableCounter].2
                workCondition.textColor = timetable[timetableCounter].1
                timerLabel.textColor =  workCondition.textColor
                basicAnimation()   // - start animation
                 timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerActions), userInfo: nil, repeats: true)
                startButton.setTitle("Pause", for: .normal)
            } else {
                startButton.setTitle("Resume", for: .normal)
                timer.invalidate()
        }
    }
    
    @objc func pressCanselButton() {
                timer.invalidate()
                resetTimer()
                startButton.setTitle("Start", for: .normal)
                timerIsOn = false
    }
    
    @objc func timerActions() {
        // basicAnimation()   // анимация
       
        workCondition.text = timetable[timetableCounter].2
        workCondition.textColor = timetable[timetableCounter].1
        timerLabel.textColor =  workCondition.textColor
        counterTimer -= 1
        timerLabel.text = formatTime() // "\(counterTimer)"
        
        if counterTimer == 0 {
            timetableCounter += 1
            if timetableCounter >= timetable.count {
                startButton.setTitle("Start", for: .normal)
                timer.invalidate()
                resetTimer()
            } else {
                counterTimer = timetable[timetableCounter].0
                timerLabel.text = formatTime() // "\(counterTimer)"
                workCondition.text = timetable[timetableCounter].2
                workCondition.textColor = timetable[timetableCounter].1
                timerLabel.textColor =  workCondition.textColor
            }
        }
    }
    
    private func resetTimer() {
        timetableCounter = 0
        counterTimer = timetable[timetableCounter].0
        colorTimer = timetable[timetableCounter].1
        timerLabel.text = formatTime() // "\(counterTimer)"
        workCondition.text = "Let's go!"
        workCondition.textColor = timetable[timetableCounter].1
        timerLabel.textColor =  workCondition.textColor
    }
    
    func formatTime()-> String {
            let minutes = Int(counterTimer) / 60 % 60
            let seconds = Int(counterTimer) % 60
            return String(format:"%02i:%02i", minutes, seconds)
            
        }
    
    //MARK: - Animations
    
    private func animationOfRoundTimer() {
        let center = CGPoint(x: shapeView.frame.width / 2, y: shapeView.frame.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        let circulsrPath = UIBezierPath(arcCenter: center, radius: 140, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        shapeLayer.path = circulsrPath.cgPath
        shapeLayer.lineWidth = 20
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeColor = .init(srgbRed: 255/255, green: 0, blue: 0, alpha: 1)
        shapeView.layer.addSublayer(shapeLayer)
        
    }
    
    private func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(counterTimer)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
}


// MARK: - Extentions


