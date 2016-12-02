//
//  ViewController.swift
//  SwiftSnake
//
//  Created by Blaž Jurišić on 29/11/16.
//  Copyright © 2016 Blaž Jurišić. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Outlets ha ha
    
    
    
    //MARK: - Model
    var snakeBody = [SnakeCube]()
    
    
    ////MARK: - Constants
    //Snake constants
    let snakeSpeed = 0.3
    
    //Cube constants
    let durationOfCubeMoving: Double = 0.2
    let cubeDimension: CGFloat = 15.0
    let cookie = UIView()
    
    //Cookie constants
    let cookieDimension: CGFloat = 15.0
    let cookieSpawnSpeed = 10.0
    var spawnCookieFlag = false
    
    //ScoreBoard
    let pointCounterFrame = CGRect(x: 50, y: 50, width: 100, height: 100)
    var pointCounter: UILabel = UILabel()
    
    //SandBox
    let sandBoxInsets: CGFloat = 20.0
    let sandBoxHeight: CGFloat = UIScreen.main.bounds.height * 0.7
    let sandBoxTopInset: CGFloat = 20.0
    var sandBox = UIView()
    
    //holds state for timer
    var directionOfMoving: String = "stop"
    
    
    //MARK: - Dependencies
    let screenSize = UIScreen.main.bounds
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //sandBox
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        sandBox.frame = frame
        sandBox.backgroundColor = UIColor.black
        view.addSubview(sandBox)
        
        //ScoreBoard
        pointCounter.frame = pointCounterFrame
        pointCounter.textColor = UIColor.white
        pointCounter.textAlignment = .center
        //pointCounter.font = UIFont(name: , size: 40)
        pointCounter.adjustsFontSizeToFitWidth = true
        pointCounter.text = "0"
        sandBox.addSubview(pointCounter)
        
        //initial cubes
        addNewCube(indexPath: 0)
        addNewCube(indexPath: 1)
        
        //initial cookie
        placeCookie()
        
        //infiniteLoop that triggers move
        _ = Timer.scheduledTimer(timeInterval: snakeSpeed, target: self, selector: #selector(self.behavior), userInfo: nil, repeats: true)
        
        //Swipe gesture recognizers
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    //MARK: - Actions
    //controller
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                self.directionOfMoving = "➡️"
            case UISwipeGestureRecognizerDirection.down:
                self.directionOfMoving = "⬇️"
            case UISwipeGestureRecognizerDirection.left:
                self.directionOfMoving = "⬅️"
            case UISwipeGestureRecognizerDirection.up:
                self.directionOfMoving = "⬆️"
            default:
                break
            }
        }
    }
    
    //MARK: - ENGINE
    func behavior() {
        
        checkIfSnakeAteHerself()
        checkIfCollisionOccured()
        manageMovement()
    }
    
    func checkIfSnakeAteHerself () {
        
        //snake eats herself
        if snakeBody.count > 2 {
            
            for i in 1..<snakeBody.count {
                
                if snakeBody.first!.center == snakeBody[i].center {
                    
                    let numberOfIterations = snakeBody.count - i
                    for  _ in 0..<numberOfIterations {
                        
                        snakeBody.last?.removeFromSuperview()
                        _ = snakeBody.popLast()
                    }
                    break
                }
            }
        }
    }
    
    func checkIfCollisionOccured () {
        
        //colision between snake's head and cookie
        let A = (snakeBody.first!.center.x - cookie.center.x) * (snakeBody.first!.center.x - cookie.center.x)
        let B = (snakeBody.first!.center.y - cookie.center.y) * (snakeBody.first!.center.y - cookie.center.y)
        if sqrt(A+B) <= ((cubeDimension / 2) + (cookieDimension / 2)) {
            
            addNewCube(indexPath: CGFloat(snakeBody.count))
            placeCookie()
            
        }
    }
    
    //movement
    func manageMovement () {
        
        var previousPositionOfFirst = CGPoint()
        
        switch self.directionOfMoving {
            
        case "⬆️":
            
            previousPositionOfFirst = (self.snakeBody.first!.center)
            if self.snakeBody.first!.center.y <= 0 {
                
                self.snakeBody.first!.center.y = self.screenSize.height
                
            }
            else {
                
                UIView.animate(withDuration: durationOfCubeMoving, animations: {
                    
                    self.snakeBody.first!.center.y = self.snakeBody.first!.center.y - self.cubeDimension
                })
            }
            updatePositions(previousPositionOfFirst: previousPositionOfFirst)
            
        case "➡️":
            
            previousPositionOfFirst = (self.snakeBody.first!.center)
            if self.snakeBody.first!.center.x >= screenSize.width {
                
                self.snakeBody.first!.center.x = 0
            }
            else {
                
                UIView.animate(withDuration: durationOfCubeMoving, animations: {
                    
                    self.snakeBody.first!.center.x = self.snakeBody.first!.center.x + self.cubeDimension
                })
            }
            
            updatePositions(previousPositionOfFirst: previousPositionOfFirst)
            
        case "⬇️":
            
            previousPositionOfFirst = (self.snakeBody.first!.center)
            
            if self.snakeBody.first!.center.y >= screenSize.height {
                
                self.snakeBody.first!.center.y = 0
                
            }
            else {
                
                UIView.animate(withDuration: durationOfCubeMoving, animations: {
                    
                    self.snakeBody.first!.center.y = self.snakeBody.first!.center.y + self.cubeDimension
                })
            }
            
            updatePositions(previousPositionOfFirst: previousPositionOfFirst)
            
        case "⬅️":
            
            previousPositionOfFirst = (self.snakeBody.first!.center)
            
            if self.snakeBody.first!.center.x <= 0 {
                
                self.snakeBody.first!.center.x = screenSize.width
            }
            else {
                
                UIView.animate(withDuration: durationOfCubeMoving, animations: {
                    
                    self.snakeBody.first!.center.x = self.snakeBody.first!.center.x - self.cubeDimension
                })
            }
            
            updatePositions(previousPositionOfFirst: previousPositionOfFirst)
            
        case "stop":
            
            break
            
        default:
            print("Controller broke down")
        }
    }
    
    func updatePositions(previousPositionOfFirst:CGPoint) {
        
        var temporarySavedPosition = CGPoint()
        for index in 1...snakeBody.count-1 {
            
            if index == 1 {
                
                temporarySavedPosition = snakeBody[index].center
                snakeBody[index].center = previousPositionOfFirst
            }
            else {
                
                let swapVariable = snakeBody[index].center
                snakeBody[index].center = temporarySavedPosition
                temporarySavedPosition = swapVariable
            }
        }
        //Update of counter
        self.pointCounter.text? = String(snakeBody.count - 2)
    }
    
    //MARK: - object spawning methods
    func placeCookie() {
        
        let xCoordinate: CGFloat = CGFloat(arc4random_uniform(UInt32(Int(screenSize.width))))
        let yCoordinate: CGFloat = CGFloat(arc4random_uniform(UInt32(Int(screenSize.height))))
        let frame = CGRect(x: xCoordinate, y: yCoordinate, width: cookieDimension, height: cookieDimension)
        self.cookie.frame = frame
        cookie.backgroundColor = UIColor.yellow
        cookie.layer.cornerRadius = cookieDimension / 2
        view.addSubview(cookie)
    }
    
    func addNewCube(indexPath:CGFloat) {
        
        let newFrame  = CGRect(x: (screenSize.width / 2) + indexPath * cubeDimension, y: screenSize.height / 2, width: cubeDimension, height: cubeDimension)
        let newSnakeCube = SnakeCube(frame: newFrame)
        //newSnakeCube.center = CGPoint(x: self.screenSize.width / 2 + CGFloat(indexPath) * self.cubeDimension, y: self.screenSize.height / 2)
        newSnakeCube.backgroundColor = UIColor.white
        //newSnakeCube.clipsToBounds = true
        self.sandBox.addSubview(newSnakeCube)
        snakeBody.append(newSnakeCube)
        spawnCookieFlag = true
    }
}


