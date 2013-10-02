//
//  MQToolbar.m
//  SCL IOS Components
//
//  Created by Scott Lessans on 8/24/13.
//  Copyright (c) 2013 Scott Lessans. All rights reserved.
//

#import "SCLKeyboardToolbar.h"

static CGFloat const DefaultAccessoryBarHeight = 44.0f;
static CGFloat const DefaultAccessoryBarSidePadding = 0.0f;

@implementation SCLKeyboardToolbar

+ (instancetype) sclKeyboardToolbarWithOptions:(SCLKeyboardToolbarOptions)options
{
    
    const CGRect toolbarFrame = CGRectMake(0.0f, 0.0f, 0.0f, DefaultAccessoryBarHeight);
    SCLKeyboardToolbar * toolbar = [[self alloc] initWithFrame:toolbarFrame];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    // add items
    NSMutableArray * items = [[NSMutableArray alloc] initWithCapacity:7];
    
    const BOOL shouldShowPrevNext = ((options & SCLKeyboardToolbarOptionsNextPrevButton) != 0);
    const BOOL shouldShowDoneBtn = ((options & SCLKeyboardToolbarOptionsDoneButton) != 0);
    
    if ( shouldShowPrevNext ) {
        UISegmentedControl * prevNextControl = [[UISegmentedControl alloc] initWithItems:@[@"Previous", @"Next"]];
        prevNextControl.momentary = YES;
        
        UIBarButtonItem * prevNextBtnItem = [[UIBarButtonItem alloc] initWithCustomView:prevNextControl];
        
        UIBarButtonItem * leftSpacing =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                      target:nil
                                                      action:NULL];
        
        leftSpacing.width = DefaultAccessoryBarSidePadding;
        
        [items addObject:leftSpacing];
        [items addObject:prevNextBtnItem];
        
        toolbar.prevNextControl = prevNextControl;
        toolbar.prevNextBtnItem = prevNextBtnItem;
    }
    
    if ( shouldShowDoneBtn ) {
        
        UIBarButtonItem * leftSpace =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                      target:nil
                                                      action:NULL];
        
        UIBarButtonItem * rightSpace =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                      target:nil
                                                      action:NULL];
        rightSpace.width = DefaultAccessoryBarSidePadding;
        
        
        UIBarButtonItem * doneBtn =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                      target:nil
                                                      action:NULL];
        [items addObject:leftSpace];
        [items addObject:doneBtn];
        [items addObject:rightSpace];
        
        toolbar.doneButton = doneBtn;
    }    
    
    toolbar.items = items;
    
    return toolbar;
}

@end









