//
//  PopUpMenuUIViewControler.swift
//  Pods-SimplePopUpMenu_Example
//
//  Created by Miguel Machado on 12/9/19.
//
import UIKit

public class PopUpMenuUIViewControler: UIViewController{
    
    // MARK: GLOBAL VARS
    public static var globalStyle:PopUpMenuStyle = PopUpMenuStyle()
    
    // MARK: dimens
    fileprivate static let cellHeight:CGFloat = 40
    fileprivate static let padding:CGFloat = 20
    fileprivate static let fontSize:CGFloat = 18.0
    fileprivate static let headerHeight = 40
    // MARK: identifier
    private var identifier:String = ""
    // MARK: items
    private var items:[PopUpMenuItem] = []
    // MARK: Colors
    public var style:PopUpMenuStyle?
    private var currentStyle:PopUpMenuStyle {
        get{
            if let st:PopUpMenuStyle = self.style {
                return st
            }
            return PopUpMenuUIViewControler.globalStyle
        }
    }
    // MARK: child views
    fileprivate let cellId = "cellId"
    private let tableView:UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    private let titleLabel:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    
    // MARK: public vars
    /// if true, a header will be displayed in the menu (set a value in the "title" property) default is false
    public var visibleHeader:Bool = false
    
    // MARK: CALLBACK AND DELEGATE HANDLERS
    public typealias PopUpHandler = (_ selectItem:Int)  -> Void
    /// A simple handler CallBack can use a delegate (PopUpMenuDelegate) instead
    private var popUpHandler:PopUpHandler?
    /// A simple delegate CallBack can use a popUpHandler (PopUpHandler) instead
    public var delegate:PopUpMenuDelegate? = nil
    
    
    
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override public func viewDidLoad() {
        configureTableView()
        configureTitleLabelLabel()
        self.view.backgroundColor = UIColor.clear
    }
    
    
    private func configureTitleLabelLabel(){
        if self.visibleHeader == false {return}
        self.view.addSubview(titleLabel)
        self.titleLabel.text = self.title
        self.titleLabel.textAlignment = .center
        let st = currentStyle
        self.titleLabel.textColor = st.headerTextColor
        self.titleLabel.backgroundColor = st.headerColor
        configureConstraints(childView: titleLabel, top: 0, left: 0, right: 0, bottom: nil, height: CGFloat(PopUpMenuUIViewControler.headerHeight),width: nil)
    }
    
    private func configureTableView(){
        self.view.addSubview(tableView)
        let top:CGFloat = visibleHeader ? CGFloat(PopUpMenuUIViewControler.headerHeight) + 5 : 10
        configureConstraints(childView: tableView, top: top, left: 0, right: 0, bottom: -10, height: nil,width: nil)
        tableView.rowHeight = CGFloat(PopUpMenuUIViewControler.cellHeight)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PopUpMenuTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = true
        
    }
    
    
    public func showMenu(
        menuIdentifier:String,
        viewController:UIViewController,
        items:[PopUpMenuItem],
        sourceView:Any,
        permittedArrowDirections:UIPopoverArrowDirection = .any,
        sourceRect:CGRect? = nil){
        
        self.identifier = menuIdentifier
        self.items = items
        self.calculateContentSizes()
        self.modalPresentationStyle = UIModalPresentationStyle.popover
        self.popoverPresentationController?.delegate = self
        let st:PopUpMenuStyle = self.currentStyle
        self.popoverPresentationController?.backgroundColor = st.baseColor
        self.popoverPresentationController?.permittedArrowDirections = permittedArrowDirections
        var sourceViewWidth:CGFloat = 0
        var sourceViewHeight:CGFloat = 0
        if let sourceView:UIView = sourceView as? UIView{
            self.popoverPresentationController?.sourceView = sourceView
            sourceViewWidth = sourceView.frame.width
            sourceViewHeight = sourceView.frame.height
        }else if let menuItem:UIBarButtonItem = sourceView as? UIBarButtonItem{
            self.popoverPresentationController?.barButtonItem = menuItem
        }
        if let sourceRect:CGRect = sourceRect {
            popoverPresentationController?.sourceRect = sourceRect
        }else{
            popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: sourceViewWidth, height: sourceViewHeight)
        }
        
