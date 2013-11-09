//
//  LetterWritingPad.m
//  Smart Learning
//
//  Created by Doris Shum on 11/8/13.
//  Copyright (c) 2013 Doris Shum. All rights reserved.
//

#import "LetterWritingPad.h"

@implementation LetterWritingPad

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"init");
    strokeCount = 0;
    pathPointArray = [[NSMutableArray alloc]init];
    if (self = [super initWithCoder:aDecoder]) {
        [self setMultipleTouchEnabled:NO];
        [self setBackgroundColor: [UIColor clearColor]];
        path = [UIBezierPath bezierPath];
        [path setLineWidth:2.0];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor blackColor] setStroke];
    [path stroke];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"begin");
    strokeCount++;
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [path moveToPoint:p];
    [pathPointArray addObject:[NSValue valueWithCGPoint:p]];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [path addLineToPoint:p];
    [self setNeedsDisplay];
    [pathPointArray addObject:[NSValue valueWithCGPoint:p]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesMoved:touches withEvent:event];
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (int) getStrokeCount {
    return strokeCount;
}

-(int) getLetterStrokeCount: (int)index {
    return strokeCountArray[index];
}

-(void)setStrokCountArray: (StrokeArray)tempArray {
    memcpy(strokeCountArray, tempArray, sizeof(strokeCountArray));
}

-(void)resetDrawingPad {
    // erase path
    NSLog(@"Array %d",[pathPointArray count]);
    CGPoint point;
    for (unsigned int i = 0; i<[pathPointArray count]; i++) {
        point = [[pathPointArray objectAtIndex:i] CGPointValue];
        NSLog(@"%f %f", point.x, point.y);
    }
    strokeCount = 0;
    [pathPointArray removeAllObjects];
}
// [path containsPoint:point]

@end
