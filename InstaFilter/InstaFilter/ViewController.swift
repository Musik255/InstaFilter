//
//  ViewController.swift
//  InstaFilter
//
//  Created by Павел Чвыров on 25.12.2023.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var sliderIntensity : UISlider!
    var changeButton : UIButton!
    var saveButton : UIButton!
    var imageView : UIImageView!
    var currentImage: UIImage!
    
    var context: CIContext!
    var currentFilter: CIFilter!
    
    
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
        
        sliderIntensity = UISlider()
        sliderIntensity.translatesAutoresizingMaskIntoConstraints = false
        sliderIntensity.setValue(1, animated: false)
        view.addSubview(sliderIntensity)
        
        
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
            imageView.bottomAnchor.constraint(equalTo: photoView.bottomAnchor, constant: -10),
            imageView.leadingAnchor.constraint(equalTo: photoView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: -10),
            
            intensityLabel.leadingAnchor.constraint(equalTo: photoView.leadingAnchor, constant: 2),
            intensityLabel.topAnchor.constraint(equalTo: photoView.bottomAnchor),
            intensityLabel.widthAnchor.constraint(equalTo: photoView.widthAnchor, multiplier: 0.25),
            intensityLabel.heightAnchor.constraint(equalToConstant: 40),
            
            sliderIntensity.topAnchor.constraint(equalTo: photoView.bottomAnchor),
            sliderIntensity.leadingAnchor.constraint(equalTo: intensityLabel.trailingAnchor),
            sliderIntensity.widthAnchor.constraint(equalTo: photoView.widthAnchor, multiplier: 0.75),
            sliderIntensity.heightAnchor.constraint(equalTo: intensityLabel.heightAnchor),
            
            changeButton.topAnchor.constraint(equalTo: sliderIntensity.bottomAnchor, constant: 20),
            changeButton.leadingAnchor.constraint(equalTo: photoView.leadingAnchor),
            changeButton.widthAnchor.constraint(equalTo: photoView.widthAnchor, multiplier: 0.5),
            changeButton.heightAnchor.constraint(equalToConstant: 60),
            
            saveButton.topAnchor.constraint(equalTo: sliderIntensity.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: changeButton.trailingAnchor),
            saveButton.widthAnchor.constraint(equalTo: photoView.widthAnchor, multiplier: 0.5),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
            
            
        ])
        
        
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "SomeFilters"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        sliderIntensity.addTarget(self, action: #selector(intensityChanged), for: .valueChanged)
        changeButton.addTarget(self, action: #selector(changeFilter), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(imageSave), for: .touchUpInside)
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
        
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
        
        
    }
    
    @objc func intensityChanged(_ sender: Any) {
        applyProcessing()
        
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func imageSave(_ sender : Any){
        guard let image = imageView.image else {
            let alertController = UIAlertController(title: "Error", message: "Choose photo", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alertController, animated: true)
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func changeFilter(_ sender: Any){
        let alertController = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        alertController.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        alertController.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        alertController.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        alertController.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        alertController.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        alertController.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    func setFilter(action: UIAlertAction){
        guard currentImage != nil else { return }
        
        guard let actionTitle = action.title else { return }
        
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        changeButton.setTitle(action.title, for: .normal)
        applyProcessing()
    }
    
    func applyProcessing(){
        
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(sliderIntensity.value, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(sliderIntensity.value * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(sliderIntensity.value * 10, forKey: kCIInputScaleKey)
        }
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        }
        
        
        
        if let cgImg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent){
            let processedImage = UIImage(cgImage: cgImg)
            
            self.imageView.image = processedImage
        }
        
    }
    

}

