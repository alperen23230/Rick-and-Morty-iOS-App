//
//  CharacterFilterViewController.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 26.12.2020.
//

import UIKit

protocol CharacterFilterDelegate {
    func didFilterTapped(selectedStatus: String, selectedGender: String)
}

class CharacterFilterViewController: UIViewController {
    
    @UsesAutoLayout
    private var statusTextField = PickerTextField()
    @UsesAutoLayout
    private var genderTextField = PickerTextField()
    private var filterButton = CustomButton(backgroundColor: .rickBlue, title: "Filter")
    
    private var statusPickerView = UIPickerView()
    private var genderPickerView = UIPickerView()
    
    private let statusArray = ["alive", "dead", "unknown"]
    private let genderArray = ["female", "male", "genderless", "unknown"]
    
    private var hasSetPointOrigin = false
    private var pointOrigin: CGPoint?
    
    var filterDelegate: CharacterFilterDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPanGestureForBottomSheet()
        configureViews()
        configurePickerViewsDataSourceAndDelegates()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    init(currentStatus: String, currentGender: String) {
        super.init(nibName: nil, bundle: nil)
        
        if currentStatus != "" {
            self.statusTextField.text = currentStatus
        }
        
        if currentGender != "" {
            self.genderTextField.text = currentGender
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureViews() {
        
        configureTextFields()
        configureFilterButton()
        
        view.addSubview(statusTextField)
        view.addSubview(genderTextField)
        view.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            statusTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height * 0.05),
            statusTextField.widthAnchor.constraint(equalToConstant: ScreenSize.width * 0.40),
            statusTextField.heightAnchor.constraint(equalToConstant: view.frame.size.height * 0.04),
            statusTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            genderTextField.topAnchor.constraint(equalTo: statusTextField.bottomAnchor, constant: view.frame.size.height * 0.025),
            genderTextField.widthAnchor.constraint(equalToConstant: ScreenSize.width * 0.40),
            genderTextField.heightAnchor.constraint(equalToConstant: view.frame.size.height * 0.04),
            genderTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            filterButton.topAnchor.constraint(equalTo: genderTextField.bottomAnchor, constant:  view.frame.size.height * 0.03),
            
            filterButton.widthAnchor.constraint(equalToConstant: ScreenSize.width * 0.40),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: view.frame.size.height * 0.04)
            
        ])
    }
    
    private func configureTextFields()  {
        statusTextField.inputView = statusPickerView
        genderTextField.inputView = genderPickerView
        
        statusPickerView.tag = 1
        genderPickerView.tag = 2
        
        statusTextField.textAlignment = .center
        genderTextField.textAlignment = .center
        
        statusTextField.placeholder = "Select Status"
        genderTextField.placeholder = "Select Gender"
        
        
        statusTextField.layer.borderWidth = 1.0
        genderTextField.layer.borderWidth = 1.0
        
        statusTextField.layer.cornerRadius = 5.0
        genderTextField.layer.cornerRadius = 5.0
        
        statusTextField.layer.borderColor = UIColor.rickBlue.cgColor
        genderTextField.layer.borderColor = UIColor.rickBlue.cgColor
        
        statusTextField.textColor = .rickBlue
        genderTextField.textColor = .rickBlue
    }
    
    private func configureFilterButton() {
        filterButton.addTarget(self, action: #selector(filterButtonClicked), for: .touchUpInside)
    }
    
    @objc private func filterButtonClicked() {
        let status = statusTextField.text ?? ""
        let gender = genderTextField.text ?? ""
        filterDelegate.didFilterTapped(selectedStatus: status, selectedGender: gender)
        dismiss(animated: true)
    }
    
    private func addPanGestureForBottomSheet() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
    
}

// MARK: - Picker View Methods
extension CharacterFilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return statusArray.count
        case 2:
            return genderArray.count
        default:
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return statusArray[row]
        case 2:
            return genderArray[row]
        default:
            return "Data not found."
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            statusTextField.text = statusArray[row]
        case 2:
            genderTextField.text = genderArray[row]
        default:
            return
        }
    }
    
    private func configurePickerViewsDataSourceAndDelegates() {
        statusPickerView.delegate = self
        statusPickerView.dataSource = self
        
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
    }
}
