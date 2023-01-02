//
//  ScreenRegisterViewController.swift
//  AppChatSwift
//
//  Created by Macbook on 01/01/2023.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

let storage = Storage.storage()
let storageRef = storage.reference(forURL: "gs://appchatswift-e8949.appspot.com")

class ScreenRegisterViewController: UIViewController {
    
    var imgData:Data!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtPWD: UITextField!
    @IBOutlet weak var txtRPWD: UITextField!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addSubviews()
        imgData = UIImage(named: "Camera")?.pngData()
    }
    
    @IBAction func tapAvatar(_ sender: UITapGestureRecognizer) {
        let alert: UIAlertController = UIAlertController(title: "Thong Bao", message: "Chon", preferredStyle: .alert)
        let btnPhoto: UIAlertAction = UIAlertAction(title: "Photo", style: .default) {_ in
            let imgPicker = UIImagePickerController()
            imgPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imgPicker.delegate = self
            imgPicker.allowsEditing = false
            self.present(imgPicker, animated: true)
        }
        let btnCamera: UIAlertAction = UIAlertAction(title: "Camera", style: .default) {_ in
            if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
                let imgPicker = UIImagePickerController()
                imgPicker.sourceType = UIImagePickerController.SourceType.camera
                imgPicker.delegate = self
                imgPicker.allowsEditing = false
                self.present(imgPicker, animated: true)
            } else {
                print("Khong co Camera")
            }
        }
        alert.addAction(btnPhoto)
        alert.addAction(btnCamera)
        self.present(alert, animated: true)
    }
    
    
    @IBAction func onRegister(_ sender: UIButton) {
        let email: String = txtEmail.text!
        let password: String = txtPWD.text!
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if (error == nil) {
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if (error == nil) {
                        print("Dang nhap thanh cong")
                    }
                }
                
                let avatarRef = storageRef.child("images/\(email).jpg")
                let uploadTask = avatarRef.putData(self.imgData, metadata: nil) { metadata, error in
                    if (error != nil) {
                        print("Loi up hinh avatar")
                    } else {
                        avatarRef.downloadURL() { (url, error) in
                            if (error == nil) {
                                let user = Auth.auth().currentUser
                                if let user = user {
                                    let changeRequest = user.createProfileChangeRequest()
                                    changeRequest.displayName = self.txtFullName.text!
                                    changeRequest.photoURL = url
                                    changeRequest.commitChanges() { error in
                                        if (error == nil) {
                                            // An error happend.
                                            print("Dang ky thanh cong")
                                            self.goToScreen()
                                        } else {
                                            print("Loi update profile")
                                            
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                }
                uploadTask.resume()
                
               
            } else {
                
            }
        }
    }
    
    private func addSubviews() {
        view.addSubview(txtEmail)
        view.addSubview(txtFullName)
        view.addSubview(txtPWD)
        view.addSubview(txtRPWD)
        view.addSubview(imgAvatar)
        view.addSubview(btnRegister)
        view.addSubview(btnLogin)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgAvatar.image = UIImage(named: "Camera")
        imgAvatar.layer.cornerRadius = 8.0
    }
    
    @IBAction func onLogin(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "goToLogin", sender: nil)
        let screen = self.storyboard?.instantiateViewController(withIdentifier: "StoryBoardLogin")
        if screen != nil {
            self.present(screen!, animated: true)
        } else {
            print("Loi chuyen man hinh")
        }
    }
    

}

extension ScreenRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chooseImg = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let imgValue = max(chooseImg.size.width, chooseImg.size.height)
        if (imgValue > 3000) {
            imgData = chooseImg.jpegData(compressionQuality: 0.1)
        } else if (imgValue > 2000) {
            imgData = chooseImg.jpegData(compressionQuality: 0.3)
        } else {
            imgData = chooseImg.jpegData(compressionQuality: 1)
        }
        imgAvatar.image = UIImage(data: imgData)
        dismiss(animated: true)
    }
}
