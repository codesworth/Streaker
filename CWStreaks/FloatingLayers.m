//
//  FloatingLayers.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 1/15/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "FloatingLayers.h"

@implementation FloatingLayers

-(void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat innerWidth = 8;
    [[UIColor colorWithRed:0.725 green:0.46667 blue:1 alpha:1] setStroke];
    
    CGContextSetLineWidth(ctx, innerWidth);
    
    // We add an ellipsis shifted by half the inner Width
    CGContextAddEllipseInRect(ctx, CGRectInset(rect, innerWidth, innerWidth));
    
    // Stroke the path
    CGContextStrokePath(ctx);
}

@end
