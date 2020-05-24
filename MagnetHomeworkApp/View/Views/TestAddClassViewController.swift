//
//  TestAddClassViewController.swift
//  Bubble
//
//  Created by Tyler Gee on 5/24/20.
//  Copyright © 2020 Beaglepig. All rights reserved.
//

import UIKit

class TestAddClassViewController: UIViewController {
    
    let addClassView: ProgrammaticAddClassView = {
        let addClassView = ProgrammaticAddClassView()
        addClassView.translatesAutoresizingMaskIntoConstraints = false
        
        // Maybe set delegate
        
        return addClassView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(addClassView)
        addClassView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addClassView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
       // addClassView.pinEdgesToView(view)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
