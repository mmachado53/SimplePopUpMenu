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
    
    let likeIconImage:UIImage = UIImage(named: "like_icon")!
    let heartIconImage:UIImage = UIImage(named: "heart_icon")!
    var customPopupStyle:PopUpMenuStyle = PopUpMenuStyle()

    override func viewDidLoad() {
        super.viewDidLoad()
        customPopupStyle.baseColor = UIColor.black.withAlphaComponent(0.8)
        customPopupStyle.textColor = UIColor.white
        customPopupStyle.selectedBackgroundColor = UIColor.white.withAlphaComponent(0.1)
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
        p.style = customPopupStyle
        let a:PopUpMenuItem = PopUpMenuItem(title: "Item A",uiImage: likeIconImage)
        let b:PopUpMenuItem = PopUpMenuItem(title: "Item B", uiImage: heartIconImage)
        p.showMenu(menuIdentifier: "menu1", viewController: self, items: [a,b], sourceView: sender,permittedArrowDirections: .right)
        p.setHandler { (selected) in
            print("SELECTED \(selected)")
        }
    }

    @IBAction func navItemAction(_ sender:UIBarButtonItem){
        let p:PopUpMenuUIViewControler = PopUpMenuUIViewControler()        
        let a:PopUpMenuItem = PopUpMenuItem(title: "Item C", uiImage: heartIconImage,tintImage: true)
        let b:PopUpMenuItem = PopUpMenuItem(title: "Item D",uiImage: likeIconImage,tintImage: true)
        p.showMenu(menuIdentifier: "menu2", viewController: self, items: [a,b], sourceView: sender,permittedArrowDirections: .up)
        p.delegate = self
    }
    
}

extension ViewController : PopUpMenuDelegate{
    func popupmenu(selectItem: Int, menuIdentifier: String) {
        print("MENU TYPE \(menuIdentifier), selected: \(selectItem)")
    }
    
    
}

