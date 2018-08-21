//
//  TutsVC.swift
//  CWShedule+
//
//  Created by Mensah Shadrach on 1/1/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

import UIKit

class TutsVC: UIViewController,UIPageViewControllerDataSource {

    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var skipbutton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    var pageController:UIPageViewController!
    var pageTitles:[String]!
    var pageImages:[String]!
    override func viewDidLoad() {
        super.viewDidLoad()
        pageTitles = ["The Game","Game Session", "Game Mode", "Challenge Series","LeaderBoard","Start Streaking"]
        pageImages = ["Streaker is a simple number guessing game. The game presents with four randomly chosen numbers out of which one is selected by the system and the player is  to guess the mysteriously selected number.After a guess the process repeats until a player runs out of time or plays. A correct guess earns a point and a misguess earns a no score and successive correct guesses earns you a streak. ","Streaker is made up of two sessions of play: the regular session and classic session and  two modes of play: an offline individual play mode and an online multiplayer challenge mode. Your goal in either modes of play  is to make as many correct guesses (score) and correct guesses a row (streaks)", "In the regular session you have 82 tries to make as many correct guesses and streaks that you can master. In the classic mode, you are on a timer to make as many correct guesses and streaks under 24 seconds.", "In an online challenge series, you challenge an opponent  in any game mode of your choosing and play a best of seven games. The first player to win four games wins the challenge When there is a tie in a single game, opponents go ahead to play overtime. When there is a tie in a single game, opponents go ahead to play overtime. In the regular mode, overtime has a limit of twenty two rounds. In the classic mode overtime lasts for 10 seconds.", "Your scores are submitted on the leaderboard to see how you stack up against competition. See how well you are doing in the classic, regular and all time challenges,compared to other players on the leaderboard in the world.","Enjoy the game. May the odds always be in your favor"]
        
        pageController = storyboard?.instantiateViewController(withIdentifier: "PageVC") as! UIPageViewController
        pageController.dataSource = self
        let startingVC = viewController(at: 0) as! PageContentVC
        let viewcontrollers = [startingVC]
        pageController.setViewControllers(viewcontrollers, direction: .forward, animated: false, completion: nil)
        pageController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 50)
        addChildViewController(pageController)
        view.addSubview(pageController.view)
        pageController.didMove(toParentViewController: self)
        
        view.insertSubview(imageview, belowSubview: pageController.view)
        view.bringSubview(toFront: pageController.view)
    }
    
    
    func viewController(at:Int)->UIViewController?{
        if pageTitles.count == 0 || at >= pageTitles.count{
            return nil
        }
        let pageContentVC = storyboard?.instantiateViewController(withIdentifier: "ContentVC") as! PageContentVC
        pageContentVC.imageFile = pageImages[at]
        pageContentVC.titleText = pageTitles[at]
        pageContentVC.pageIndex = UInt(at)
        
        return pageContentVC
    }

    

 
    @IBAction func skipButtonPressed(_ sender: Any) {
        if skip.boolValue{
            dismiss(animated: true, completion: nil)
        }else{
            let nav = storyboard?.instantiateViewController(withIdentifier:"startUpNavC") as? UINavigationController
            present(nav!, animated: true, completion: {})

        }
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        let startingViewController = self.viewController(at: 0) as! PageContentVC
        let viewControllers = [startingViewController]
        self.pageController.setViewControllers(viewControllers, direction: .forward, animated: false, completion: { _ in })
    }
    

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentVC).pageIndex
        if (Int(index) == NSNotFound) {
            return nil
        }
        index += 1
        if Int(index) == self.pageTitles.count {
            return nil
        }
        return self.viewController(at: Int(index))
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentVC).pageIndex
        if Int(index) == 0 || Int(index) == NSNotFound {
            return nil
        }
        index -= 1

        return self.viewController(at: Int(index))
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageTitles.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }


}

extension UIView{
    
    func rotate360Degrees(_ duration:CFTimeInterval = 1, completionDelegate:AnyObject? = nil){
        let rotationAnimation = CABasicAnimation(keyPath: KEY_PATH_CA_ANIM_ROTATE)
        rotationAnimation.fromValue = 0.00
        rotationAnimation.toValue = CGFloat(Double.pi * 2)
        rotationAnimation.duration = duration
        if let delegate:AnyObject = completionDelegate{
            rotationAnimation.delegate = delegate as? CAAnimationDelegate
        }
        
        self.layer.add(rotationAnimation, forKey: nil)
    }
}

class Timer {
    var timer = Foundation.Timer()
    let duration: Double
    let completionHandler: () -> ()
    fileprivate var elapsedTime: Double = 0.0
    
    init(duration: Double, completionHandler: @escaping () -> ()) {
        self.duration = duration
        self.completionHandler = completionHandler
    }
    
    func start() {
        self.timer = Foundation.Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Timer.tick), userInfo: nil, repeats: true)
    }
    
    func stop() {
        self.timer.invalidate()
    }
    
    @objc fileprivate func tick() {
        self.elapsedTime += 1.0
        if self.elapsedTime == self.duration {
            self.stop()
            self.completionHandler()
            self.elapsedTime = 0.0
        }
    }
    
    deinit {
        self.stop()
    }
    
    
}

func blur(thisView view:UIView){
    let blureffect = UIBlurEffect(style: .light)
    let blurView = UIVisualEffectView(effect: blureffect)
    blurView.frame = view.bounds
    view.addSubview(blurView)
}

let KEY_PATH_CA_ANIM_ROTATE = "transform.rotation"
