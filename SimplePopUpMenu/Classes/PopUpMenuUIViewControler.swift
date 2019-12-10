//
//  PopUpMenuUIViewControler.swift
//  Pods-SimplePopUpMenu_Example
//
//  Created by Miguel Machado on 12/9/19.
//
import UIKit

public class PopUpMenuUIViewControler: UIViewController{
    
    /*CONFIG*/
    var cellHeight:CGFloat = 40
    var padding:CGFloat = 20
    var fontSize:CGFloat = 18.0
    /**/
    var delegate:PopUpMenuDelegate? = nil
    var items:[PopUpMenuItem] = []
    let cellId = "cellId"
    var visibleHeader:Bool = false
    var headerTextColor:UIColor = UIColor.white
    var headerBackgroundColor:UIColor = UIColor.red
    let headerHeight = 40
    let tableView:UITableView = UITableView(
        frame: CGRect(x: 0, y: 0, width: 10, height: 10)
    )
    let titleLabel:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    
    /*CALLBACK HANDLER*/
    public typealias PopUpHandler = (_ selectItem:Int)  -> Void
    public var popUpHandler:PopUpHandler?
    
    
    private var identifier:String = ""
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        //self.popoverPresentationController?.de
        
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    //Updating the popover size
    /* override var preferredContentSize: CGSize {
     get {
     let myString:NSString = "  Add New Client"
     
     let fsize: CGSize = myString.size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18.0)])
     
     let size = CGSize(width: fsize.width+40+40, height: (3*40)+40)
     return size
     }
     set {
     super.preferredContentSize = newValue
     }
     }*/
    
    override public func viewDidLoad() {
        configureTableViewConstraints()
        tableView.rowHeight = CGFloat(cellHeight)
        tableView.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        tableView.separatorColor = UIColor.black.withAlphaComponent(0.3)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PopUpMenuTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = true
        
        if self.visibleHeader {
            configureTitleLabelLabel()
        }
    }
    
    
    func configureTitleLabelLabel(){
        self.view.addSubview(titleLabel)
        self.titleLabel.text = self.title
        self.titleLabel.textAlignment = .center
        self.titleLabel.textColor = headerTextColor
        self.titleLabel.backgroundColor = headerBackgroundColor
        PopUpMenuUIViewControler.configureConstraints(childView: titleLabel, top: 0, left: 0, right: 0, bottom: nil, height: CGFloat(headerHeight))
    }
    
    func configureTableViewConstraints(){
        self.view.addSubview(tableView)
        let top:CGFloat
        if(visibleHeader){
            top = CGFloat(headerHeight + 10)
        }else{
            top = 10
        }
        PopUpMenuUIViewControler.configureConstraints(childView: tableView, top: top, left: 0, right: 0, bottom: -10, height: nil)
    }
    
