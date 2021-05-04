//
//  ViewController.swift
//  essaiInstagrid
//
//  Created by DAUBERCIES on 21/04/2021.
//

// Push on github

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet var layoutButton: [UIButton]!
    @IBOutlet weak var stackViewUpSide: UIStackView!
    @IBOutlet weak var stackViewBottom: UIStackView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var buttonUpsideLeft: UIButton!
    @IBOutlet weak var buttonBottomLeft: UIButton!
    private var imageButton: UIButton!
    private var orientation = ""
    var swipeGesture: UISwipeGestureRecognizer?
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonUpsideLeft.isHidden = true
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dragstackView(gesture:)))
        guard let swipeGesture = swipeGesture else {return}
        stackView.addGestureRecognizer(swipeGesture)
        stackView.layer.borderWidth = 10
        stackView.layer.borderColor = #colorLiteral(red: 0, green: 0.4156376421, blue: 0.6045653224, alpha: 1)
        stackView.addArrangedSubview(stackViewUpSide)
        stackView.setCustomSpacing(10, after: stackViewBottom)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Detect orientation to manage swipe gesture
    @objc func rotated() {
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            orientation = "Landscape"
            swipeGesture?.direction = .left
        case .portrait:
            orientation = "Portrait"
            swipeGesture?.direction = .up
        default: break
        }
    }
    
    /// Selection of a layout
    @IBAction func layoutButtonTapped(_ sender: UIButton) {
        for layoutButtons in layoutButton {
            layoutButtons.isSelected = false
        }
        sender.isSelected = true
        switch sender.tag {
        case 0:
            buttonUpsideLeft.isHidden = false
            buttonBottomLeft.isHidden = true
        case 1:
            buttonUpsideLeft.isHidden = true
            buttonBottomLeft.isHidden = false
        case 2:
            buttonUpsideLeft.isHidden = false
            buttonBottomLeft.isHidden = false
        default: break
        }
    }
    
    /// share to social medias and animate the view
    @objc func dragstackView(gesture: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.5) { [self] in
            switch gesture.direction {
            case .left:
                if orientation == "Landscape" {
                    self.stackView.transform = self.stackView.transform.translatedBy(x: (-UIScreen.main.bounds.width), y: 0)
                }
            case .up:
                if orientation == "Portrait" {
                    self.stackView.transform = self.stackView.transform.translatedBy(x: 0, y: (-UIScreen.main.bounds.height))
                }
            default : break
            }
        } completion: { _ in
            self.shareToSocialMedia()
        }
    }
    
    /// Use ActivityViewController
    @objc func shareToSocialMedia() {
        let activityController = UIActivityViewController(activityItems: [stackView.image], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        activityController.completionWithItemsHandler = { _, _, _, _ in
            UIView.animate(withDuration: 0.5, animations: {self.stackView.transform = .identity
            })
        }
    }
}

// MARK: - Extension for protocols UIImagePickerController

extension ViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// UIImagePickerController 1/2
    @IBAction func imageButtonTapped(_ sender: UIButton) {
        imageButton = sender
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    /// UIImagePickerController 2/2
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        imageButton.imageView?.contentMode = .scaleAspectFill
        imageButton.setImage(image, for: .normal)
        picker.dismiss(animated: true, completion: nil)
    }
}
