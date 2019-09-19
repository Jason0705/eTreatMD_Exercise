//
//  PatientInfoVC.swift
//  eTreatMD_Exercise
//
//  Created by Jason Li on 2019-09-18.
//

import UIKit

class PatientInfoVC: UIViewController {
    //-----------------
    // MARK: - Variables
    //-----------------
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
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            dismiss(animated: true) {
                AlertService.alertService.presentErrorAlert(title: "Oops", message: "Your action was unsuccessful.\nPlease try again.")
            }
            return
        }
        photoImageView.image = image
        dismiss(animated: true, completion: nil)
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
}
