//
//  CountryNumberPickerViewController.swift
//  Speshe
//
//  Created by WT-iOS on 27/3/20.
//  Copyright © 2020 WorkTable. All rights reserved.
//

import UIKit

class CountryNumberPickerViewController: CountryCodePickerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        //navigationController?.navigationBar.standardAppearance = UINavigationBarAppearance.blackBarAppearance
        //navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance.blackBarAppearance
        
//        if navigationController?
//                   .navigationBar.standardAppearance.backgroundImage == nil {
//                   
//                   let gradient = RadialGradientLayer()
//                   gradient.bounds = navigationController?.navigationBar.bounds ?? .zero
//                   gradient.colors = UIColor.gradientColors
//                   if let image = UIImage.getImageFrom(gradientLayer: gradient) {
//                       navigationController?
//                           .navigationBar.standardAppearance.backgroundImage = image
//                   }
//               }
//               
//               if navigationController?
//                   .navigationBar.scrollEdgeAppearance?.backgroundImage == nil {
//                   
//                   let gradient = RadialGradientLayer()
//                   gradient.bounds = navigationController?.navigationBar.bounds ?? .zero
//                   gradient.colors = UIColor.gradientColors
//                   if let image = UIImage.getImageFrom(gradientLayer: gradient) {
//                       navigationController?
//                           .navigationBar.scrollEdgeAppearance?.backgroundImage = image
//                   }
//               }
               
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
            setupNavigationItemLeftBarButtonImage()
           self.setNeedsStatusBarAppearanceUpdate()
           navigationController?.setNavigationBarHidden(false, animated: true)
           navigationController?.navigationBar.prefersLargeTitles = true
//           navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance.blackBarAppearance
           
       }
    
    
    
        func setupNavigationItemLeftBarButtonImage(_ image: UIImage? = R.image.backArrow()) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action:  #selector(leftBarButtonTapped(_:)))
            
        }
    
        @objc func leftBarButtonTapped(_ sender: UIBarButtonItem)
        {
//            if shouldPopToRoot {
//                navigationController?.popToRootViewController(animated: true)
//            } else {
                navigationController?.popViewController(animated: true)
//            }
            
        }
    
}
