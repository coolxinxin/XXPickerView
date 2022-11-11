//
//  AddressPickerView.swift
//  XXPickerView
//
//  Created by coolxinxin on 2022/11/10.
//  Copyright (c) 2022 coolxinxin. All rights reserved.
//

import Foundation
import UIKit

//⚠️警告 D和T必须为同一类型，否则直接崩！！！
public typealias AddressResultCallback<D,T:ProtocolAddressData<D>> = (_ province:T?,_ city:D?) -> ()

public class AddressPickerView<D,T:ProtocolAddressData<D>> : BasePickerView {
    
    var rowAndComponentCallBack:AddressResultCallback<D,T>?
    var province:T?
    var city:D?
    
    public required init(title:String,dataSource:Array<T>,selectProvinceCode:String,
                     selectCityCode:String,
                     callback:@escaping AddressResultCallback<D,T>,
                     height:CGFloat = 256,leftMargin:CGFloat = 38,itemHeight:CGFloat = 40,
                     selectTextColor:UIColor = UIColor.blue,
                     unSelectTextColor:UIColor = UIColor.gray,
                     selectTextFont:UIFont = UIFont.systemFont(ofSize:16),
                     unselectTextFont:UIFont = UIFont.systemFont(ofSize: 12)) {
        super.init(frame: CGRect(x: 0, y: ScreenUtils.Frame.size.height, width: ScreenUtils.Frame.size.width, height: height))
        titleLabel.text = title
        self.rowAndComponentCallBack = callback
        if (dataSource.count != 0) {
            let selectProvinceIndex = dataSource.lastIndex(where: {(element)->Bool in element.getCode() == selectProvinceCode}) ?? 0
            let province = dataSource[selectProvinceIndex].getChildList() as! Array<T>
            let selectCityIndex = province.lastIndex(where: {(element)->Bool in element.getCode() == selectCityCode}) ?? 0
            let picker =  AddressPickerViewBuilder<D,T>.init(frame: CGRect.init(x: leftMargin, y: (((confirmButton.superview?.frame.maxY) ?? 0) + 1), width: ScreenUtils.Frame.size.width - CGFloat(leftMargin*2), height: CGFloat(height-41)), dataSource: dataSource, selectProvinceIndex: selectProvinceIndex, selectCityIndex:selectCityIndex,itemHeight: itemHeight,selectTextColor: selectTextColor, unSelectTextColor: unSelectTextColor, selectTextFont: selectTextFont, unselectTextFont: unselectTextFont, callback: {[weak self](province,city) in
                self?.province = province
                self?.city = city
            })
            self.addSubview(picker)
        }
    }
    
    func setTitleView(height:Int,color:UIColor)->AddressPickerView{
        toolView.frame = CGRect.init(x: 0, y: 0, width: Int(self.bounds.size.width), height: height)
        toolView.backgroundColor = color
        return self
    }
    
    func setDivideLineColor(color:UIColor)->AddressPickerView{
        divideLine.backgroundColor = color
        return self
    }
    
    func setConfirmStyle(text:String,font:UIFont,textColor:UIColor)->AddressPickerView{
        confirmButton.setTitle(text, for: .normal)
        confirmButton.setTitleColor(textColor, for: .normal)
        confirmButton.titleLabel?.font = font
        return self
    }
    
    func setCancelStyle(text:String,font:UIFont,textColor:UIColor)->AddressPickerView{
        cancelButton.setTitle(text, for: .normal)
        cancelButton.setTitleColor(textColor, for: .normal)
        cancelButton.titleLabel?.font = font
        return self
    }
    
    func setConfirmClickCallback(callback:@escaping ()->Void)->AddressPickerView{
        self.confirCallback = callback
        return self
    }
    
    func setCancelClickCallback(callback:@escaping ()->Void)->AddressPickerView{
        self.cancelCallback = callback
        return self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func confirmResult() {
        self.rowAndComponentCallBack?(province,city)
    }
    
}

class AddressPickerViewBuilder<D,T : ProtocolAddressData<D>> : UIPickerView, UIPickerViewDelegate,UIPickerViewDataSource {
    private var rowAndComponentCallBack:AddressResultCallback<D,T>?//选择内容回调
    private lazy var currentSelectProvince = 0
    private lazy var currentSelectCity = 0
    private lazy var provinceData = Array<T>()
    private lazy var cityData = Array<D>()
    private lazy var selectTextColor = UIColor.blue
    private lazy var unSelectTextColor = UIColor.black
    private lazy var selectTextFont = UIFont.systemFont(ofSize: 16)
    private lazy var unSelectTextFont = UIFont.systemFont(ofSize: 12)
    private lazy var itemHeight : CGFloat = 40
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame:CGRect,dataSource:Array<T>,selectProvinceIndex:Int,
                     selectCityIndex:Int,
                     itemHeight:CGFloat,
                     selectTextColor:UIColor,
                     unSelectTextColor:UIColor,
                     selectTextFont:UIFont,
                     unselectTextFont:UIFont,
                     callback:@escaping AddressResultCallback<D,T>) {
        self.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.currentSelectProvince = selectProvinceIndex
        self.currentSelectCity = selectCityIndex
        self.provinceData = dataSource
        self.itemHeight = itemHeight
        self.selectTextColor = selectTextColor
        self.unSelectTextColor = unSelectTextColor
        self.selectTextFont = selectTextFont
        self.unSelectTextFont = unselectTextFont
        self.delegate = self
        self.dataSource = self
        self.rowAndComponentCallBack = callback
        self.cityData = dataSource[selectProvinceIndex].getChildList() ?? Array<D>()
        let province = dataSource[selectProvinceIndex]
        let city = province.getChildList()?[0]
        self.rowAndComponentCallBack?(province,city)
        self.selectRow(currentSelectProvince, inComponent: 0, animated: true)
        self.selectRow(currentSelectCity, inComponent: 1, animated: true)
        self.reloadAllComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0){
            return provinceData.count
        }else{
            return cityData.count
        }
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
            if(component ==  0){
                if currentSelectProvince == row {
                    pickerLabel?.font = selectTextFont
                    pickerLabel?.textColor = selectTextColor
                }else{
                    pickerLabel?.font = unSelectTextFont
                    pickerLabel?.textColor = unSelectTextColor
                }
                pickerLabel?.text = provinceData[row].getName()
            }else{
                if currentSelectCity == row {
                    pickerLabel?.font = selectTextFont
                    pickerLabel?.textColor = selectTextColor
                }else{
                    pickerLabel?.font = unSelectTextFont
                    pickerLabel?.textColor = unSelectTextColor
                }
                pickerLabel?.text = (cityData[row] as! T).getName()
            }
        }
        return pickerLabel ?? UIView()
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(component == 0){
            return provinceData[row].getName()
        }else{
            return (cityData[row] as! T).getName()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return itemHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 0){
            currentSelectProvince = row
            currentSelectCity = 0
            cityData = provinceData[row].getChildList() ?? Array<D>()
            self.reloadComponent(1)
            selectRow(currentSelectProvince, inComponent: 0, animated: true)
            selectRow(currentSelectCity, inComponent: 1, animated: true)
        }else {
            currentSelectCity = row
            selectRow(currentSelectCity, inComponent: 1, animated: true)
        }
        self.reloadAllComponents()
        rowAndComponentCallBack?(provinceData[currentSelectProvince],
                                 cityData[currentSelectCity])
    }
}
