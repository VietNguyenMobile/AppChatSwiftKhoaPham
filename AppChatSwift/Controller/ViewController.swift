//
//  ViewController.swift
//  AppChatSwift
//
//  Created by Macbook on 01/01/2023.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        try! Auth.auth().signOut()
        
        addSubviews()
        isLogin()
    }

    private func addSubviews() {
        view.addSubview(txtEmail)
        view.addSubview(txtPassword)
        view.addSubview(btnRegister)
        view.addSubview(btnLogin)
        view.addSubview(btnForgotPassword)
    }

    @IBAction func onLogin(_ sender: UIButton) {
        let alertActivity: UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let activity: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .large)
        activity.frame = CGRect(x: view.frame.width/2, y: 10, width: 0, height: 0)
        activity.color = UIColor.green
        alertActivity.view.addSubview(activity)
        activity.startAnimating()
        self.present(alertActivity, animated: true)
        
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) {user,error in
           
            if (error == nil) {
                activity.stopAnimating()
                alertActivity.dismiss(animated: true)
                print("Thanh cong")
                self.goToScreen()
            } else {
                activity.stopAnimating()
                alertActivity.dismiss(animated: true)
                let alert = UIAlertController(title: "Thong Bao", message: "Email hoac password không chinh xac!", preferredStyle: .alert)
                let btnOk: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel)
                alert.addAction(btnOk)
                self.present(alert, animated: true)
            }
        }
    }
    
    func isLogin() {
        Auth.auth().addIDTokenDidChangeListener { auth, user in
            if user != nil {
                print("Da dang nhap")
                self.goToScreen()
            } else {
                print("Chua dang nhap")
            }
        }
    }
    
    @IBAction func onRegister(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "goToRegister", sender: nil)
        let screen = self.storyboard?.instantiateViewController(withIdentifier: "StoryBoardRegister")
        if screen != nil {
            self.present(screen!, animated: true)
        } else {
            print("Loi chuyen man hinh")
        }
    }
}

extension UIViewController {
    func goToScreen() {
        let screen = self.storyboard?.instantiateViewController(withIdentifier: "isLogin")
        if screen != nil {
            self.present(screen!, animated: true)
        } else {
            print("Loi chuyen man hinh")
        }
    }
}
