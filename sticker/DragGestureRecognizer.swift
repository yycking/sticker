//
//  DragGestureRecognizer.swift
//  sticker
//
//  Copyright (c) 2016年 YehYungCheng
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit.UIGestureRecognizerSubclass

let π = CGFloat(M_PI)

class DragGestureRecognizer: UIGestureRecognizer {
    var focusRect:CGRect!
    var rotate:CGFloat = 0
    var scale:CGFloat = 1
    
    func lengthFromCenter(point:CGPoint) -> CGFloat {
        let midPoint = CGPointMake(CGRectGetMidX(self.view!.bounds), CGRectGetMidY(self.view!.bounds))
        let width = Float(point.x - midPoint.x)
        let height = Float(point.y - midPoint.y)
        
        return CGFloat(sqrtf(width*width + height*height))
    }
    
    func angleFromCenter(point:CGPoint) -> CGFloat {
        let midPoint = CGPointMake(CGRectGetMidX(self.view!.bounds), CGRectGetMidY(self.view!.bounds))
        let width = Float(point.x - midPoint.x)
        let height = Float(point.y - midPoint.y)
        
        return CGFloat(atan2f(height, width))
    }
    
    // MARK: -UIGestureRecognizer
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        
        if touches.count > 0 {
            state = .Began
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        
        if state == .Failed {
            return
        }
        
        if let firstTouch = touches.first {
            let currentPoint = firstTouch.locationInView(self.view)
            let previousPoint = firstTouch.previousLocationInView(self.view)
            
            scale = lengthFromCenter(currentPoint) / lengthFromCenter(previousPoint)
            rotate = angleFromCenter(currentPoint) - angleFromCenter(previousPoint)
            
            state = .Changed
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        state = .Ended
    }
    
}
