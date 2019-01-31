//
//  UICircleSlider.m
//  CircleSlider
//
//  Created by Kid Young on 1/20/16.
//  Copyright © 2016 Yang XiHong. All rights reserved.
//

#import "UICircleSlider.h"
#import <UIKit/UIBezierPath.h>

#define M2PI (2 * M_PI)

@interface UICircleSlider () {
    float _value;
    CGFloat _radius;
}

/**
 Use to store current touch point location in view.
 Update while touches Began, Moved, Ended and Cancelled.
 */
@property (nonatomic, assign) CGPoint touchPoint;
/**
 Use to store last touch point location in view.
 Update while touches Began and Moved across between quadrant 1 and 4.
 */
@property (nonatomic, assign) CGPoint lastPoint;
/**
 Use to store angle for the value.
 */
@property (nonatomic, assign) CGFloat angle;
/**
 Use to store last angle for the angle.
 Update while touches Began, Ended, Cancelled and Moved across between quadrant 1 and 4.
 */
@property (nonatomic, assign) CGFloat lastAngle;
/**
 Use to store last value for the value.
 Update while touches Began, Ended and Moved more than 'delta'.
 */
@property (nonatomic, assign) float lastValue;

/**
 Use to store transformed kCGLineCap to kCALineCap
 */
@property (nonatomic, copy) NSString *lineCapString;
/**
 Use to store transformed kCGLineJoin to kCALineJoin
 */
@property (nonatomic, copy) NSString *lineJoinString;

@property (nonatomic, strong) CAShapeLayer *valueShapeLayer;
@property (nonatomic, strong) CAShapeLayer *backgroundCircleShapeLayer;
@property (nonatomic, strong) CAShapeLayer *borderCircleShapeLayer;

@end

IB_DESIGNABLE
@implementation UICircleSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configuration];
        [self initialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configuration];
        [self initialization];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)removeFromSuperview
{
    [self.valueShapeLayer removeFromSuperlayer];
    [self.backgroundCircleShapeLayer removeFromSuperlayer];
    [self.borderCircleShapeLayer removeFromSuperlayer];
    [super removeFromSuperview];
}

- (void)dealloc
{
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.frame;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake((rect.size.width / 2), (rect.size.height / 2)) radius:(self.radius / 2 - self.lineWidth / 2) startAngle:self.realStartAngle endAngle:self.realStartAngle + M2PI * self.maximumValue clockwise:self.clockwise];
    // with border circle
    // on Bottom for border circle
    [self.borderCircleShapeLayer removeFromSuperlayer];
    self.borderCircleShapeLayer = CAShapeLayer.layer;
    self.borderCircleShapeLayer.lineWidth = self.lineWidth + self.borderWidth;
    self.borderCircleShapeLayer.strokeColor = self.borderColor.CGColor;
    self.borderCircleShapeLayer.fillColor = nil;
    self.borderCircleShapeLayer.lineCap = self.lineCapString;
    self.borderCircleShapeLayer.lineJoin = self.lineJoinString;
    self.borderCircleShapeLayer.lineDashPattern = self.lineDashPattern;
    self.borderCircleShapeLayer.path = path.CGPath;
    [self.layer addSublayer:self.borderCircleShapeLayer];
    // on Middle for background circle
    [self.backgroundCircleShapeLayer removeFromSuperlayer];
    self.backgroundCircleShapeLayer = CAShapeLayer.layer;
    self.backgroundCircleShapeLayer.lineWidth = self.lineWidth / 2;
    self.backgroundCircleShapeLayer.strokeColor = self.trackTintColor.CGColor;
    self.backgroundCircleShapeLayer.fillColor = nil;
    self.backgroundCircleShapeLayer.lineCap = self.lineCapString;
    self.backgroundCircleShapeLayer.lineJoin = self.lineJoinString;
    self.backgroundCircleShapeLayer.lineDashPattern = self.lineDashPattern;
    self.backgroundCircleShapeLayer.path = path.CGPath;
    [self.layer addSublayer:self.backgroundCircleShapeLayer];
    // on Top for top circle
    // from 0.0 -> 1.0 tranlate to 0 -> M2PI
    // The clockwise parameter determines the direction in which the arc is created; the actual direction of the final path is dependent on the current transformation matrix of the graphics context. In a flipped coordinate system (the default for UIView drawing methods in iOS), specifying a clockwise arc results in a counterclockwise arc after the transformation is applied.
    [self.valueShapeLayer removeFromSuperlayer];
    self.valueShapeLayer = CAShapeLayer.layer;
    self.valueShapeLayer.strokeColor = self.sliderTintColor.CGColor;
    self.valueShapeLayer.fillColor = nil;
    self.valueShapeLayer.lineWidth = self.lineWidth;
    self.valueShapeLayer.lineCap = self.lineCapString;
    self.valueShapeLayer.lineJoin = self.lineJoinString;
    self.valueShapeLayer.lineDashPattern = self.lineDashPattern;
    self.valueShapeLayer.path = path.CGPath;
    [self.layer addSublayer:self.valueShapeLayer];
    self.valueShapeLayer.strokeEnd = self.value;
}

