//
//  UICircleSlider.h
//  CircleSlider
//
//  Created by Kid Young on 1/20/16.
//  Copyright © 2016 Yang XiHong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICircleSlider : UIControl

/**
 The slider’s current value.
 Use this property to get and set the slider’s current value. To render an animated transition from the current value to the new value, use the setValue:animated: method instead.
 If you try to set a value that is below the minimum or above the maximum, the minimum or maximum value is set instead. The default value of this property is 0.0.

 default 0.0. this value will be pinned to 0.0/1.0
 */
@property (nonatomic, assign) IBInspectable float value;

/**
 The minimum value of the slider.
 Use this property to set the value that the restrict start angle of the circle slider represents. If you change the value of this property, and the current value of the slider is below the new minimum, the slider adjusts the value property to match the new minimum. If you set the minimum value to a value larger than the maximum, the slider updates the maximum value to equal the minimum.

 The default value of this property is 0.0.

 default 0.0. the current value may change if outside new min value
 */
@property (nonatomic, assign) IBInspectable float minimumValue;

/**
 The maximum value of the slider.
 Use this property to set the value that the restrict end angle of the circle slider represents. If you change the value of this property, and the current value of the slider is above the new maximum, the slider adjusts the value property to match the new maximum. If you set the maximum value to a value smaller than the minimum, the slider updates the minimum value to equal the maximum.

 The default value of this property is 1.0.

 default 1.0. the current value may change if outside new max value
 */
@property (nonatomic, assign) IBInspectable float maximumValue;

/**
 default 0.0. the difference value between value and old value that trigger continuous events. must between 0.0 - 0.25. if it is larger than 0.25, then it will be reset to 0.25.
 */
@property (nonatomic, assign) IBInspectable float delta;

/**
 A Boolean value indicating whether changes in the slider’s value generate continuous update events.
 If YES, the slider triggers the associated target’s action method repeatedly, as the user moves the thumb. If NO, the slider triggers the associated action method just once, when the user releases the slider’s thumb control to set the final value.

 The default value of this property is YES.

 default = YES. if set, value change events are generated any time the value changes due to dragging.
 */
@property (nonatomic, getter=isContinuous) IBInspectable BOOL continuous;

/**
 default = YES. draw the circle in clockwise or anticlockwise.
 */
@property (nonatomic, assign) IBInspectable BOOL clockwise;

/**
 default = 0.5. The total duration of the view draw the circle, measured in seconds. If you specify a negative value or 0, the changes are made without animating them.
 */
@property (nonatomic, assign) IBInspectable double duration;

/**
 default = M_PI_2. draw the circle from this angle.
 */
@property (nonatomic, assign) IBInspectable CGFloat startAngle;

/**
 default = self.rect.size.width / 3 * 2. radius of the circle.
 */
@property (nonatomic, assign) IBInspectable CGFloat radius;

/**
 default = 5. line width of the circle.
 */
@property (nonatomic, assign) IBInspectable CGFloat lineWidth;

/**
 default = kCGLineCapRound. Testing: If setLineDashPattern with not nil array, it reset to kCGLineCapButt.
 */
@property (nonatomic, assign) IBInspectable CGLineCap lineCap;

/**
 default = kCGLineJoinRound. Testing: If setLineDashPattern with not nil array, it reset to kCGLineJoinMiter.
 */
@property (nonatomic, assign) IBInspectable CGLineJoin lineJoin;

/**
 default = nil. line dash lengths use for CGContextSetLineDash(CGContextRef cg_nullable c, CGFloat phase,
 const CGFloat * __nullable lengths, size_t count)
 */
@property (nonatomic, copy, nullable) NSArray<NSNumber *> *lineDashPattern;

/**
 The color shown for the portion of the circle slider that is filled.

 For top circle
 */
@property (nonatomic, strong) IBInspectable UIColor *sliderTintColor;

/**
 Width for borderColor
 */
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
/**
 Color for border circle
 */
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

/**
 The color shown for the portion of the circle slider that is not filled.

 If you set trackTintColor to nil, the track uses the tint of its parent.

 Color for background circle
 */
@property (nonatomic, strong) IBInspectable UIColor *trackTintColor;

/**
 Sets the slider’s current value, allowing you to animate the change visually.
 If you specify a value that is beyond the minimum or maximum values, the slider limits the value to the minimum or maximum. For example, if the minimum value is 0.0 and you specify -1.0, the slider sets the value property to 0.0.

 draw slider at ease in ease out with duration and depends on distance. does not send action

 @param value The new value to assign to the value property
 @param animated Specify YES to animate the change in value; otherwise, specify NO to update the slider’s appearance immediately. Animations are performed asynchronously and do not block the calling thread.
 */
- (void)setValue:(float)value animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
