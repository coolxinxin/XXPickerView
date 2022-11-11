//
//  BasePickerView.swift
//  XXPickerView
//
//  Created by coolxinxin on 2022/11/10.
//  Copyright (c) 2022 coolxinxin. All rights reserved.
//

import Foundation
import UIKit


func createText(text:String,font:UIFont,textColor:UIColor = UIColor.black) -> UILabel{
    let label = UILabel()
    label.text = text
    label.font = font
    label.textColor = textColor
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byCharWrapping
    return label
}

public class BasePickerView : UIView {
    var dismissCallBack = {}
    
    lazy var titleLabel = createText(text: "", font: UIFont.systemFont(ofSize: CGFloat(15)))
    lazy var confirmButton = UIButton()
    lazy var cancelButton = UIButton()
    private lazy var overlayView = UIControl()
    lazy var divideLine = UIView()
    private var keyWindow : UIWindow?
    lazy var toolView = UIView()
    var confirCallback:()->Void = {}
    var cancelCallback:()->Void = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white;
        
        if (keyWindow == nil) {
            self.keyWindow = UIApplication.shared.keyWindow
        }
        
        overlayView.frame = UIScreen.main.bounds
        overlayView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        overlayView.addTarget(self, action: #selector(hide), for: .touchUpInside)
        overlayView.alpha = 0
        
        toolView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Int(self.bounds.size.width), height: 45))
        toolView.backgroundColor = .white
        addSubview(toolView)
    
        cancelButton = UIButton.init(frame: CGRect.init(x: 18, y: 0, width: ScreenUtils.Width/4, height: toolView.bounds.size.height))
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.gray, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelButton.contentHorizontalAlignment = .left
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        toolView.addSubview(cancelButton)
        
        confirmButton.frame =  CGRect.init(x: (toolView.bounds.size.width - ScreenUtils.Width/4 - 18), y: 0, width: ScreenUtils.Width/4, height: toolView.bounds.size.height)
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.setTitleColor(UIColor.blue, for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        confirmButton.contentHorizontalAlignment = .right
        confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        toolView.addSubview(confirmButton)
        
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.frame = CGRect(x: CGFloat(CGFloat(Int(self.bounds.size.width)/2) - ScreenUtils.Width/4), y: 0, width: ScreenUtils.Width/2, height: toolView.bounds.size.height)
        toolView.addSubview(titleLabel)
        
        divideLine = UIView.init(frame: CGRect(x: 0, y: (confirmButton.superview?.frame.maxY) ?? 0, width: toolView.bounds.size.width, height: 1))
        divideLine.backgroundColor = UIColor.gray
        toolView.addSubview(divideLine)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show(){
        keyWindow?.addSubview(overlayView)
        keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.25, animations: {
            self.overlayView.alpha = 1.0
            var frame = self.frame
            frame.origin.y = UIScreen.main.bounds.size.height - self.bounds.size.height
            self.frame = frame
        }) { (isFinished) in
        }
    }
    
    @objc func hide() {
        self.dismissCallBack()
        UIView.animate(withDuration: 0.25, animations: {
            self.overlayView.alpha = 0
            var frame = self.frame
            frame.origin.y = UIScreen.main.bounds.size.height
            self.frame = frame
        }) { (isFinished) in
            self.overlayView.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
    
    @objc func cancelAction() {
        cancelCallback()
        hide()
    }
    
    @objc func confirmAction() {
        confirmResult()
        confirCallback()
        hide()
    }
    
    func confirmResult(){
        
    }
    
}
