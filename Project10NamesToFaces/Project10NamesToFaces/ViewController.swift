//
//  ViewController.swift
//  Project10NamesToFaces
//
//  Created by Joshua on 7/4/19.
//  Copyright © 2019 JHC Dev. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // add photos buttons
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.backgroundColor = UIColor(white: 0, alpha: 0.1)
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    @objc func addNewPerson() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alertController = UIAlertController(title: "Add new image", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "New Photo", style: .default) { [weak self] _ in
                print("use camera")
                self?.getNewImage(UIImagePickerController.SourceType.camera)
            })
            alertController.addAction(UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
                print("use library")
                self?.getNewImage(UIImagePickerController.SourceType.photoLibrary)
            })
            present(alertController, animated: true)
            print("done with source selector")
        } else {
            getNewImage()
        }
    }
    
    func getNewImage(_ imageSource: UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary) {
        let picker = UIImagePickerController()
        picker.sourceType = imageSource
        picker.allowsEditing = true
        picker.delegate = self
        print("presenting picker")
        present(picker, animated: true)
    }
    
    // save images imported by user
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // save image to Documents
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        // save new person information
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // change image name
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let alertController = UIAlertController(title: "Image Selected", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self, weak person] _ in
            self?.renameImage(person: person!)
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.collectionView.reloadData()
        })
        
        present(alertController, animated: true)
    }
    
    // change name of an image
    func renameImage(person: Person) {
        let alertController = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak alertController] _ in
            guard let newName = alertController?.textFields?[0].text else { return }
            person.name = newName
            self?.collectionView.reloadData()
        })
        
        present(alertController, animated: true)
    }
}