    @discardableResult static func configureConstraints(childView:UIView,top:CGFloat,left:CGFloat,right:CGFloat,bottom:CGFloat?, height:CGFloat?) -> [String:NSLayoutConstraint]{
        var result:[String:NSLayoutConstraint] = [:]
        childView.translatesAutoresizingMaskIntoConstraints = false
        if let superView:UIView = childView.superview {
            var constraint = NSLayoutConstraint(item: childView, attribute:NSLayoutAttribute.top,relatedBy: NSLayoutRelation.equal,toItem: superView,attribute: NSLayoutAttribute.top,multiplier: 1,constant: top)
            result["top"] = constraint
            superView.addConstraint(constraint)
            
            constraint = NSLayoutConstraint(item: childView,attribute: NSLayoutAttribute.leading,relatedBy: NSLayoutRelation.equal,toItem: superView,attribute: NSLayoutAttribute.leading,multiplier: 1,constant: left)
            
            result["leading"] = constraint
            
            superView.addConstraint(constraint)
            
            constraint = NSLayoutConstraint(item: childView,attribute: NSLayoutAttribute.trailing,relatedBy: NSLayoutRelation.equal,toItem: superView,attribute: NSLayoutAttribute.trailing,multiplier: 1,constant: right)
            result["trailing"] = constraint
            
            superView.addConstraint(constraint)
            
            if let b = bottom {
                constraint = NSLayoutConstraint(item: childView,attribute: NSLayoutAttribute.bottom,relatedBy: NSLayoutRelation.equal,toItem: superView,attribute: NSLayoutAttribute.bottom,multiplier: 1,constant: b)
                
                result["bottom"] = constraint
                superView.addConstraint(constraint)
            }
            if let h = height {
                constraint = childView.heightAnchor.constraint(equalToConstant: h)
                constraint.isActive = true
                result["height"] = constraint
            }
            
            
            superView.updateConstraints()
        }
        return result
        
    }
    public func presentSelf(identifier:String,viewController:UIViewController,items:[PopUpMenuItem],sourceView:Any?,permittedArrowDirections:UIPopoverArrowDirection = .any, sourceRect:CGRect? = nil){
        self.identifier = identifier
        self.items = items
        self.calculateContentSizes()
        self.modalPresentationStyle = UIModalPresentationStyle.popover
        
        self.popoverPresentationController?.delegate = self
        self.popoverPresentationController?.permittedArrowDirections = permittedArrowDirections
        if let sourceView:UIView = sourceView as? UIView{
            self.popoverPresentationController?.sourceView = sourceView
        }else if let menuItem:UIBarButtonItem = sourceView as? UIBarButtonItem{
            self.popoverPresentationController?.barButtonItem = menuItem
        }
        if let sourceRect:CGRect = sourceRect {
            popoverPresentationController?.sourceRect = sourceRect
        }
        
        viewController.present(self, animated: true) {
            
        }
        
    }
    
    func setHandler( handler:@escaping PopUpHandler){
        self.popUpHandler = handler
    }
    
    private func calculateContentSizes(){
        var width:CGFloat = 0.0
        for item in self.items{
            let myString:NSString = "   \(item.title)" as NSString
            
            let fsize: CGSize = myString.size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize)])
            let iconWidth = item.uiImage == nil ? 0 : cellHeight
            if(width<fsize.width+iconWidth){
                width = fsize.width+iconWidth
            }
        }
        width = width + (padding*2.0)
        let height:CGFloat
        if(visibleHeader){
            height = (CGFloat(items.count) * cellHeight) + (10.0*2.0) + CGFloat(headerHeight)
        }else{
            height = (CGFloat(items.count) * cellHeight) + (10.0*2.0)
        }
        
        self.preferredContentSize = CGSize(width: width, height: height)
    }
    
}

extension PopUpMenuUIViewControler:UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PopUpMenuTableViewCell
        let item:PopUpMenuItem = self.items[indexPath.row]
        cell.button.setTitle("  \(item.title)", for: .normal)
        cell.button.setImage(item.uiImage, for: .normal)
        cell.applyPaddings(self.padding)
        return cell
    }
    private func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            self.delegate?.popupmenu(selectItem: indexPath.row, identifier: self.identifier)
            self.popUpHandler?(indexPath.row)
        }
    }
    
}


extension PopUpMenuUIViewControler : UIPopoverPresentationControllerDelegate{
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

class PopUpMenuTableViewCell:UITableViewCell{
    let button:UIButton = UIButton(type: .custom )
    
    private var buttonConstraints:[String:NSLayoutConstraint]?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(button)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        button.setTitle("  ", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = button.titleLabel?.font.withSize(18)
        button.isUserInteractionEnabled = false
        self.buttonConstraints = PopUpMenuUIViewControler.configureConstraints(childView: button, top: 0, left: 0, right: 0, bottom: 0, height:
            nil)
        
    }
    
    func applyPaddings(_ padding:CGFloat){
        buttonConstraints?["leading"]?.constant = padding
        buttonConstraints?["trailing"]?.constant = padding * -1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



public class PopUpMenuItem{
    var uiImage:UIImage?
    var title:String = ""
    public init(title:String,uiImage:UIImage? = nil) {
        self.title = title
        self.uiImage = uiImage
    }
}

public protocol PopUpMenuDelegate{
    func popupmenu(selectItem:Int,identifier:String)
}
