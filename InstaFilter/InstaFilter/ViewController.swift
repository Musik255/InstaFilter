//
//  ViewController.swift
//  InstaFilter
//
//  Created by Павел Чвыров on 25.12.2023.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var slider : UISlider!
    var changeButton : UIButton!
    var saveButton : UIButton!
    var imageView : UIImageView!
    var currentImage: UIImage!
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        let photoView = UIView()
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.backgroundColor = .lightGray
        view.addSubview(photoView)
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        photoView.addSubview(imageView)
        photoView.contentMode = .scaleAspectFit
        
        let intensityLabel = UILabel()
        intensityLabel.text = "Intensity:"
        intensityLabel.translatesAutoresizingMaskIntoConstraints = false
        intensityLabel.font = UIFont.systemFont(ofSize: 27)
        intensityLabel.textAlignment = .center
//        intensityLabel.backgroundColor = .cyan
        view.addSubview(intensityLabel)
        
        slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slider)
        
        
        changeButton = UIButton(type: .system)
        changeButton.translatesAutoresizingMaskIntoConstraints = false
        changeButton.setTitle("Change filter", for: .normal)
//        changeButton.backgroundColor = .magenta
        changeButton.titleLabel?.font = UIFont.systemFont(ofSize: 27)
        view.addSubview(changeButton)
        
        saveButton = UIButton(type: .system)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Save Photo", for: .normal)
//        saveButton.backgroundColor = .magenta
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 27)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            photoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            photoView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -20),
            photoView.heightAnchor.constraint(equalTo: photoView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: photoView.topAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: photoView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 10),
            
            intensityLabel.leadingAnchor.constraint(equalTo: photoView.leadingAnchor, constant: 2),
            intensityLabel.topAnchor.constraint(equalTo: photoView.bottomAnchor),
            intensityLabel.widthAnchor.constraint(equalTo: photoView.widthAnchor, multiplier: 0.25),
            intensityLabel.heightAnchor.constraint(equalToConstant: 40),
            
            slider.topAnchor.constraint(equalTo: photoView.bottomAnchor),
            slider.leadingAnchor.constraint(equalTo: intensityLabel.trailingAnchor),
            slider.widthAnchor.constraint(equalTo: photoView.widthAnchor, multiplier: 0.75),
            slider.heightAnchor.constraint(equalTo: intensityLabel.heightAnchor),
            
            changeButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 20),
            changeButton.leadingAnchor.constraint(equalTo: photoView.leadingAnchor),
            changeButton.widthAnchor.constraint(equalTo: photoView.widthAnchor, multiplier: 0.5),
            changeButton.heightAnchor.constraint(equalToConstant: 60),
            
            saveButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: changeButton.trailingAnchor),
            saveButton.widthAnchor.constraint(equalTo: photoView.widthAnchor, multiplier: 0.5),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
            
            
        ])
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "SomeFilters"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
    }
    
    
    
    @objc func importPicture(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
//        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func getDocumentDirectory() -> URL{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        
        currentImage = image
        
    }

}

