//
//  ViewController.swift
//  Project13Instafilter
//
//  Created by Joshua on 7/11/19.
//  Copyright © 2019 JHC Dev. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // UI objects
    var backgroundView = UIView()
    var imageView = UIImageView()
    var intensityLabel = UILabel()
    var intensitySlider = UISlider()
    var changeFilterButton = UIButton(type: .roundedRect)
    var saveButton = UIButton(type: .roundedRect)
    
    var currentImage: UIImage!
    var context: CIContext!
    var currentFilter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Instafilter"
        
        // set up Core Image variables
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: 470.0).isActive = true
        backgroundView.backgroundColor = .darkGray
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        imageView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10.0).isActive = true
        imageView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 10.0).isActive = true
        imageView.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -10.0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10.0).isActive = true
        imageView.contentMode = .scaleAspectFit
        
        view.addSubview(intensityLabel)
        intensityLabel.translatesAutoresizingMaskIntoConstraints = false
        intensityLabel.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 30.0).isActive = true
        intensityLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        intensityLabel.widthAnchor.constraint(equalToConstant: 72.0).isActive = true
        intensityLabel.heightAnchor.constraint(equalToConstant: 21.0).isActive = true
        intensityLabel.text = "Intensity"
        intensityLabel.textAlignment = .right
        
        view.addSubview(intensitySlider)
        intensitySlider.translatesAutoresizingMaskIntoConstraints = false
        intensitySlider.centerYAnchor.constraint(equalTo: intensityLabel.centerYAnchor).isActive = true
        intensitySlider.leftAnchor.constraint(equalTo: intensityLabel.rightAnchor, constant: 8.0).isActive = true
        intensitySlider.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        intensitySlider.addTarget(self, action: #selector(intensityChanged), for: .valueChanged)
        
        view.addSubview(changeFilterButton)
        changeFilterButton.translatesAutoresizingMaskIntoConstraints = false
        changeFilterButton.topAnchor.constraint(equalTo: intensityLabel.bottomAnchor, constant: 30.0).isActive = true
        changeFilterButton.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        changeFilterButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        changeFilterButton.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        changeFilterButton.setTitle(currentFilter.name, for: .normal)
        changeFilterButton.titleLabel?.textAlignment = .center
        changeFilterButton.addTarget(self, action: #selector(changeFilter), for: .touchUpInside)
        
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.centerYAnchor.constraint(equalTo: changeFilterButton.centerYAnchor).isActive = true
        saveButton.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.textAlignment = .center
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
    }
    
    @objc func intensityChanged() {
        applyProcessing()
    }
    
    @objc func changeFilter() {
        let alertController = UIAlertController(title: "Change filter", message: nil, preferredStyle: .actionSheet)
        let filters = ["CIBumpDistortion", "CIGaussianBlur", "CIPixellate", "CISepiaTone", "CITwirlDistortion", "CIVignette"]
        for filter in filters {
            alertController.addAction(UIAlertAction(title: filter, style: .default, handler: setFilter))
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    func setFilter(action: UIAlertAction) {
        guard currentImage != nil else { return }
        guard let actionTitle = action.title else { return }
        currentFilter = CIFilter(name: actionTitle)
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        changeFilterButton.setTitle(currentFilter.name, for: .normal)
        applyProcessing()
    }

    @objc func save() {
        guard let image = imageView.image else {
            let alertController = UIAlertController(title: "No image", message: "There is no image to save.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alertController = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        } else {
            let alertController = UIAlertController(title: "Saved!", message: "The image was saved to your library.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        }
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    func applyProcessing() {
        if currentImage == nil { return }
        
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensitySlider.value, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensitySlider.value * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensitySlider.value * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
        
        if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            self.imageView.image = processedImage
        }
    }
    
    
}

