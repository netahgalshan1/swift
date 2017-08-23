//
//  SignUpViewController.swift
//  MaranathApp
//
//  Created by Frezy Stone Mboumba on 8/11/16.
//  Copyright © 2016 Frezy Stone Mboumba. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView! {
        didSet{
            userImageView.layer.cornerRadius = 5
            userImageView.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var firstLastNameTextField: UITextField!{
        didSet{
            firstLastNameTextField.layer.cornerRadius = 5
            firstLastNameTextField.delegate = self
        }
    }

    
    @IBOutlet weak var usernameTextField: UITextField!{
        didSet{
            usernameTextField.layer.cornerRadius = 5
            usernameTextField.delegate = self
        }
    }

    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
            emailTextField.layer.cornerRadius = 5
            emailTextField.delegate = self
        }
    }

    @IBOutlet weak var biographyTextField: UITextField!{
        didSet{
            biographyTextField.layer.cornerRadius = 5
            biographyTextField.delegate = self
        }
    }

    @IBOutlet weak var countryTextField: UITextField!{
        didSet{
            countryTextField.layer.cornerRadius = 5
            countryTextField.delegate = self
        }
    }

    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            passwordTextField.layer.cornerRadius = 5
            passwordTextField.delegate = self
        }
    }

    @IBOutlet weak var signUpButton: UIButton!{
        didSet{
            signUpButton.layer.cornerRadius = 5
            signUpButton.layer.borderWidth = 1
            signUpButton.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.1).cgColor
        }
    }

    
    var pickerView: UIPickerView!
    var countryArrays = [String]()
    var authService = AuthService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpPickerView()
        setGestureRecognizersToDismissKeyboard()
        retrievingCountries()
        
        
            }
    
    
    func showMessage() {
        
        let alertController = UIAlertController(title: "OOPS", message: "A user with the same username already exists. Please choose another one", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    @IBAction func signUpAction(sender: UIButton) {
        
        let email = emailTextField.text!.lowercased()
        let finalEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let country = countryTextField.text!
        let biography = biographyTextField.text!
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        let firstLastName = firstLastNameTextField.text!
        let pictureData = UIImageJPEGRepresentation(self.userImageView.image!, 0.70)
        
        if finalEmail.isEmpty || country.isEmpty || biography.isEmpty || username.isEmpty || password.isEmpty {
            self.view.endEditing(true)
            let alertController = UIAlertController(title: "OOPS", message: "hEY MAN, You gotta fill all the fields", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
            
        }else {
            self.view.endEditing(true)
            authService.signUp(firstLastName: firstLastName,username: username, email: finalEmail, country: country, biography: biography, password: password, pictureData: pictureData as NSData!)
            
        }
 
    }
    
   }



//--------------------------------------------------------------------------------------------------------------------

extension SignUpViewController: UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func setUpPickerView(){
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor(white: 0.3, alpha: 1.0)

        countryTextField.inputView = pickerView
        }
    
    func setGestureRecognizersToDismissKeyboard(){
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.choosePictureAction(sender:)))
        imageTapGesture.numberOfTapsRequired = 1
        userImageView.addGestureRecognizer(imageTapGesture)
        
        // Creating Tap Gesture to dismiss Keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        // Creating Swipe Gesture to dismiss Keyboard
        let swipDown = UISwipeGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard(gesture:)))
        swipDown.direction = .down
        view.addGestureRecognizer(swipDown)
    }
    
    func retrievingCountries(){
        for code in NSLocale.isoCountryCodes as [String]{
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_EN").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            
            countryArrays.append(name)
            countryArrays.sort(by: { (name1, name2) -> Bool in
                name1 < name2
            })
        }
    }
    
    func choosePictureAction(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        let alertController = UIAlertController(title: "Add a Profile Picture", message: "Choose From", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
            
        }
        let photosLibraryAction = UIAlertAction(title: "Photos Library", style: .default) { (action) in
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let savedPhotosAction = UIAlertAction(title: "Saved Photos Album", style: .default) { (action) in
            pickerController.sourceType = .savedPhotosAlbum
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        alertController.addAction(savedPhotosAction)
        alertController.addAction(cancelAction)
        
        
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage]  as? UIImage{
            self.userImageView.image = image
        }else if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.userImageView.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToLogin(storyboard: UIStoryboardSegue){}
    
    
    // Dismissing the Keyboard with the Return Keyboard Button
    func dismissKeyboard(gesture: UIGestureRecognizer){
        self.view.endEditing(true)
    }
    
    // Dismissing the Keyboard with the Return Keyboard Button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        countryTextField.resignFirstResponder()
        biographyTextField.resignFirstResponder()
        return true
    }
    
    // Moving the View down after the Keyboard appears
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateView(up: true, moveValue: 45)
    }
    
    // Moving the View down after the Keyboard disappears
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateView(up: false, moveValue: 45)
    }
    
    
    // Move the View Up & Down when the Keyboard appears
    func animateView(up: Bool, moveValue: CGFloat){
        
        let movementDuration: TimeInterval = 0.3
        let movement: CGFloat = (up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    // MARK: - Picker view data source
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryArrays[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryTextField.text = countryArrays[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryArrays.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = NSAttributedString(string: countryArrays[row], attributes: [NSForegroundColorAttributeName: UIColor.white])
        return title
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as! UILabel!
        if label == nil {
            label = UILabel()
        }
        
        let data = countryArrays[row]
        let title = NSAttributedString(string: data, attributes: [NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 18.0)!,NSForegroundColorAttributeName: UIColor.white])
        label?.attributedText = title
        label?.textAlignment = .center
        return label!
        
    }

    
}
