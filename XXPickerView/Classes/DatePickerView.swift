//
//  DatePickerView.swift
//  XXPickerView
//
//  Created by coolxinxin on 2022/11/10.
//  Copyright (c) 2022 coolxinxin. All rights reserved.
//

import Foundation
import UIKit

public typealias DateResultBlock = (_ selectValue:Date?) -> Void

public class DatePickerView : BasePickerView{
    
    private var resultBlock:DateResultBlock?
    private var selectValue:Date?
    
    @objc func didSelectedValueChanged(sender:UIDatePicker){
        selectValue = sender.date
    }
    
    
    public required init(title:String,date:Date, dateResultBlock resultBlock:@escaping DateResultBlock,height:CGFloat = 256,leftMargin:CGFloat = 38,itemHeight:CGFloat = 40,mineDate:Date? = nil,maxDate:Date? = nil
                     ,selectTextColor:UIColor = UIColor.blue,
                     unSelectTextColor:UIColor = UIColor.gray,
                     selectTextFont:UIFont = UIFont.systemFont(ofSize:16),
                     unselectTextFont:UIFont = UIFont.systemFont(ofSize: 12),
                     local:Locale = Locale.init(identifier: "en")) {
        super.init(frame: CGRect(x: 0, y: ScreenUtils.Frame.size.height, width: ScreenUtils.Frame.size.width, height: height))
        titleLabel.text = title
        self.resultBlock = resultBlock
        let picker = DatePickerViewBuilder.init(frame: CGRect.init(x: leftMargin, y: (((confirmButton.superview?.frame.maxY) ?? 0) + 1), width: ScreenUtils.Frame.size.width - CGFloat(leftMargin*2), height: CGFloat(height-41)),date: date,mineDate: mineDate,maxDate: maxDate,itemHeight: itemHeight,selectTextColor: selectTextColor,unSelectTextColor: unSelectTextColor,selectTextFont: selectTextFont,unselectTextFont: unselectTextFont,local: local,callback: {[weak self](result) in
            self?.selectValue = result
        })
        self.addSubview(picker)
    }
    
    func setTitleView(height:Int,color:UIColor)->DatePickerView{
        toolView.frame = CGRect.init(x: 0, y: 0, width: Int(self.bounds.size.width), height: height)
        toolView.backgroundColor = color
        return self
    }
    
    func setDivideLineColor(color:UIColor)->DatePickerView{
        divideLine.backgroundColor = color
        return self
    }
    
    func setConfirmClickCallback(callback:@escaping ()->Void)->DatePickerView{
        self.confirCallback = callback
        return self
    }
    
    func setCancelClickCallback(callback:@escaping ()->Void)->DatePickerView{
        self.cancelCallback = callback
        return self
    }
    
    func setConfirmStyle(text:String,font:UIFont,textColor:UIColor)->DatePickerView{
        confirmButton.setTitle(text, for: .normal)
        confirmButton.setTitleColor(textColor, for: .normal)
        confirmButton.titleLabel?.font = font
        return self
    }
    
    func setCancelStyle(text:String,font:UIFont,textColor:UIColor)->DatePickerView{
        cancelButton.setTitle(text, for: .normal)
        cancelButton.setTitleColor(textColor, for: .normal)
        cancelButton.titleLabel?.font = font
        return self
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func confirmResult() {
        self.resultBlock?(selectValue)
    }
}

public class DatePickerViewBuilder : UIPickerView, UIPickerViewDelegate,UIPickerViewDataSource {
    private var rowAndComponentCallBack:DateResultBlock?//选择内容回调
    private lazy var year = Array<Int>()
    private lazy var month = Array<Int>()
    private lazy var day = Array<Int>()
    private lazy var selectYearIndex = 0
    private lazy var selectMonthIndex = 0
    private lazy var selectDayIndex = 0
    private lazy var selectTextColor = UIColor.blue
    private lazy var unSelectTextColor = UIColor.black
    private lazy var selectTextFont = UIFont.systemFont(ofSize: 16)
    private lazy var unSelectTextFont = UIFont.systemFont(ofSize: 12)
    private var local = Locale.init(identifier: "en")
    private var itemHeight :CGFloat = 40
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func yearToInt(_ date:Date) ->Int{
        let format = DateFormatter()
        format.locale = local
        format.dateFormat = "yyyy"
        return Int(format.string(from: date)) ?? 2022
    }
    
    func monthToInt(_ date:Date) ->Int{
        let format = DateFormatter()
        format.locale = local
        format.dateFormat = "MM"
        return Int(format.string(from: date)) ?? 1
    }
    
    func dayToInt(_ date:Date) ->Int{
        let format = DateFormatter()
        format.locale = local
        format.dateFormat = "dd"
        return Int(format.string(from: date)) ?? 1
    }
    
    private func calculationDate(mineDate:Date?,maxDate:Date?){
        let maxYear = yearToInt(maxDate ?? Date())
        var mineYear:Int
        if(mineDate == nil){
            mineYear = 1900
        }else{
            mineYear = yearToInt(mineDate!)
        }
        for i in mineYear...maxYear{
            year.append(i)
        }
        for i in 1...12{
            month.append(i)
        }
        for i in 1...31{
            day.append(i)
        }
    }
    
