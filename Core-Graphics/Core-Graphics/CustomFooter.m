//
//  CustomFooter.m
//  Core-Graphics
//
//  Created by Equipo Desarrollo 2 on 3/08/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "CustomFooter.h"
#import "Coomon.h"

@implementation CustomFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor * lightGrayColor = [UIColor colorWithWhite:0.898 alpha:1.0];
    UIColor * darkGrayColor = [UIColor colorWithWhite:0.581 alpha:1.0];
    UIColor * shadowColor = [UIColor colorWithWhite:0.200 alpha:1.0];
    
    CGFloat paperMargin = 9.0;
    CGRect paperRect = CGRectMake(self.bounds.origin.x + paperMargin, self.bounds.origin.y, self.bounds.size.width - paperMargin*2, self.bounds.size.height);
    
    CGRect arcRect = paperRect;
    arcRect.size.height = 8;
    
    CGContextSaveGState(context);
    CGMutablePathRef arcPath = createArcPathFromBottomOfRect(arcRect, 4.0);
    CGContextAddPath(context, arcPath);
    CGContextClip(context);
    drawLinearGradient(context,paperRect,lightGrayColor.CGColor,darkGrayColor.CGColor);
    CGContextRestoreGState(context);
    
    CGContextAddRect(context, paperRect);
    CGContextAddPath(context, arcPath);
    CGContextEOClip(context);
    CGContextAddPath(context, arcPath);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 3.0, shadowColor.CGColor);
    CGContextFillPath(context);
    
    CFRelease(arcPath);

}


@end
