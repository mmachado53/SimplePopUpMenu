//
//  ViewController.swift
//  SimplePopUpMenu
//
//  Created by mmachado53 on 12/09/2019.
//  Copyright (c) 2019 mmachado53. All rights reserved.
//

import UIKit
import SimplePopUpMenu
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sampleClick(_ sender:UIButton){
        let p:PopUpMenuUIViewControler = PopUpMenuUIViewControler()
        p.visibleHeader = true
        p.title = "Title"
    
        let a:PopUpMenuItem = PopUpMenuItem(title: "Item A")
        let b:PopUpMenuItem = PopUpMenuItem(title: "Item B")
        p.showMenu(menuIdentifier: "menu1", viewController: self, items: [a,b], sourceView: sender,permittedArrowDirections: .right)
    }

    @IBAction func navItemAction(_ sender:UIBarButtonItem){
        let p:PopUpMenuUIViewControler = PopUpMenuUIViewControler()        
        let a:PopUpMenuItem = PopUpMenuItem(title: "Item C")
        let b:PopUpMenuItem = PopUpMenuItem(title: "Item D")
        p.showMenu(menuIdentifier: "menu1", viewController: self, items: [a,b], sourceView: sender,permittedArrowDirections: .up)
    }
    
}

