//
//  Wheel.swift
//  SpinTheWheelGame
//
//  Created by Shane Bersiek on 8/2/21.
//

import Foundation
import UIKit
import SpriteKit
import SwiftUI
import Combine

class Wheel : UIView {
    let angle: CGFloat = 380
    var count = 0
    var rewards = [Reward]()
    
    
    
    override func draw(_ rect: CGRect) {
        addBackGroundToWheel(rewards: rewards, rect: rect, color: .blue)
        showWheelTxt(rewards: rewards, rect: rect, color: .clear)
    }
    
    //MARK: Functions
    func showWheelTxt(rewards: [Reward], rect: CGRect, color: UIColor) {
        guard rewards.count > 0 else {return}
        
        var increment = (100.0 / Float(rewards.count))
        var start: Float = 0.0
        var end: Float = Float(increment)
        
        for i in rewards {
            print("new start = \(CGFloat(start)), ending = \(CGFloat(end))")
            drawSlice(rect, startPercent: CGFloat(start), endPercent: CGFloat(end), color: .clear, prizeNameTxt: i.displayText!)
            start += Float(increment)
            end += Float(increment)
        }
    }
    
    func addBackGroundToWheel(rewards: [Reward], rect: CGRect, color: UIColor) {
        guard rewards.count > 0 else {return}
        var color:UIColor = wheelDarkererbackground
        var increment = (100.0 / Float(rewards.count))
        var start: Float = 0.0
        var end: Float = Float(increment)
        var count = 0
        
        for i in rewards {
            drawSlice(rect, startPercent: CGFloat(start), endPercent: CGFloat(end), color: color, prizeNameTxt: "")
            if  color ==  wheelDarkererbackground { color = wheelLighterbackground} else {color = wheelDarkererbackground}
            start += Float(increment)
            end += Float(increment)
            count += 1
        }
    }
   
    private func drawSlice(_ rect: CGRect, startPercent: CGFloat, endPercent: CGFloat, color: UIColor, prizeNameTxt: String){
        guard let context = UIGraphicsGetCurrentContext() else { return }
       
        let center = CGPoint(x: rect.origin.x + rect.width / 2, y: rect.origin.y + rect.height / 2)
        let radius = min(rect.width, rect.height) / 2
        let startAngle = startPercent / 100 * CGFloat(Double.pi) * 2 - CGFloat(Double.pi)
        let endAngle = endPercent / 100 * CGFloat(Double.pi) * 2 - CGFloat(Double.pi)
        let path = UIBezierPath()
        path.move(to: center)
        path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.close()
        path.stroke()
        color.setFill()
        path.fill()
        context.drawPath(using: .fillStroke)
        
        let font = UIFont.systemFont(ofSize: 13)
        let textColor = UIColor.white
        
        let midPointAngle = getArcCenter(startAngle: startAngle, endAngle: endAngle)
        let midPointAngleToDegrees = CGFloat(rad2deg(Double(midPointAngle)))
        
        let position = TextPosition(center: center, angle: midPointAngleToDegrees)
        
        drawRotatedText(text: prizeNameTxt, at: center , angle: CGFloat(rad2deg(Double(midPointAngle))), font: font, color: textColor, rect: rect)
        
    }
}

func getCirclePoints(centerPoint point: CGPoint, radius: CGFloat, numOfPoints: Int)->[CGPoint] {
    let result: [CGPoint] = stride(from: 0.0, to: 360.0, by: Double(360 / numOfPoints)).map {
        let bearing = CGFloat($0) * .pi / 180
        let x = point.x + radius * cos(bearing)
        let y = point.y + radius * sin(bearing)
        return CGPoint(x: x, y: y)
    }
    return result
}

func getArcCenter(startAngle: CGFloat, endAngle: CGFloat )-> CGFloat{
    let midPointAngle = (startAngle + endAngle) / 2.0
    return midPointAngle
}

func drawRotatedText(text: String, at p: CGPoint, angle: CGFloat, font: UIFont, color: UIColor, rect: CGRect) {
  // Draw text centered on the point, rotated by an angle in degrees moving clockwise.
    let attrs = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
    let textSize = text.size(withAttributes: attrs)
  let c = UIGraphicsGetCurrentContext()!
  c.saveGState()
  // Translate the origin to the drawing location and rotate the coordinate system.
  c.translateBy(x: p.x, y: p.y)
  c.rotate(by: angle * .pi / 180)
  // Draw the text centered at the point.
  text.draw(at: CGPoint(x: -textSize.width / 2, y: (-textSize.height / 2) - 120), withAttributes: attrs)
  // Restore the original coordinate system.
  c.restoreGState()
}


struct TextPosition {
    var center: CGPoint
    var angle: CGFloat
}
