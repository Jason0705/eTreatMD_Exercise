//
//  PatientInfoVC.swift
//  eTreatMD_Exercise
//
//  Created by Jason Li on 2019-09-18.
//

import UIKit
import CoreData

class PatientInfoVC: UIViewController {
    //-----------------
    // MARK: - Variables
    //-----------------
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var patient: Patient?
    
    //-----------------
    // MARK: - UIOutlets
    //-----------------
    @IBOutlet weak var photoImageView: UIImageView! {
        didSet {
            photoImageView.layer.cornerRadius = photoImageView.frame.height / 2
            photoImageView.layer.borderColor = UIColor.blue.cgColor
            photoImageView.layer.borderWidth = 2.0
            
            photoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(photoImageTapped)))
        }
    }
    @IBOutlet weak var changePhotoBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    
    //-----------------
    // MARK: - Init
    //-----------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        fetchImage()
    }
    
    func setUp() {
        labelSetUp()
    }
    
    func labelSetUp() {
        guard let name = patient?.name, let id = patient?.id else { return }
        nameLbl.text = name
        idLbl.text = "ID: \(id)"
        
    }
}

//-----------------
// MARK: - Touches
//-----------------
extension PatientInfoVC {
    @objc func photoImageTapped() {
        AlertService.alertService.presentPhotoActionSheet(openCamera: { [weak self] in
            guard let `self` = self else { return }
            self.openCamera()
        }) { [weak self] in
            guard let `self` = self else { return }
            self.openPhotoLibrary()
        }
    }
}

//-----------------
// MARK: - IBActions
//-----------------
extension PatientInfoVC {
    @IBAction func changePhotoBtnTouchUpInside(_ sender: UIButton) {
        AlertService.alertService.presentPhotoActionSheet(openCamera: { [weak self] in
            guard let `self` = self else { return }
            self.openCamera()
        }) { [weak self] in
            guard let `self` = self else { return }
            self.openPhotoLibrary()
        }
    }
}

//-----------------
// MARK: - UIImagePickerController Delegate
//-----------------
extension PatientInfoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            dismiss(animated: true) {
                AlertService.alertService.presentErrorAlert(title: "Oops", message: "Your action was unsuccessful.\nPlease try again.")
            }
            return
        }
        photoImageView.image = image
        
        // Save Image On Device
        if let patientID = patient?.id {
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let documentPath = documentsURL.path
            let filePath = documentsURL.appendingPathComponent("\(patientID).png")
            
            do {
                let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                
                for file in files {
                    if "\(documentPath)/\(file)" == filePath.path {
                        try fileManager.removeItem(atPath: filePath.path)
                    }
                }
            } catch {
                print("Could not add image from document directory: \(error)")
            }
            
            do {
                if let jpegImageData = image.jpegData(compressionQuality: 0.5) {
                    try jpegImageData.write(to: filePath, options: .atomic)
                }
            } catch {
                print("couldn't write image")
            }
            
            let container = appDelegate.persistentContainer
            let context = container.viewContext
            let entity = Image(context: context)
            entity.filePath = filePath.path
            
            appDelegate.saveContext()
        }
        
        
    }
}

//-----------------
// MARK: - Functions
//-----------------
extension PatientInfoVC {
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func fetchImage() {
        let container = appDelegate.persistentContainer
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<Image>(entityName: "Image")
        
        do {
            let images = try context.fetch(fetchRequest)
            for image in images {
                if let patientID = patient?.id, let filePath = image.filePath, filePath.contains(patientID) {
                    if FileManager.default.fileExists(atPath: filePath), let contentsOfFilePath = UIImage(contentsOfFile: filePath) {
                        photoImageView.image = contentsOfFilePath
                    }
                }
            }
        } catch {
            print("entered catch for image fetch request")
        }
    }
}
