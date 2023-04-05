//
//  CameraView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-02.
//

import SwiftUI

struct CameraView: UIViewRepresentable {
    var onCapture: ((UIImage) -> Void)?
    
    //button functionality
    func makeUIView(context: Context) -> UIButton {
        let button = UIButton()
        button.addTarget(context.coordinator, action: #selector(Coordinator.takePhoto), for: .touchUpInside)
        return button
    }
    
    //button appearance
    func updateUIView(_ uiView: UIButton, context: Context) {
        uiView.backgroundColor = .orange
        uiView.layer.cornerRadius = 15.0
        uiView.setTitle("Take Profile Picture", for: .normal)
        uiView.setTitleColor(.white, for: .normal)
        uiView.bounds = CGRect(x: 0, y: 0, width: 300, height: 60)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, onCapture: onCapture)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        var onCapture: ((UIImage) -> Void)?
        
        init(parent: CameraView, onCapture: ((UIImage) -> Void)?) {
            self.parent = parent
            self.onCapture = onCapture
        }
        
        @objc func takePhoto() {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController
            else {
                return
            }
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
                imagePicker.sourceType = .camera
                rootViewController.present(imagePicker, animated: true, completion: nil)
            }
            
            let libraryAction = UIAlertAction(title: "Choose from Library", style: .default) { _ in
                imagePicker.sourceType = .photoLibrary
                rootViewController.present(imagePicker, animated: true, completion: nil)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(cameraAction)
            alertController.addAction(libraryAction)
            alertController.addAction(cancelAction)
            
            rootViewController.present(alertController, animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                onCapture?(selectedImage)
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
