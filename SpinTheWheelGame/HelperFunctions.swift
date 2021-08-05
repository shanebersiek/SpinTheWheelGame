//
//  HelperFunctions.swift
//  SpinTheWheelGame
//
//  Created by Shane Bersiek on 8/3/21.
//

import Foundation
import UIKit
import SwiftUI


extension UIView {
   
    func rotate(degrees: CGFloat) {
        rotate(radians: CGFloat.pi * degrees / 180.0)
    }

    func rotate(radians: CGFloat) {
        self.transform = CGAffineTransform(rotationAngle: radians)
    }
}



extension String {
   func drawStringWithBasePoint(basePoint: CGPoint,
                          andAngle angle: CGFloat,
                          andAttributes attributes: [NSAttributedString.Key : Any]) {
       let textSize: CGSize = self.size(withAttributes: attributes)
       let context: CGContext = UIGraphicsGetCurrentContext()!
       let t: CGAffineTransform = CGAffineTransform(translationX: basePoint.x, y: basePoint.y)
       let r: CGAffineTransform = CGAffineTransform(rotationAngle: angle)
       context.concatenate(t)
       context.concatenate(r)
       self.draw(at: CGPoint(x: textSize.width / 2, y: -textSize.height / 2), withAttributes: attributes)
       context.concatenate(r.inverted())
       context.concatenate(t.inverted())
   }
}


let π:CGFloat = CGFloat(M_PI)

extension NSString {
    func drawWithBasePoint(basePoint: CGPoint, andAngle angle: CGFloat, andAttributes attributes: [NSAttributedString.Key : Any]) {
        let radius: CGFloat = 100
        let textSize: CGSize = self.size(withAttributes: attributes)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        let t: CGAffineTransform = CGAffineTransform(translationX: basePoint.x, y: basePoint.y)
        let r: CGAffineTransform = CGAffineTransform(rotationAngle: angle)
        context.concatenate(t)
        context.concatenate(r)
        self.draw(at: CGPoint(x: radius-textSize.width/2, y: -textSize.height/2), withAttributes: attributes)
        context.concatenate(r.inverted())
        context.concatenate(t.inverted())
    }
}

extension CGPoint {
    
    static func pointOnCircle(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        let x = center.x + radius * cos(angle)
        let y = center.y + radius * sin(angle)
        
        return CGPoint(x: x, y: y)
    }
    
    static func angleBetweenThreePoints(center: CGPoint, firstPoint: CGPoint, secondPoint: CGPoint) -> CGFloat {
        let firstAngle = atan2(firstPoint.y - center.y, firstPoint.x - center.x)
        let secondAnlge = atan2(secondPoint.y - center.y, secondPoint.x - center.x)
        var angleDiff = firstAngle - secondAnlge
        
        if angleDiff < 0 {
            angleDiff *= -1
        }
        
        return angleDiff
    }
    
    func angleBetweenPoints(firstPoint: CGPoint, secondPoint: CGPoint) -> CGFloat {
        return CGPoint.angleBetweenThreePoints(center: self, firstPoint: firstPoint, secondPoint: secondPoint)
    }
    
    func angleToPoint(pointOnCircle: CGPoint) -> CGFloat {
        
        let originX = pointOnCircle.x - self.x
        let originY = pointOnCircle.y - self.y
        var radians = atan2(originY, originX)
        
        while radians < 0 {
            radians += CGFloat(2 * Double.pi)
        }
        
        return radians
    }
    
    static func pointOnCircleAtArcDistance(center: CGPoint,
                                           point: CGPoint,
                                           radius: CGFloat,
                                           arcDistance: CGFloat,
                                           clockwise: Bool) -> CGPoint {
        
        var angle = center.angleToPoint(pointOnCircle: point);
        
        if clockwise {
            angle = angle + (arcDistance / radius)
        } else {
            angle = angle - (arcDistance / radius)
        }
        
        return self.pointOnCircle(center: center, radius: radius, angle: angle)
        
    }
    
    func distanceToPoint(otherPoint: CGPoint) -> CGFloat {
        return sqrt(pow((otherPoint.x - x), 2) + pow((otherPoint.y - y), 2))
    }
    
    static func CGPointRound(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: CoreGraphics.round(point.x), y: CoreGraphics.round(point.y))
    }
    
    static func intersectingPointsOfCircles(firstCenter: CGPoint, secondCenter: CGPoint, firstRadius: CGFloat, secondRadius: CGFloat ) -> (firstPoint: CGPoint?, secondPoint: CGPoint?) {
        
        let distance = firstCenter.distanceToPoint(otherPoint: secondCenter)
        let m = firstRadius + secondRadius
        var n = firstRadius - secondRadius
        
        if n < 0 {
            n = n * -1
        }
        
        //no intersection
        if distance > m {
            return (firstPoint: nil, secondPoint: nil)
        }
        
        //circle is inside other circle
        if distance < n {
            return (firstPoint: nil, secondPoint: nil)
        }
        
        //same circle
        if distance == 0 && firstRadius == secondRadius {
            return (firstPoint: nil, secondPoint: nil)
        }
        
        let a = ((firstRadius * firstRadius) - (secondRadius * secondRadius) + (distance * distance)) / (2 * distance)
        let h = sqrt(firstRadius * firstRadius - a * a)
        
        var p = CGPoint.zero
        p.x = firstCenter.x + (a / distance) * (secondCenter.x - firstCenter.x)
        p.y = firstCenter.y + (a / distance) * (secondCenter.y - firstCenter.y)
        
        //only one point intersecting
        if distance == firstRadius + secondRadius {
            return (firstPoint: p, secondPoint: nil)
        }
        
        var p1 = CGPoint.zero
        var p2 = CGPoint.zero
        
        p1.x = p.x + (h / distance) * (secondCenter.y - firstCenter.y)
        p1.y = p.y - (h / distance) * (secondCenter.x - firstCenter.x)
        
        p2.x = p.x - (h / distance) * (secondCenter.y - firstCenter.y)
        p2.y = p.y + (h / distance) * (secondCenter.x - firstCenter.x)
        
        //return both points
        return (firstPoint: p1, secondPoint: p2)
    }
}
//
//func getAngle(with degrese: CGFloat) -> CGFloat {
//    return number * .pi / 180
//}


extension UIView {
    
    static func makeViewCircle(view: UIView)->UIView {
        view.layer.cornerRadius = view.frame.width / 2
        view.layer.masksToBounds = true
        return view
    }
}



func deg2rad(_ number: Double) -> Double {
    return number * .pi / 180
}


func rad2deg(_ radian: Double) -> Double {
    return radian * 180 / .pi
}
