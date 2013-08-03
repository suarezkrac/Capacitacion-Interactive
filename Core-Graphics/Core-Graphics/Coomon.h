//
//  Coomon.h
//  Core-Graphics
//
//  Created by Equipo Desarrollo 2 on 3/08/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import <Foundation/Foundation.h>

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);

CGRect rectFor1pxStroke(CGRect rect);

void draw1PxStroke(CGContextRef context, CGPoint startpoint, CGPoint endPoint, CGColorRef color );

void drawGlossAndGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);

static inline double radians (double degress) {return degress * M_PI/180;}

CGMutablePathRef createArcPathFromBottomOfRect(CGRect rect, CGFloat arcHeight);
