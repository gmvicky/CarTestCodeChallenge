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
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        setupNavigationItemLeftBarButtonImage()
       self.setNeedsStatusBarAppearanceUpdate()
       navigationController?.setNavigationBarHidden(false, animated: true)
       navigationController?.navigationBar.prefersLargeTitles = true
   }
    
    func setupNavigationItemLeftBarButtonImage(_ image: UIImage? = R.image.backArrow()) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action:  #selector(leftBarButtonTapped(_:)))
        
    }

    @objc func leftBarButtonTapped(_ sender: UIBarButtonItem)
    {
        navigationController?.popViewController(animated: true)
    }
    
}