#pragma mark - Private Methods

- (void)initialization
{
}

- (void)configuration
{
    self.value = 0.0;
    self.minimumValue = 0.0;
    self.maximumValue = 1.0;
    self.delta = 0.0;
    self.continuous = YES;

    self.clockwise = YES;
    self.duration = 0.5;
    self.startAngle = M_PI_2;
    self.lineWidth = 5;
    self.lineCap = kCGLineCapButt;
    self.lineJoin = kCGLineJoinMiter;
    self.lineDashPattern = nil;
    self.sliderTintColor = [UIColor whiteColor];
    self.borderColor = [UIColor grayColor];
    self.trackTintColor = [UIColor darkGrayColor];
}

- (void)flipsYcoordinateContext:(CGContextRef)context block:(void (^)(void))block
{
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    block();
    CGContextRestoreGState(context);
}

- (CGFloat)realStartAngle
{
    CGFloat realStartAngle = (self.startAngle + (self.minimumValue * M2PI));
    /* testing
    if (realStartAngle > self.realEndAngle) {
        realStartAngle = self.realEndAngle;
    }
     */
    return realStartAngle;
}

- (CGFloat)realEndAngle
{
    CGFloat realEndAngle = (self.startAngle/* + ((self.maximumValue - 1) * M2PI)*/ + (self.angle * (self.clockwise * 2 - 1.0)));
    /* testing
    CGFloat realEndAngle = (self.startAngle + ((self.maximumValue - 1) * M2PI) + (self.angle * (self.clockwise * 2 - 1.0)));
    if (realEndAngle < self.startAngle) {
        realEndAngle = self.startAngle;
    }
     */
    return realEndAngle;
}

#pragma mark - Public Methods

- (float)value
{
    if (_value < self.minimumValue) {
        _value = self.minimumValue;
    }
    if (_value > self.maximumValue) {
        _value = self.maximumValue;
    }
    return _value;
}

- (void)setValue:(float)value
{
    [self setValue:value animated:NO];
}

- (void)setValue:(float)value animated:(BOOL)animated
{
    _value = value;
    self.angle = self.value * M2PI;
    if (animated) {
        [CATransaction begin];
        [CATransaction setDisableActions:NO];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [CATransaction setAnimationDuration:self.duration];
        self.valueShapeLayer.strokeEnd = value;
        [CATransaction commit];
    } else {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.valueShapeLayer.strokeEnd = value;
        [CATransaction commit];
    }
}

- (void)setDelta:(float)delta
{
    _delta = delta;
    if (_delta > 0.25) {
        _delta = 0.25;
    }
}

- (CGFloat)radius
{
    if (_radius <= 0) {
        _radius = (self.frame.size.height > self.frame.size.width ? self.frame.size.width : self.frame.size.height) / 3 * 2;
    }
    return _radius;
}

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    [self setNeedsLayout];
}

- (void)setLineCap:(CGLineCap)lineCap
{
    _lineCap = lineCap;
    switch (self.lineCap) {
        case kCGLineCapButt:
            self.lineCapString = kCALineCapButt;
            break;

        case kCGLineCapRound:
            self.lineCapString = kCALineCapRound;
            break;

        case kCGLineCapSquare:
            self.lineCapString = kCALineCapSquare;
            break;

        default:
            self.lineCapString = kCALineCapButt;
            break;
    }
}

- (void)setLineJoin:(CGLineJoin)lineJoin
{
    _lineJoin = lineJoin;
    switch (self.lineJoin) {
        case kCGLineJoinMiter:
            self.lineJoinString = kCALineJoinMiter;
            break;

        case kCGLineJoinRound:
            self.lineJoinString = kCALineJoinRound;
            break;

        case kCGLineJoinBevel:
            self.lineJoinString = kCALineJoinBevel;
            break;

        default:
            self.lineJoinString = kCALineJoinMiter;
            break;
    }
}

