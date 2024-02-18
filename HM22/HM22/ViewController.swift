//
//  ViewController.swift
//  HM22
//
//  Created by Evgeny Sakun on 13.02.24.
//

import UIKit

class ViewController: UIViewController {
    let showMessageButton = UIButton()
    let alertController = UIAlertController(title: "Напоминание", message: "Не забудьте оставить отзыв", preferredStyle: .alert)
    let citiesArray = ["Grodno", "Gomel", "Mogilev", "Minsk", "Brest", "Vitebsk"]
    let citiesPicker = UIPickerView()
    let cityLabel = UILabel()
    var selectedCityIndex: Int?
    let loadImageButton = UIButton()
    let imagePicker = UIImagePickerController()
    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupShowMessageButton()
        setupAlertController()
        setupCitiesPicker()
        setupCityLabel()
        setupLoadImageButton()
        setupImageView()
    }

    private func setupShowMessageButton() {
        let buttonHeight: CGFloat = 50

        showMessageButton.backgroundColor = .systemRed
        showMessageButton.setTitle("Сообщение", for: .normal)
        showMessageButton.setTitleColor(.white, for: .normal)
        showMessageButton.layer.cornerRadius = buttonHeight / 2

        view.addSubview(showMessageButton)

        showMessageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showMessageButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            showMessageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showMessageButton.widthAnchor.constraint(equalToConstant: buttonHeight * 4.5),
            showMessageButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])

        showMessageButton.addTarget(self, action: #selector(showMessageButtonTapped), for: .touchUpInside)
    }

    private func setupAlertController() {
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            let thanksAlert = UIAlertController(title: "Спасибо!", message: nil, preferredStyle: .alert)
            self.present(thanksAlert, animated: true)

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                thanksAlert.dismiss(animated: true)
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
    }

    private func setupCitiesPicker() {
        citiesPicker.delegate = self
        citiesPicker.dataSource = self

        view.addSubview(citiesPicker)

        citiesPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            citiesPicker.bottomAnchor.constraint(equalTo: showMessageButton.topAnchor, constant: -10),
            citiesPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupCityLabel() {
        cityLabel.textColor = .black
        cityLabel.font = UIFont(name: "Pacifico", size: 50)

        view.addSubview(cityLabel)

        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityLabel.bottomAnchor.constraint(equalTo: citiesPicker.topAnchor, constant: -10),
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func updateCityLabelText() {
        if let selectedCityIndex = selectedCityIndex {
            cityLabel.text = citiesArray[selectedCityIndex]
        }
    }
    
    private func setupLoadImageButton() {
        let buttonHeight: CGFloat = 50

        loadImageButton.backgroundColor = .systemRed
        loadImageButton.setTitle("Загрузить картинку", for: .normal)
        loadImageButton.setTitleColor(.white, for: .normal)
        loadImageButton.layer.cornerRadius = buttonHeight / 2

        view.addSubview(loadImageButton)

        loadImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadImageButton.topAnchor.constraint(equalTo: showMessageButton.bottomAnchor, constant: 20),
            loadImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadImageButton.widthAnchor.constraint(equalToConstant: buttonHeight * 4.5),
            loadImageButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])

        loadImageButton.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
    }
    
    private func setupImageView() {
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: loadImageButton.bottomAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 250),
            imageView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }

    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func showMessageButtonTapped() {
        present(alertController, animated: true)
    }
    
    @objc func showImagePicker() {
        setupImagePicker()
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return citiesArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let city = citiesArray[row]
        selectedCityIndex = row
        updateCityLabelText()
        return city
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
