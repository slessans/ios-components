//
//  MQToolbar.m
//  SCL IOS Components
//
//  Created by Scott Lessans on 8/24/13.
//  Copyright (c) 2013 Scott Lessans. All rights reserved.
//

#import "SCLKeyboardToolbar.h"

CGFloat const SCLKeyboardToolbarHeight = 44.0f;
CGFloat const SCLKeyboardToolbarSidePadding = 0.0f;

@implementation SCLKeyboardToolbar

+ (instancetype) sclKeyboardToolbarWithOptions:(SCLKeyboardToolbarOptions)options
{
    
    const CGRect toolbarFrame = CGRectMake(0.0f, 0.0f, 0.0f, SCLKeyboardToolbarHeight);
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
        
        leftSpacing.width = SCLKeyboardToolbarSidePadding;
        
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
        rightSpace.width = SCLKeyboardToolbarSidePadding;
        
        
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

- (BOOL) previousButtonEnabled
{
    return [self.prevNextControl isEnabledForSegmentAtIndex:0];
}

- (BOOL) nextButtonEnabled
{
    return [self.prevNextControl isEnabledForSegmentAtIndex:1];
}

- (void) setPreviousButtonEnabled:(BOOL)previousButtonEnabled
{
    [self.prevNextControl setEnabled:previousButtonEnabled forSegmentAtIndex:0];
}

- (void) setNextButtonEnabled:(BOOL)nextButtonEnabled
{
    [self.prevNextControl setEnabled:nextButtonEnabled forSegmentAtIndex:1];
}

@end