- (void)setLineDashPattern:(NSArray<NSNumber *> *)lineDashPattern
{
    _lineDashPattern = lineDashPattern;
    // Use kCGLineCapButt and kCGLineJoinMiter cause of kCGLineJoinRound, kCGLineJoinBevel and kCGLineCapRound, kCGLineCapSquare will append part draw.
    if (self.lineDashPattern != nil) {
        self.lineCap = kCGLineCapButt;
        self.lineJoin = kCGLineJoinMiter;
    }
    [self setNeedsLayout];
}

#pragma mark - UIResponder touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    self.touchPoint = [touch locationInView:self];
    self.lastPoint = self.touchPoint;
    self.lastValue = self.value;
    self.lastAngle = self.angle;
//    [self sendActionsForControlEvents:UIControlEventTouchDown];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    self.touchPoint = [touch locationInView:self];
    CGFloat increaseAngle = atan2(self.touchPoint.y - self.bounds.size.height / 2, self.touchPoint.x - self.bounds.size.width / 2) - atan2(self.lastPoint.y - self.bounds.size.height / 2, self.lastPoint.x - self.bounds.size.width / 2);
    // Use (self.clockwise * 2 - 1.0) to calculate clockwise to 1.0 and counterclockwise to -1.0.
    self.angle = self.lastAngle + (increaseAngle * (self.clockwise * 2 - 1.0));
    if (self.angle < 0) {
        self.angle += M2PI;
    } else if (self.angle > M2PI) {
        self.angle -= M2PI;
    }
    self.value = self.angle / M2PI;
    if (self.lastValue < 0.25 && self.lastValue >= 0) {
        // From quadrant 1
        if (self.value > 0.5) {
            // To quadrant 4
            self.angle = 0;
            self.value = self.angle / M2PI;
            self.lastAngle = self.angle;
            self.lastPoint = self.touchPoint;
//        } else {
//            NSLog(@"11 %f", self.value);
        }
    } else if (self.lastValue > 0.75 && self.lastValue <= 1) {
        // From quadrant 4
        if (self.value < 0.5) {
            // To quadrant 1
            self.angle = M2PI;
            self.value = self.angle / M2PI;
            self.lastAngle = self.angle;
            self.lastPoint = self.touchPoint;
//        } else {
//            NSLog(@"44 %f", self.value);
        }
    }
    if (fabs(self.value - self.lastValue) >= self.delta) {
        if (self.continuous == YES) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            /*
            if (@available(iOS 10.0.0, *)) {
                UIImpactFeedbackGenerator *impactFeedbackGenerator = [[UIImpactFeedbackGenerator alloc] init];
                [impactFeedbackGenerator prepare];
                [impactFeedbackGenerator impactOccurred];
            } else {

            }
             */
        }
        self.lastValue = self.value;
    }
//    NSLog(@"%f %f", self.value, self.angle);
//    NSLog(@"%f %f", self.value, self.lastValue);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    self.touchPoint = [touch locationInView:self];
    self.lastAngle = self.angle;
    self.lastValue = self.value;
//    NSLog(@"%f %f", self.value, self.lastValue);
    [self sendActionsForControlEvents:UIControlEventValueChanged];
//    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    UITouch *touch = touches.anyObject;
    self.touchPoint = [touch locationInView:self];
    self.lastAngle = self.angle;
//    [self sendActionsForControlEvents:UIControlEventTouchCancel];
}

#pragma mark - hitTest
/*
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([super hitTest:point withEvent:event] == NO) {
        return nil;
    }
    if (self.userInteractionEnabled == NO || self.alpha <= 0.01 || self.hidden == YES) {
        return nil;
    }
    if ([self pointInside:point withEvent:event] == NO) {
        return nil;
    }
    for (UIView *subview in self.subviews) {
        CGPoint subPoint = [self convertPoint:point toView:subview];
        UIView *nextView = [subview hitTest:subPoint withEvent:event];
        if (nextView) {
            return nextView;
        }
    }
    CGFloat distance = sqrtf((point.x - self.center.x) * (point.x - self.center.x) + (point.y - self.center.y) * (point.y - self.center.y));
    CGFloat radius = (self.frame.size.width < self.frame.size.height ? self.frame.size.width : self.frame.size.height) / 2;
    if (distance < radius) {
        return self;
    }
    return nil;
}
 */
#pragma mark - pointInside
/*
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL superPointInside = [super pointInside:point withEvent:event];
    CGFloat radius = self.rect.size.width / 2;
    BOOL pointInside = [[UIBezierPath bezierPathWithArcCenter:CGPointMake((self.rect.size.width / 2), (self.rect.size.height / 2)) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:self.clockwise] containsPoint:point];
    return superPointInside && pointInside;
}
 */

@end
