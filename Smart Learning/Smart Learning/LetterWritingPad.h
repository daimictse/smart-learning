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

@end
