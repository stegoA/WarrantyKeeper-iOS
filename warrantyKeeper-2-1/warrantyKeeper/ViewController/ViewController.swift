//
//  ViewController.swift
//  warrantyKeeper
//
//  Created by anonymous on 16/12/2019.
//  Copyright © 2019 anonymous. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        
        // Create a gradient layer.
               let gradientLayer = CAGradientLayer()
               // Set the size of the layer to be equal to size of the display.
               gradientLayer.frame = view.bounds
               // Set an array of Core Graphics colors (.cgColor) to create the gradient.
               // This example uses a Color Literal and a UIColor from RGB values.
        gradientLayer.colors = [UIColor(red:0.26, green:0.26, blue:0.26, alpha:1.0).cgColor, UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0).cgColor]
               // Rasterize this static layer to improve app performance.
               gradientLayer.shouldRasterize = true
               // Apply the gradient to the backgroundGradientView.
               bg.layer.addSublayer(gradientLayer)
           
        
        
    }
    
    
    func setUpElements(){
        Utilities.styleFilledButton(logInButton)
        Utilities.styleFilledButton(signUpButton)
        
    }


}

