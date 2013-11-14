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
    NSLog(@"pad init");
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
    NSLog(@"pad touchesbegan");
    strokeCount++;
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [path moveToPoint:p];
    if (strokeCount == 1) {
        [pathPointArray addObject:[NSValue valueWithCGPoint:p]];
    } else {
        int lastPointIndex = [pathPointArray count]-1;
        CGPoint p2 = [[pathPointArray1 objectAtIndex:lastPointIndex] CGPointValue];
        if ([self distanceFrom:p to:p2] < 10.0) {
            [pathPointArray addObject:[NSValue valueWithCGPoint:p]];
            strokeCount--;
        } else {
            // check first stroke
            [self checkCollinearity];
            
            // start collecting points for the second stroke
        }
    }
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

- (double) distanceFrom:(CGPoint)point1 to:(CGPoint)point2 {
    long int deltaX = abs(point1.x - point2.x);
    long int deltaY = abs(point2.y - point2.y);
    return sqrt(deltaX * deltaX + deltaY * deltaY);
}

/*-(NSMutableArray *)getPathPoints {
    return pathPointArray;
}*/

-(void) checkCollinearity {
    CGPoint point1, point2, point3;
    unsigned int i=0;
    
    while (i < [pathPointArray count]-2) {
        point1 = [[pathPointArray objectAtIndex:i] CGPointValue];
        point2 = [[pathPointArray objectAtIndex:i+1] CGPointValue];
        point3 = [[pathPointArray objectAtIndex:i+2] CGPointValue];
        double m1 = (point2.y - point1.y) / (point2.x - point1.x);
        double m2 = (point3.y - point1.y) / (point3.x - point1.x);
        if (m1 == m2) { // determine whether the next point should be kept
            [pathPointArray removeObjectAtIndex:i+1];
        } else {
            i++;
        }
    }
}
/*
-(void)writePathToFile:(NSFileHandle *)myHandle {
    CGPoint point;

    if (myHandle) {
        [myHandle seekToEndOfFile];
        for (unsigned int i = 0; i<[pathPointArray count]-1; i++) {
            point = [[pathPointArray objectAtIndex:i] CGPointValue];
            NSString *content= [NSString stringWithFormat:@"%d %d\n", (int)point.x,(int)point.y];
            NSData *theData=[content dataUsingEncoding:NSUTF8StringEncoding];
            [myHandle writeData:theData];
        }
    }
    [pathPointArray removeAllObjects];
}
*/
- (int)rateIt {
    CGPoint point;
    unsigned int i;

    NSFileHandle *readFileHandle = [NSFileHandle fileHandleForUpdatingAtPath:@"/tmp/small/z.txt"];
    if (readFileHandle) {
        NSData *allFileData = [readFileHandle readDataToEndOfFile];
        NSString *allFileStr = [[NSString alloc] initWithData:allFileData encoding:NSUTF8StringEncoding];
        NSArray *allFileStrArray = [allFileStr componentsSeparatedByString:@"\n"];
        for (i=0; i<[allFileStrArray count]-1; i++) {
            NSArray *lineStr = [[allFileStrArray objectAtIndex:i] componentsSeparatedByString:@" "];
            NSString *str1 = [lineStr objectAtIndex:0];
            NSString *str2 = [lineStr objectAtIndex:1];
            point.x = [str1 floatValue];
            point.y = [str2 floatValue];
            if (point.x==0 && point.y==0) {
                [self checkCollinearity];
                /*
                [self writePathToFile:myHandle];
                NSString *content= [NSString stringWithFormat:@"SECOND\n"];
                NSData *theData=[content dataUsingEncoding:NSUTF8StringEncoding];
                [myHandle writeData:theData];
                 */
            } else
                [pathPointArray addObject:[NSValue valueWithCGPoint:point]];
        }
        [readFileHandle closeFile];
    }
    // reduce checkpoints by check the collinearity of points
    [self checkCollinearity];
    //[self writePathToFile:myHandle];
    return 90;
}

-(void)resetDrawingPad {
    // erase path
    strokeCount = 0;
    [pathPointArray removeAllObjects];
    [path removeAllPoints];
    [self setNeedsDisplay];
}
// [path containsPoint:point]

@end
