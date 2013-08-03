//
//  Coomon.m
//  Core-Graphics
//
//  Created by Equipo Desarrollo 2 on 3/08/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "Coomon.h"
#import <Foundation/Foundation.h>

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor){
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0 , 1.0};
    NSArray *colors = @[(__bridge_transfer id) startColor, (__bridge_transfer id) endColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge_retained CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

CGRect rectFor1pxStroke(CGRect rect){
    return CGRectMake(rect.origin.x + 0.5, rect.origin.y + 0.5, rect.size.width -1, rect.size.height - 1);
}

void draw1PxStroke(CGContextRef context, CGPoint startpoint, CGPoint endPoint, CGColorRef color ){
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    
    CGContextSetStrokeColorWithColor(context, color);
    
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, startpoint.x+0.5, startpoint.y + 0.5);
    CGContextAddLineToPoint(context, endPoint.x + 0.5, endPoint.y + 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}
void drawGlossAndGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor){
    drawLinearGradient(context, rect, startColor, endColor);
    
    UIColor * glossColor1 = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.35];
    UIColor * glossColor2 = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
    
    CGRect tophalf = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height/2);
    
    drawLinearGradient(context, tophalf, glossColor1.CGColor, glossColor2.CGColor);
}
CGMutablePathRef createArcPathFromBottomOfRect(CGRect rect, CGFloat arcHeight){
    
    CGRect arcRect = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height - arcHeight, rect.size.width, rect.size.height);
    CGFloat arcRadius = (arcRect.size.height/2) + (pow(arcRect.size.width, 2)/(8*arcRect.size.height));
    
    CGPoint arcCenter = CGPointMake(arcRect.origin.x + arcRect.size.width/2, arcRect.origin.y+arcRadius);
    
    CGFloat angle = acosf(arcRect.size.width/(2*arcRadius));
    
    CGFloat startAngle = radians(180) + angle;
    CGFloat endAngle = radians(360) + angle;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, arcCenter.x, arcCenter.y, arcRadius, startAngle, endAngle, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    
    return path;
}










