//
//  MQToolbar.h
//  Marquee
//
//  Created by Scott Lessans on 8/24/13.
//  Copyright (c) 2013 Marquee Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SCLKeyboardToolbarOptions) {
    SCLKeyboardToolbarOptionsDoneButton = 1,
    SCLKeyboardToolbarOptionsNextPrevButton = (1 << 1)
};

@interface SCLKeyboardToolbar : UIToolbar

+ (instancetype) sclKeyboardToolbarWithOptions:(SCLKeyboardToolbarOptions)options;

@property (nonatomic, weak) UIBarButtonItem * doneButton;

// prevNextBtnItem containts the prevNextControl as custom view
@property (nonatomic, weak) UIBarButtonItem * prevNextBtnItem;
@property (nonatomic, weak) UISegmentedControl * prevNextControl;

@end
