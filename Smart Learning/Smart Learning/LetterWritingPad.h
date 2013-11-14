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
    NSMutableArray *pathPointArray1;
    NSMutableArray *pathPointArray2;
}

- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (int)getStrokeCount;
-(int) getLetterStrokeCount: (int)index;
-(void)setStrokCountArray:(StrokeArray)tempArray;
-(void)resetDrawingPad ;
//-(NSMutableArray *)getPathPoints;
- (int)rateIt;
-(void) checkCollinearity;
//-(void)writePathToFile:(NSFileHandle *)myHandle ;
- (double) distanceFrom:(CGPoint)point1 to:(CGPoint)point2;

@end