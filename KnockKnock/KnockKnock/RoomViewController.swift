//
//  ViewController.swift
//  KnockKnock
//
//  Created by 이창형 on 2022/07/13.
//

import UIKit

class RoomViewController: UIViewController {
    
    // DoorViewController실행 되었는지 확인
    var isDoorView: Bool = true
    let doorViewController = DoorViewController()
    
    // 배경화면
    let roomImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "roomImage")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = myImage
        return imageView
    }()
    
    // 메모 버튼 ImageView
    let memoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "memo")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = myImage
        return imageView
    }()
    
    
    let albumImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "album")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = myImage
        return imageView
    }()
    
    
    
    //액자 버튼 ImageView
    let frameImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "frame")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = myImage
        return imageView
    }()
    
    //편지 버튼 ImageView
    var letterImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let myImage: UIImage = UIImage(named: "letter")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = myImage
        return imageView
    }()
    
    //MARK: - 뷰디드로드
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(roomImageView)
        roomImageView.addSubview(memoImageView)
        roomImageView.addSubview(albumImageView)
        roomImageView.addSubview(frameImageView)
        roomImageView.addSubview(letterImageView)
        
        setupLayout()
        
        //배경화면 크기 AspectFill로 맞춤
        roomImageView.layer.masksToBounds = true
        roomImageView.contentMode = .scaleAspectFill
        
        //메모 사진 터치 가능하도록 설정
        memoImageView.isUserInteractionEnabled = true
        memoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(memoViewTapped(_:))))
        
        //앨범 사진 터치 가능하도록 설정
        albumImageView.isUserInteractionEnabled = true
        albumImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(albumViewTapped(_:))))
        
        //액자 사진 터치 가능하도록 설정
        frameImageView.isUserInteractionEnabled = true
        frameImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(frameViewTapped(_:))))
        
        //편지 사진 터치 가능하도록 설정
        letterImageView.isUserInteractionEnabled = true
        letterImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(letterViewTapped(_:))))
        
        NotificationCenter.default.addObserver(self, selector: #selector(rotate), name: .rotateBack, object: nil)
        
    }
    
    // DoorViewController를 띄우고 한번이라도 실행되었다면 다음부턴 안띄움
    override func viewDidAppear(_ animated: Bool) {
        let doorViewController = DoorViewController()
        doorViewController.modalPresentationStyle = .overFullScreen
        
        if isDoorView {
            present(doorViewController, animated: false, completion: nil)
            isDoorView = false
        }
        
        if letterCloseCheck {
            showToast(message: "안녕")
            letterCloseCheck = false
        }
    }
    
    func setupLayout(){
        NSLayoutConstraint.activate([
            
            
            roomImageView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            roomImageView.heightAnchor.constraint(equalToConstant: view.bounds.height),
          
            
            //memoImageView layout
            memoImageView.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
            memoImageView.heightAnchor.constraint(equalToConstant: view.bounds.width / 2),
            memoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            memoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            //albumImageView layout
            albumImageView.widthAnchor.constraint(equalToConstant: view.bounds.width / 4),
            albumImageView.heightAnchor.constraint(equalToConstant: view.bounds.width / 4),
            albumImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            albumImageView.topAnchor.constraint(equalTo: memoImageView.bottomAnchor, constant: 20),
            
            //frameImageView layout
            frameImageView.widthAnchor.constraint(equalToConstant: 100),
            frameImageView.heightAnchor.constraint(equalToConstant: 100),
            frameImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            frameImageView.topAnchor.constraint(equalTo: view.topAnchor, constant:100),
            
            //letterImageView layout
            letterImageView.widthAnchor.constraint(equalToConstant: 100),
            letterImageView.heightAnchor.constraint(equalToConstant: 100),
            letterImageView.bottomAnchor.constraint(equalTo: memoImageView.topAnchor)
        ])
    }
    
    @objc func rotate(_ sender: UITapGestureRecognizer) {
        
        
    }
    
    //메모 버튼 터치 함수
    @objc func memoViewTapped(_ sender: UITapGestureRecognizer) {
        let memoVC = MainMemoView()
        self.navigationController?.pushViewController(memoVC, animated: true)
    }
    
    //앨범 버튼 터치 함수
    @objc func albumViewTapped(_ sender: UITapGestureRecognizer) {
        let albumVC = MainAlbumViewController()
        self.navigationController?.pushViewController(albumVC, animated: true)
    }
    
    //액자 버튼 터치 함수
    @objc func frameViewTapped(_ sender: UITapGestureRecognizer) {
        let frameVC = MainFrameViewController()
        self.navigationController?.pushViewController(frameVC, animated: true)
    }
    
    //편지 버튼 터치 함수
    @objc func letterViewTapped(_ sender: UITapGestureRecognizer) {
        let letterVC = MainLetterViewController()
        letterVC.modalPresentationStyle = UIModalPresentationStyle.automatic
        
        self.present(letterVC, animated: true, completion: nil)
    }
    
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
            let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.font = font
            toastLabel.textAlignment = .center;
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: {
                 toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
    
}

extension Notification.Name {
    static let rotateBack = Notification.Name("rotateBack")
}

