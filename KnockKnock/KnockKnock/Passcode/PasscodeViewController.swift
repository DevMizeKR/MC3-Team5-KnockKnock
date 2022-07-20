//
//  PasscodeViewController.swift
//  KnockKnock
//
//  Created by KoJeongseok on 2022/07/19.
//

import LocalAuthentication
import UIKit


class PasscodeViewController: UIViewController {
    
    var passcodes = [Int]()
    var newPasscodes = [Int]()
    let settingViewController = SettingViewController()
    let keychainManager = KeychainManager()
    var isRegister: Bool? = false
    var tasks = [Task]()
    
    
    let passcodeImage1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "minus")
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let passcodeImage2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "minus")
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let passcodeImage3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "minus")
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let passcodeImage4: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "minus")
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        //            label.font = UIFont(name: label.font.fontName, size: 35)
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.text = "암호 입력"
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "암호를 입력해 주세요."
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "doorBackground")
        loadTasks()
        passcodeField()
        setupNumberPad()
    }
    
    
    
    // 비밀번호 등록 여부와, UserDefaults의 값을 load
    private func loadTasks() {
        isRegister = keychainManager.getItem(key: "passcode") == nil ? true : false
        
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else { return }
        self.tasks = data.compactMap {
            guard let title = $0["title"] as? String else {return nil}
            guard let isSwitch = $0["isSwitch"] as? Bool else {return nil}
            guard let isSwitchOn = $0["isSwitchOn"] as? Bool else { return nil}
            return Task(title: title, isSwitch: isSwitch, isSwitchOn: isSwitchOn)
        }
    }
    
    
    private func passcodeField() {
        
        let passcodeButtonHeight = (view.frame.size.width / 12) * 3.5
        
        let vStackView: UIStackView = {
            let stackView = UIStackView()
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.distribution = .fillEqually
            stackView.spacing = 15
            return stackView
        }()
        
        let hStackView: UIStackView = {
            let stackView = UIStackView()
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.spacing = 30
            return stackView
        }()
        
        
        view.addSubview(vStackView)
        
        vStackView.addArrangedSubview(titleLabel)
        vStackView.addArrangedSubview(subTitleLabel)
        vStackView.addArrangedSubview(hStackView)
        
        hStackView.addArrangedSubview(passcodeImage1)
        hStackView.addArrangedSubview(passcodeImage2)
        hStackView.addArrangedSubview(passcodeImage3)
        hStackView.addArrangedSubview(passcodeImage4)
        
        NSLayoutConstraint.activate([
            vStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -passcodeButtonHeight),
        ])
    }
    
    private func setupNumberPad() {
        
        let buttonWidthSize = view.frame.size.width / 3
        let buttonHeightSize = buttonWidthSize / 2
        
        
        for n in 0..<3 {
            for m in 0..<3 {
                let button = UIButton(frame: CGRect(x: buttonWidthSize * CGFloat(m), y: view.frame.size.height - buttonHeightSize * (4.5 - CGFloat(n)), width: buttonWidthSize, height: buttonHeightSize))
                button.setTitleColor(.label, for: .normal)
                
                //                button.backgroundColor = .white
                button.setTitle(String((m + 1) + (n * 3)), for: .normal)
                button.tag = (m + 1) + (n * 3)
                button.addTarget(self, action: #selector(numberPressed(_ :)), for: .touchUpInside)
                view.addSubview(button)
            }
        }
        
        let faceButton = UIButton(frame: CGRect(x: 0, y: view.frame.size.height - buttonHeightSize * 1.5, width: buttonWidthSize, height: buttonHeightSize))
        faceButton.setTitleColor(.label, for: .normal)
        //        faceButton.backgroundColor = .white
        if isRegister! {
            faceButton.setTitle("취소", for: .normal)
        } else {
            faceButton.setImage(UIImage(systemName: "faceid"), for: .normal)
        }
        faceButton.tintColor = .label
        faceButton.tag = 11
        faceButton.addTarget(self, action: #selector(facePressed(_ :)), for: .touchUpInside)
        view.addSubview(faceButton)
        
        let zeroButton = UIButton(frame: CGRect(x: buttonWidthSize, y: view.frame.size.height - buttonHeightSize * 1.5, width: buttonWidthSize, height: buttonHeightSize))
        zeroButton.setTitleColor(.label, for: .normal)
        //        zeroButton.backgroundColor = .white
        zeroButton.setTitle("0", for: .normal)
        zeroButton.tag = 0
        zeroButton.addTarget(self, action: #selector(numberPressed(_ :)), for: .touchUpInside)
        view.addSubview(zeroButton)
        
        let deleteButton = UIButton(frame: CGRect(x: buttonWidthSize * 2, y: view.frame.size.height - buttonHeightSize * 1.5, width: buttonWidthSize, height: buttonHeightSize))
        deleteButton.setTitleColor(.label, for: .normal)
        //        deleteButton.backgroundColor = .white
        deleteButton.setImage(UIImage(systemName: "delete.backward"), for: .normal)
        deleteButton.tintColor = .label
        deleteButton.tag = 12
        deleteButton.addTarget(self, action: #selector(deletePressed(_ :)), for: .touchUpInside)
        view.addSubview(deleteButton)
    }
    
    @objc private func numberPressed(_ sender: UIButton) {
        let number = sender.tag
        passcodes.append(number)
        update()
        
    }
    
    @objc private func facePressed(_ sender: UIButton) {
        if isRegister! {
            
            settingViewController.tasks[0].isSwitchOn = false
            
            //            settingViewController.tasks.removeLast()
            //            settingViewController.tasks.removeLast()
            
            print("hi")
            NotificationCenter.default.post(name: .fatchTable, object: nil)
            self.dismiss(animated: true)
        } else {
            // biometry 다시 띄우기
        }
    }
    
    @objc private func deletePressed(_ sender: UIButton) {
        passcodes.removeLast()
        print(passcodes)
        update()
    }
    
    private func update() {
        print(passcodes)
        
        if passcodes.count == 4 {
            
            if isRegister! {
                if newPasscodes.isEmpty {
                    newPasscodes = passcodes
                    passcodes.removeAll()
                    subTitleLabel.textColor = .gray
                    subTitleLabel.text = "확인을 위해 다시 입력해주세요."
                } else if newPasscodes != passcodes {
                    passcodes.removeAll()
                    newPasscodes.removeAll()
                    subTitleLabel.textColor = .red
                    subTitleLabel.text = "비밀번호 등록을 다시 진행해주세요."
                } else {
                    var pwd = ""
                    for n in newPasscodes {
                        pwd += String(n)
                    }
                    if keychainManager.addItem(key: "passcode", pwd: pwd) {
                        self.dismiss(animated: true)
                    }
                }
            } else {
                if let keychainPasscides = keychainManager.getItem(key: "passcode") as? String {
                    let registedPasscodes = keychainPasscides.map { Int(String($0))! }
                    if passcodes == registedPasscodes {
                        self.dismiss(animated: true)
                    } else {
                        passcodes.removeAll()
                        subTitleLabel.textColor = .red
                        subTitleLabel.text = "비밀번호 다시 입력해주세요."
                    }
                }

            }
        }
        passcodeImage1.image = UIImage(systemName: passcodes.count > 0 ? "circle.fill" : "minus")
        passcodeImage2.image = UIImage(systemName: passcodes.count > 1 ? "circle.fill" : "minus")
        passcodeImage3.image = UIImage(systemName: passcodes.count > 2 ? "circle.fill" : "minus")
        passcodeImage4.image = UIImage(systemName: passcodes.count > 3 ? "circle.fill" : "minus")
        
    }
    
}

extension Notification.Name {
    static let fatchTable = Notification.Name("fatchTable")
}
