//
//  CWAlertView.swift
//  CWStreaks
//
//  Created by Mensah Shadrach on 2/16/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

import UIKit

class CWAlertView:UIView
{
    var mainView:UIView!
    var viewLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let x:CGFloat = (UIScreen.main.bounds.size.width / 2) - 100
        let y:CGFloat = -100
        self.mainView = UIView(frame: CGRect(x:x, y: y, width: 200, height: 50))
        let color = UIColor(red: 39/255, green: 189/255, blue: 1, alpha: 0.95)
        self.viewLabel.backgroundColor = color
        self.viewLabel.textColor = UIColor.white
        self.viewLabel = UILabel(frame: self.mainView.frame)
        let font = UIFont(name: "Noteworthy-Bold", size: 18)
        self.viewLabel.font = font
        self.mainView.addSubview(self.viewLabel)
    }
    
    
    
    class func createAlertWithMessage(message:String?)->CWAlertView{
        let alert = CWAlertView(frame: CGRect())
        alert.viewLabel.text = message
        return alert
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func present(animated:Bool, onComplete:@escaping ()->()?, controller:UIViewController){
        if animated{
            controller.view.addSubview(self)
            UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.4, options: [.curveEaseInOut], animations: {
                self.frame.origin.y += 350
            }, completion: { (finished) in
                onComplete()
            })
        }

    }
    
    func showAlertView(animated:Bool, onComplete:@escaping ()->()?, controller:UIViewController){}
}




extension UIViewController{
    func presentAlert(alert:CWAlertView, animated:Bool, onComplete:()->()?){
        if animated{
            self.view.addSubview(alert)
            UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.4, options: [.curveEaseInOut], animations: { 
                alert.frame.origin.y += 350
            }, completion: { (finished) in
                //
            })
        }
    }
}
