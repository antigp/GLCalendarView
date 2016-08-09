//
//  GLCalendarDayCellSelectedCover.m
//  GLPeriodCalendar
//
//  Created by ltebean on 15/4/18.
//  Copyright (c) 2015 glow. All rights reserved.
//

#import "GLCalendarDayCellBackgroundCover.h"
#define POINT_SCALE 1.3

@interface GLCalendarRangePoint : UIView
@property (nonatomic, strong, readonly) UIColor *strokeColor;
@property (nonatomic, readonly) CGFloat borderWidth;
- (instancetype)initWithSize:(CGFloat)size borderWidth:(CGFloat)borderWidth strokeColor:(UIColor *)strokeColor;
@end

@implementation GLCalendarRangePoint

- (instancetype)initWithSize:(CGFloat)size borderWidth:(CGFloat)borderWidth strokeColor:(UIColor *)strokeColor
{
    self = [super initWithFrame:CGRectMake(0, 0, size, size)];
    if (self) {
        self.layer.borderColor = strokeColor.CGColor;
        self.layer.borderWidth = borderWidth;
        self.layer.cornerRadius = size / 2;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
    }
    return self;
}
@end

@interface GLCalendarDayCellBackgroundCover()
@property (nonatomic, strong) GLCalendarRangePoint *beginPoint;
@property (nonatomic, strong) GLCalendarRangePoint *endPoint;
@end
@implementation GLCalendarDayCellBackgroundCover

- (void)setRangePosition:(RANGE_POSITION)rangePosition
{
    _rangePosition = rangePosition;
    self.inEdit = self.inEdit;
    [self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    [self setNeedsDisplay];
}

- (void)setIsToday:(BOOL)isToday
{
    _isToday = isToday;
    [self setNeedsDisplay];
}

- (void)setInEdit:(BOOL)inEdit
{
    _inEdit = inEdit;
    if (inEdit) {
        if (self.rangePosition == RANGE_POSITION_BEGIN) {
            self.beginPoint.center = CGPointMake(self.borderWidth / 2 + self.paddingLeft, self.bounds.size.height / 2);
            [self addSubview:self.beginPoint];
            [_endPoint removeFromSuperview];
        } else if (self.rangePosition == RANGE_POSITION_END) {
            self.endPoint.center = CGPointMake(self.bounds.size.width - self.borderWidth / 2 - self.paddingRight, self.bounds.size.height / 2);
            [self addSubview:self.endPoint];
            [_beginPoint removeFromSuperview];
        } else if (self.rangePosition == RANGE_POSITION_SINGLE) {
            self.beginPoint.center = CGPointMake(self.borderWidth / 2 + self.paddingLeft, self.bounds.size.height / 2);
            [self addSubview:self.beginPoint];
            self.endPoint.center = CGPointMake(self.bounds.size.width - self.borderWidth / 2 - self.paddingRight, self.bounds.size.height / 2);
            [self addSubview:self.endPoint];
        } else {
            [_beginPoint removeFromSuperview];
            [_endPoint removeFromSuperview];
        }
    } else {
        [_beginPoint removeFromSuperview];
        [_endPoint removeFromSuperview];
    }
    [self setNeedsDisplay];
}

- (GLCalendarRangePoint *)beginPoint
{
   
    return _beginPoint;
}

- (GLCalendarRangePoint *)endPoint
{
 
    return _endPoint;
}


- (void)drawRect:(CGRect)rect
{
    [self drawSelectedCover:rect];
}

- (void)drawSelectedCover:(CGRect)rect
{
    GLCalendarDayCellBackgroundCover *appearance = [[self class] appearance];
    if (self.rangePosition == RANGE_POSITION_NONE) {
        if(_inEdit) {
            UIImage * image = appearance.deSelectedDayImage;
            [image drawInRect:CGRectMake((rect.size.width - image.size.width)/2, (rect.size.height - image.size.height), image.size.width, image.size.height)];
        }
        return;
    }
    
    CGFloat paddingLeft = self.paddingLeft;
    CGFloat paddingRight = self.paddingRight;
    CGFloat paddingTop = self.paddingTop;
    
    CGFloat borderWidth = self.borderWidth;
    
    CGFloat height = rect.size.height;
    CGFloat width = rect.size.width;
    CGFloat radius = (height - borderWidth * 2 - paddingTop * 2) / 2;
    
    CGFloat midY = CGRectGetMidY(rect);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (!self.continuousRangeDisplay || self.backgroundImage) {
        CGRect rect = CGRectMake(borderWidth + paddingLeft, borderWidth + paddingTop, width - borderWidth * 2 - paddingLeft - paddingRight,  height - borderWidth * 2 - paddingTop * 2);
        if (self.backgroundImage) {
            CGRect rect = CGRectMake((width - self.backgroundImage.size.width)/2, (height - self.backgroundImage.size.height)/2, self.backgroundImage.size.width,  self.backgroundImage.size.height);
            [self.backgroundImage drawInRect:rect];
            return;
        }
        path = [UIBezierPath bezierPathWithOvalInRect:rect];
        [path closePath];
        [self.fillColor setFill];
        [path fill];
        return;
    }
    
    
    
    if (self.rangePosition == RANGE_POSITION_BEGIN) {
        if(self.inEdit) {
            [path moveToPoint:CGPointMake(radius + borderWidth + paddingLeft, height-19)];
            [path addArcWithCenter:CGPointMake(radius + borderWidth + paddingLeft+2, height-(19.f/2.f)) radius:18.f/2.f startAngle: - M_PI / 2 endAngle: M_PI / 2 clockwise:NO];
            [path addLineToPoint:CGPointMake(width, height)];
            [path addLineToPoint:CGPointMake(width, height-19)];
            [path closePath];
        }
        else{
            [path moveToPoint:CGPointMake(radius + borderWidth + paddingLeft, paddingTop + borderWidth)];
            [path addArcWithCenter:CGPointMake(radius + borderWidth + paddingLeft+2, midY) radius:radius startAngle: - M_PI / 2 endAngle: M_PI / 2 clockwise:NO];
            [path addLineToPoint:CGPointMake(width, height - borderWidth - paddingTop)];
            [path addLineToPoint:CGPointMake(width, borderWidth + paddingTop)];
            [path closePath];
        }
    } else if (self.rangePosition == RANGE_POSITION_END) {
        if(self.inEdit) {
            [path moveToPoint:CGPointMake(width - borderWidth - radius - paddingRight, height-19)];
            [path addArcWithCenter:CGPointMake(width - borderWidth - radius - paddingRight-2, height-(19.f/2.f)) radius:18.f/2.f startAngle: - M_PI / 2 endAngle: M_PI / 2 clockwise:YES];
            [path addLineToPoint:CGPointMake(0, height)];
            [path addLineToPoint:CGPointMake(0, height-19)];
            [path closePath];
        }
        else{
            [path moveToPoint:CGPointMake(width - borderWidth - radius - paddingRight, paddingTop + borderWidth)];
            [path addArcWithCenter:CGPointMake(width - borderWidth - radius - paddingRight-2, midY) radius:radius startAngle: - M_PI / 2 endAngle: M_PI / 2 clockwise:YES];
            [path addLineToPoint:CGPointMake(0, height - borderWidth - paddingTop)];
            [path addLineToPoint:CGPointMake(0, borderWidth + paddingTop)];
            [path closePath];
        }
    }  else if (self.rangePosition == RANGE_POSITION_MIDDLE){
        if(self.inEdit) {
            [path moveToPoint:CGPointMake(0, height-19)];
            [path addLineToPoint:CGPointMake(width, height-19)];
            [path addLineToPoint:CGPointMake(width,height)];
            [path addLineToPoint:CGPointMake(0, height)];
            [path closePath];
        }
        else{
            [path moveToPoint:CGPointMake(0, borderWidth + paddingTop)];
            [path addLineToPoint:CGPointMake(width, borderWidth + paddingTop)];
            [path addLineToPoint:CGPointMake(width, height - borderWidth - paddingTop)];
            [path addLineToPoint:CGPointMake(0, height - borderWidth - paddingTop)];
            [path closePath];
        }
    } else if (self.rangePosition == RANGE_POSITION_SINGLE) {
        if(self.inEdit) {
        }
        else {
            path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(borderWidth + paddingLeft, borderWidth + paddingTop, width - borderWidth * 2 - paddingLeft - paddingRight,  height - borderWidth * 2 - paddingTop * 2)];
            [path closePath];
        }
    }

    
    if (self.defaultStrokeColor) {
        path.lineWidth = 1;
        [self.defaultStrokeColor setStroke];
        [path stroke];
    }
    if(_inEdit) {
        [[UIColor colorWithRed:119.f/255.f green:48.f/255.f blue:48.f/255.f alpha:1] setFill];
    }
    else{
        [self.fillColor setFill];
    }
    [path fill];
    
    if(_inEdit) {
        UIImage * image = appearance.selectedDayImage;
        [image drawInRect:CGRectMake((width - image.size.width)/2, (height - image.size.height), image.size.width, image.size.height)];
    }
}

