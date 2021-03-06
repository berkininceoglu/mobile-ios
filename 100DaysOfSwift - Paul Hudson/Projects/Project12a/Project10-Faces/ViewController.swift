//
//  ViewController.swift
//  Project10-Faces
//
//  Created by Berkin İnceoğlu on 27.10.2021.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate
{
    var people = [Person]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPerson))
        
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "people") as? Data{
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Person]{
                people = decodedPeople
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else{
            fatalError("Unable to dequeue person cell.")
        }
        
        let person = people[indexPath.item]
        cell.name.text = person.name
        cell.name.textColor = .systemBackground
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        let ac = UIAlertController(title: "Rename/Delete", message: "Wanna change the name or delete it?", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Rename", style: .default) {
            [weak self] _ in
            let renameAlert = UIAlertController(title: "Change Name", message: "Wanna change the name?", preferredStyle: .alert)
            
            renameAlert.addTextField()
            
            renameAlert.addAction(UIAlertAction(title: "OK", style: .default) {
                [weak self, weak renameAlert] _ in
            guard let newName = renameAlert?.textFields?[0].text else { return }
            person.name = newName
                self?.save()
            self?.collectionView.reloadData()
            })
            
            self?.present(renameAlert, animated: true)
        })
        
        ac.addAction(UIAlertAction(title: "Delete", style: .default) {
            [weak self] _ in
            if let index = self?.people.firstIndex(of: person){
                self?.people.remove(at: index)
            }
            self?.collectionView.reloadData()
            
        })
        
        present(ac, animated: true)
    }
    
    @objc func addPerson(){
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unkown", image: imageName)
        people.append(person)
        save()
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory()-> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save(){
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false){
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        }
    }


}