        viewController.present(self, animated: true) {
            
        }
        
    }
    
    public func setHandler( handler:@escaping PopUpHandler){
        self.popUpHandler = handler
    }
    
    private func calculateContentSizes(){
        var width:CGFloat = 0.0
        for item in self.items{
            let myString:NSString = "   \(item.title)" as NSString
            
            let fsize: CGSize = myString.size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: PopUpMenuUIViewControler.fontSize)])
            let iconWidth = item.uiImage == nil ? 0 : PopUpMenuUIViewControler.cellHeight
            if(width<fsize.width+iconWidth){
                width = fsize.width+iconWidth
            }
        }
        width = width + (PopUpMenuUIViewControler.padding*2.0)
        let height:CGFloat
        if(visibleHeader){
            height = (CGFloat(items.count) * PopUpMenuUIViewControler.cellHeight) + (10.0*2.0) + CGFloat(PopUpMenuUIViewControler.headerHeight)
        }else{
            height = (CGFloat(items.count) * PopUpMenuUIViewControler.cellHeight) + (10.0*2.0)
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
        cell.label.text = "  \(item.title)"
        cell.setIcon(iconImage: item.uiImage)
        cell.applyStyle(style: self.currentStyle)
        cell.separator.isHidden = indexPath.row == self.items.count - 1
        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                self.delegate?.popupmenu(selectItem: indexPath.row, menuIdentifier: self.identifier)
                self.popUpHandler?(indexPath.row)
            }
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
    let label:UILabel = UILabel()
    let iconImageView:UIImageView = UIImageView()
    
    public let separator:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    private var labelConstraints:[String:NSLayoutConstraint]?
    private var iconWidth:CGFloat = PopUpMenuUIViewControler.cellHeight - 16
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.iconImageView.contentMode = .scaleAspectFit
        addSubview(label)
        addSubview(iconImageView)
        addSubview(separator)
        self.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: PopUpMenuUIViewControler.fontSize)
        self.labelConstraints = configureConstraints(childView: label, top: 0, left: 0, right: 0, bottom: 0, height:
            nil, width: nil)
        configureConstraints(childView: iconImageView, top: 0, left: PopUpMenuUIViewControler.padding, right: nil, bottom: 0, height:nil , width: iconWidth)
        configureConstraints(childView: separator, top: nil, left: 0, right: 0, bottom: 0, height: 0.5, width: nil)
        self.selectedBackgroundView = UIView()
        
    }
    
    func setIcon(iconImage:UIImage?){
        self.iconImageView.image = iconImage

        labelConstraints?["leading"]?.constant = iconImage != nil ? self.iconWidth + 2 + PopUpMenuUIViewControler.padding : PopUpMenuUIViewControler.padding
        labelConstraints?["trailing"]?.constant = PopUpMenuUIViewControler.padding * -1
    }
    
    func applyStyle(style:PopUpMenuStyle){
        self.selectedBackgroundView?.backgroundColor = style.selectedBackgroundColor
        self.separator.backgroundColor = style.itemSeparatorColor
        self.label.textColor = style.textColor
        self.iconImageView.tintColor = style.textColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



public class PopUpMenuItem{
    var uiImage:UIImage?
    var title:String = ""
    var tintImage:Bool = false
    public init(title:String,uiImage:UIImage? = nil,tintImage:Bool = false) {
        self.title = title
        self.uiImage = uiImage
        self.tintImage = tintImage
        if(self.tintImage){
            self.uiImage = uiImage?.withRenderingMode(.alwaysTemplate)
        }
    }
}

public protocol PopUpMenuDelegate{
    func popupmenu(selectItem:Int,menuIdentifier:String)
}

@discardableResult fileprivate func configureConstraints(
    childView:UIView,
    top:CGFloat?,
    left:CGFloat,
    right:CGFloat?,
    bottom:CGFloat?,
    height:CGFloat?,
    width:CGFloat?) -> [String:NSLayoutConstraint]{
    
    var result:[String:NSLayoutConstraint] = [:]
    
    childView.translatesAutoresizingMaskIntoConstraints = false

    var constraint:NSLayoutConstraint?
    if let superView:UIView = childView.superview {
        
        if let t = top {
            constraint = NSLayoutConstraint(item: childView, attribute:NSLayoutAttribute.top,relatedBy: NSLayoutRelation.equal,toItem: superView,attribute: NSLayoutAttribute.top,multiplier: 1,constant: t)
            result["top"] = constraint
            superView.addConstraint(constraint!)
        }
        
        
        constraint = NSLayoutConstraint(item: childView,attribute: NSLayoutAttribute.leading,relatedBy: NSLayoutRelation.equal,toItem: superView,attribute: NSLayoutAttribute.leading,multiplier: 1,constant: left)
        
        result["leading"] = constraint
        
        superView.addConstraint(constraint!)
        
        if let r = right {
            constraint = NSLayoutConstraint(item: childView,attribute: NSLayoutAttribute.trailing,relatedBy: NSLayoutRelation.equal,toItem: superView,attribute: NSLayoutAttribute.trailing,multiplier: 1,constant: r)
            result["trailing"] = constraint
            
            superView.addConstraint(constraint!)
        }
        
        
        if let b = bottom {
            constraint = NSLayoutConstraint(item: childView,attribute: NSLayoutAttribute.bottom,relatedBy: NSLayoutRelation.equal,toItem: superView,attribute: NSLayoutAttribute.bottom,multiplier: 1,constant: b)
            
            result["bottom"] = constraint
            superView.addConstraint(constraint!)
        }
        if let h = height {
            constraint = childView.heightAnchor.constraint(equalToConstant: h)
            constraint!.isActive = true
            result["height"] = constraint
        }
        
        if let w = width {
            constraint = childView.widthAnchor.constraint(equalToConstant: w)
            constraint!.isActive = true
            result["width"] = constraint
        }
        
        superView.updateConstraints()
    }
    return result
    
}