    convenience init(frame:CGRect,date:Date,
                     mineDate:Date?,maxDate:Date?,
                     itemHeight:CGFloat = 40,
                     selectTextColor:UIColor,
                     unSelectTextColor:UIColor,
                     selectTextFont:UIFont,
                     unselectTextFont:UIFont,
                     local:Locale,
                     callback:@escaping DateResultBlock) {
        self.init(frame: frame)
        calculationDate(mineDate:mineDate,maxDate: maxDate)
        self.backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        self.rowAndComponentCallBack = callback
        self.local = local
        self.itemHeight = itemHeight
        self.selectTextColor = selectTextColor
        self.unSelectTextColor = unSelectTextColor
        self.selectTextFont = selectTextFont
        self.unSelectTextFont = unselectTextFont
        self.rowAndComponentCallBack?(date)
        selectYearIndex = year.firstIndex(of: yearToInt(date)) ?? 0
        selectMonthIndex = month.firstIndex(of: monthToInt(date)) ?? 0
        selectDayIndex = day.firstIndex(of: dayToInt(date)) ?? 0
        self.selectRow(selectYearIndex, inComponent: 0, animated: true)
        self.selectRow(selectMonthIndex, inComponent: 1, animated: true)
        self.selectRow(selectDayIndex, inComponent: 2, animated: true)
        self.reloadAllComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func howManyDays(inThisYear year: Int, withMonth month: Int) -> Int {
        if (month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12) {
            return 31
        }
        if (month == 4) || (month == 6) || (month == 9) || (month == 11) {
            return 30
        }
        if (year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3) {
            return 28
        }
        if year % 400 == 0 {
            return 29
        }
        if year % 100 == 0 {
            return 28
        }
        return 29
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0){
            return year.count
        }else if(component == 1){
            return month.count
        }else{
            let year = year[selectDayIndex]
            let month = month[selectMonthIndex]
            return howManyDays(inThisYear: year, withMonth: month)
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
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
                if selectYearIndex == row {
                    pickerLabel?.font = selectTextFont
                    pickerLabel?.textColor = selectTextColor
                }else{
                    pickerLabel?.font = unSelectTextFont
                    pickerLabel?.textColor = unSelectTextColor
                }
                pickerLabel?.text = "\(year[row])"
            }else if(component ==  1){
                if selectMonthIndex == row {
                    pickerLabel?.font = selectTextFont
                    pickerLabel?.textColor = selectTextColor
                }else{
                    pickerLabel?.font = unSelectTextFont
                    pickerLabel?.textColor = unSelectTextColor
                }
                if(month[row]<10){
                    pickerLabel?.text = "0\(month[row])"
                }else{
                    pickerLabel?.text = "\(month[row])"
                }
                
            }else{
                if selectDayIndex == row {
                    pickerLabel?.font = selectTextFont
                    pickerLabel?.textColor = selectTextColor
                }else{
                    pickerLabel?.font = unSelectTextFont
                    pickerLabel?.textColor = unSelectTextColor
                }
                if(day[row]<10){
                    pickerLabel?.text = "0\(day[row])"
                }else{
                    pickerLabel?.text = "\(day[row])"
                }
            }
        }
        return pickerLabel ?? UIView()
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(component == 0){
            return "\(year[row])"
        }else if(component == 0){
            return "\(month[row])"
        }else{
            return "\(day[row])"
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return itemHeight
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 0){
            selectYearIndex = row
            selectRow(selectYearIndex, inComponent: 0, animated: true)
            selectRow(selectMonthIndex, inComponent: 1, animated: true)
            let day = howManyDays(inThisYear: year[selectYearIndex], withMonth: month[selectMonthIndex])
            if(selectDayIndex>day){
                selectDayIndex = 0
            }
            selectRow(selectDayIndex, inComponent: 2, animated: true)
            self.reloadComponent(1)
        }else if(component == 1){
            selectMonthIndex = row
            selectRow(selectYearIndex, inComponent: 0, animated: true)
            selectRow(selectMonthIndex, inComponent: 1, animated: true)
            let day = howManyDays(inThisYear: year[selectYearIndex], withMonth: month[selectMonthIndex])-1
            if(selectDayIndex>day){
                selectDayIndex = 0
            }
            selectRow(selectDayIndex, inComponent: 2, animated: true)
            self.reloadComponent(2)
        }else{
            selectDayIndex = row
            selectRow(selectYearIndex, inComponent: 0, animated: true)
            selectRow(selectMonthIndex, inComponent: 1, animated: true)
            selectRow(selectDayIndex, inComponent: 2, animated: true)
        }
        self.reloadAllComponents()
        let date = "\(year[selectYearIndex])-\(month[selectMonthIndex])-\(day[selectDayIndex])"
        rowAndComponentCallBack?(stringToDate(date))
    }
    
    func stringToDate(_ str:String) ->Date?{
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        format.locale = local
        return format.date(from: str)
    }
    
}
