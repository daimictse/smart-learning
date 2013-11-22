//
//  LetterWritingPad.h
//  Smart Learning
//
//  Created by Doris Shum on 11/8/13.
//  Copyright (c) 2013 Doris Shum. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef int StrokeArray[26];

@interface LetterWritingPad : UIView
{
    UIBezierPath *path;
    NSArray *pathPoints;
    int strokeCount;
    StrokeArray strokeCountArray;
    NSMutableArray *pathPointArray;
    NSMutableArray *defaultPoints;
}

- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (int)getStrokeCount;
- (int) getLetterStrokeCount: (int)index;
- (void)setStrokCountArray:(StrokeArray)tempArray;
- (void)resetDrawingPad ;
//-(NSMutableArray *)getPathPoints;
- (void) setDefaultPoints:(char)letter points:(NSMutableArray *)points;
- (float)rateItWithTemplate:(char)letter;
- (CGContextRef)MyCreateBitmapContext:(int)pixelW height:(int)pixelH;
- (float) drawAndComparePaths:(NSMutableArray *)points template:(NSMutableArray *)templatePts;
- (float)comparePaths:userPath to:templatePath;
- (float)comparePoints:(NSMutableArray *)points to:(NSMutableArray *)templatePts;
- (NSMutableArray *) resample:(NSMutableArray *)points;
- (float) distanceFrom:(CGPoint)point1 to:(CGPoint)point2;
- (float)pathLength:(NSMutableArray *)points;

@end
