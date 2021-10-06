//
//  view.swift
//  olds
//
//  Created by Raphael Alkamim on 05/10/21.
//

import Foundation
import UIKit
class ViewOnboarding:UIView{
    
    
    let labelTitulo = UILabel()
    var imageDescription = ""
    let label = UILabel()
    var imageName = String()
    lazy var image = UIImage(named: imageName)
    lazy var imageView = UIImageView(image: image!)
    
    func setup(titulo:String,text:String,imageName:String, imageDescription:String){
        
        labelTitulo.text=titulo
        labelTitulo.textAlignment = .center
        labelTitulo.font = UIFont .boldSystemFont(ofSize:  45.0)
        labelTitulo.textColor = .label
        self.addSubview(labelTitulo)
        
        label.text = text
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont .boldSystemFont(ofSize: 25.0)
        self.addSubview(label)
        label.textColor = .label
        self.imageDescription = imageDescription
        self.imageName = imageName
        self.addSubview(imageView)
        setupConstrainstsOnbarding()
        setUpVoiceOver()
    }
    
    func setUpVoiceOver () {
        imageView.isAccessibilityElement = true
        imageView.accessibilityLabel = imageDescription
        
    }
    
    
    func setupConstrainstsOnbarding(){
        
        labelTitulo.translatesAutoresizingMaskIntoConstraints = false
        let labelTituloConstraints:[NSLayoutConstraint] = [
            labelTitulo.topAnchor.constraint(equalTo: self.topAnchor),
            labelTitulo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            labelTitulo.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30)
        ]
        NSLayoutConstraint.activate(labelTituloConstraints)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        let labelConstraints:[NSLayoutConstraint] = [
            label.topAnchor.constraint(equalTo: labelTitulo.bottomAnchor,constant: 30),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30)
        ]
        NSLayoutConstraint.activate(labelConstraints)
        
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imgConstrainsts:[NSLayoutConstraint] = [
            imageView.widthAnchor.constraint(equalToConstant: 400),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 100)
        ]
        NSLayoutConstraint.activate(imgConstrainsts)
        
        
    }
}
