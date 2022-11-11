//
//  ScreenUtils.swift
//  XXPickerView
//
//  Created by coolxinxin on 2022/11/10.
//  Copyright (c) 2022 coolxinxin. All rights reserved.
//

import Foundation
import UIKit

public typealias SingleResultCallback<T : PortocolSingleData> = (_ result:T?) -> ()


public class SinglePickerView<T :PortocolSingleData> : BasePickerView {
    
    private var callback:SingleResultCallback<T>?
    private var result : T?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
   
    public required init(title:String,dataSource:Array<T>,selectCode:String,
                     callback:@escaping SingleResultCallback<T>,
                     height:CGFloat = 256,leftMargin:CGFloat = 38,itemHeight:CGFloat = 40,
                     selectTextColor:UIColor = UIColor.blue,
                     unSelectTextColor:UIColor = UIColor.gray,
                     selectTextFont:UIFont = UIFont.systemFont(ofSize:16),
                     unselectTextFont:UIFont = UIFont.systemFont(ofSize: 12)) {
        super.init(frame: CGRect(x: 0, y: ScreenUtils.Frame.size.height, width: ScreenUtils.Frame.size.width, height: height))
        titleLabel.text = title
        self.callback = callback
        if (dataSource.count != 0) {
            let selectIndex = dataSource.lastIndex(where: {(element)->Bool in element.getCode() == selectCode}) ?? 0
            let picker = SinglePickerViewBuilder<T>.init(frame: CGRect.init(x: leftMargin, y: (((confirmButton.superview?.frame.maxY) ?? 0) + 1), width: ScreenUtils.Frame.size.width - CGFloat(leftMargin*2), height: CGFloat(height-41)),dataSource:dataSource,selectIndex: selectIndex,itemHeight: itemHeight,selectTextColor: selectTextColor, unSelectTextColor: unSelectTextColor, selectTextFont: selectTextFont, unselectTextFont: unselectTextFont,callback: {[weak self](result) in
                self?.result = result
            })
            self.addSubview(picker)
        }
    }
    
    func setTitleView(height:Int,color:UIColor)->SinglePickerView{
        toolView.frame = CGRect.init(x: 0, y: 0, width: Int(self.bounds.size.width), height: height)
        toolView.backgroundColor = color
        return self
    }
    
    func setDivideLineColor(color:UIColor)->SinglePickerView{
        divideLine.backgroundColor = color
        return self
    }
    
    func setConfirmStyle(text:String,font:UIFont,textColor:UIColor)->SinglePickerView{
        confirmButton.setTitle(text, for: .normal)
        confirmButton.setTitleColor(textColor, for: .normal)
        confirmButton.titleLabel?.font = font
        return self
    }
    
    func setCancelStyle(text:String,font:UIFont,textColor:UIColor)->SinglePickerView{
        cancelButton.setTitle(text, for: .normal)
        cancelButton.setTitleColor(textColor, for: .normal)
        cancelButton.titleLabel?.font = font
        return self
    }
    
    func setConfirmClickCallback(callback:@escaping ()->Void)->SinglePickerView{
        self.confirCallback = callback
        return self
    }
    
    func setCancelClickCallback(callback:@escaping ()->Void)->SinglePickerView{
        self.cancelCallback = callback
        return self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func confirmResult() {
        self.callback?(result)
    }

}
 
class SinglePickerViewBuilder<T : PortocolSingleData> : UIPickerView, UIPickerViewDelegate,UIPickerViewDataSource {
    private var rowAndComponentCallBack:SingleResultCallback<T>?//选择内容回调
    private lazy var currentSelectRow = 0
    private lazy var data = Array<T>()
    private lazy var selectTextColor = UIColor.blue
    private lazy var unSelectTextColor = UIColor.black
    private lazy var selectTextFont = UIFont.systemFont(ofSize: 16)
    private lazy var unSelectTextFont = UIFont.systemFont(ofSize: 12)
    private lazy var itemHeight : CGFloat = 40
 
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame:CGRect,dataSource:Array<T>,selectIndex:Int,
                     itemHeight:CGFloat,
                     selectTextColor:UIColor,
                     unSelectTextColor:UIColor,
                     selectTextFont:UIFont,
                     unselectTextFont:UIFont,
                     callback:@escaping SingleResultCallback<T>) {
        self.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.currentSelectRow = selectIndex
        self.data = dataSource
        self.itemHeight = itemHeight
        self.selectTextColor = selectTextColor
        self.unSelectTextColor = unSelectTextColor
        self.selectTextFont = selectTextFont
        self.unSelectTextFont = unselectTextFont
        self.delegate = self
        self.dataSource = self
        self.rowAndComponentCallBack = callback
        self.rowAndComponentCallBack?(dataSource[selectIndex])
        self.selectRow(selectIndex, inComponent: 0, animated: true)
        self.reloadAllComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        //设置分割线
        for view in pickerView.subviews {
            if view.frame.size.height <= 1 {
                view.isHidden = false
                view.frame = CGRect(x: 0, y: view.frame.origin.y, width: ScreenUtils.Width, height: 1)
                view.backgroundColor = UIColor.gray
            }
        }
        
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.textAlignment = .center
            if currentSelectRow == row {
                pickerLabel?.font = selectTextFont
                pickerLabel?.textColor = selectTextColor
            }else{
                pickerLabel?.font = unSelectTextFont
                pickerLabel?.textColor = unSelectTextColor
            }
            
        }
        pickerLabel?.text = data[row].getName()
        
        return pickerLabel ?? UIView()
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row].getName()
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return itemHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentSelectRow = row
        rowAndComponentCallBack?(data[currentSelectRow])
        self.reloadAllComponents()
    }
}

