//
//  CustomCellBackground.m
//  Core-Graphics
//
//  Created by Equipo Desarrollo 2 on 3/08/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "CustomCellBackground.h"

@implementation CustomCellBackground

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *whiteColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];

    UIColor * lightGrayColor = [UIColor colorWithWhite:0.898 alpha:1.0];
    UIColor * separatorColor = [UIColor colorWithRed:208/255 green:208/255 blue:208/255 alpha:1.0];
    
    CGRect paperRect = self.bounds;
    
    if (self.selected) {
        drawLinearGradient(context, paperRect, lightGrayColor.CGColor, separatorColor.CGColor);
    } else {
        drawLinearGradient(context, paperRect, whiteColor.CGColor, lightGrayColor.CGColor);
    }
    
    CGRect strokeRect = paperRect;
    strokeRect.size.height -=1;
    strokeRect = rectFor1pxStroke(strokeRect);
    CGContextSetStrokeColorWithColor(context, whiteColor.CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokeRect(context, strokeRect);
    
    CGPoint startPoint = CGPointMake(paperRect.origin.x, paperRect.origin.y+paperRect.size.height - 1);
    CGPoint endPoint = CGPointMake(paperRect.origin.x+paperRect.size.width-1, paperRect.origin.y + paperRect.size.height - 1);
    
    if(!self.lastCell){
        draw1PxStroke(context, startPoint, endPoint, separatorColor.CGColor);
    }else{
        CGContextSetStrokeColorWithColor(context, whiteColor.CGColor);
        
        CGContextSetLineWidth(context, 1.0);
        
        CGPoint pointA = CGPointMake(paperRect.origin.x, paperRect.origin.y + paperRect.size.height-1);
        CGPoint pointB = CGPointMake(paperRect.origin.x, paperRect.origin.y);
        CGPoint pointC = CGPointMake(paperRect.origin.x + paperRect.size.width -1, paperRect.origin.y);
        CGPoint pointD = CGPointMake(paperRect.origin.x + paperRect.size.width -1, paperRect.origin.y + paperRect.size.height-1);
        
        draw1PxStroke(context, pointA, pointB, whiteColor.CGColor);
        draw1PxStroke(context, pointB, pointC, whiteColor.CGColor);
        draw1PxStroke(context, pointC, pointD, whiteColor.CGColor);
        
    }

}


@end