- (void)drawTodayCircle:(CGRect)rect
{
    if (!self.isToday) {
        return;
    }
    CGFloat paddingLeft = self.paddingLeft;
    CGFloat paddingRight = self.paddingRight;
    CGFloat paddingTop = self.paddingTop;
    
    CGFloat borderWidth = self.borderWidth;
    
    CGFloat height = rect.size.height;
    CGFloat width = rect.size.width;
            
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(borderWidth + paddingLeft, borderWidth + paddingTop, width - borderWidth * 2 - paddingLeft - paddingRight,  height - borderWidth * 2 - paddingTop * 2)];
    [path closePath];
    [self.fillColor setFill];
    [path fill];
}

- (void)enlargeBeginPoint:(BOOL)enlarge
{
    if (enlarge) {
        [self setPointView:_beginPoint sizeTo:ceilf(self.pointSize * self.pointScale)];
    } else {
        [self setPointView:_beginPoint sizeTo:self.pointSize];
    }
}

- (void)enlargeEndPoint:(BOOL)enlarge
{
    if (enlarge) {
        [self setPointView:_endPoint sizeTo:ceilf(self.pointSize * self.pointScale)];
    } else {
        [self setPointView:_endPoint sizeTo:self.pointSize];
    }
}

- (void)setPointView:(UIView *)pointView sizeTo:(CGFloat)size
{
    CGPoint center = pointView.center;
    pointView.frame = CGRectMake(0, 0, size, size);
    pointView.center = center;
    pointView.layer.cornerRadius = size / 2;
}
@end
