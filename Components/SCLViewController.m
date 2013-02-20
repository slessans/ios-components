//
//  SCLViewController.m
//  Components
//
//  Created by Scott Lessans on 2/19/13.
//  Copyright (c) 2013 Scott Lessans. All rights reserved.
//

#import "SCLViewController.h"
#import "SCLLayoutUtils.h"

@interface SCLViewController ()

@property (nonatomic, strong) SCLTextFieldListViewController * tflvc;

@end

@implementation SCLViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    [self reloadFields];
}

#pragma mark text field delegate
// key NSString --> value NSString
// key is how you will refer to the text field, value is the display text
- (NSDictionary *) textFieldListViewControllerTextFields:(SCLTextFieldListViewController *)vc
{
    return @{
             @"name": @"Name",
             @"dob" : @"Date of Birth",
             @"hometown" : @"Hometown",
             @"rara" : @"Foo",
             @"rar2" : @"Bar",
             @"sdf" : @"Jah",
             @"blah" : @"Soldja"
             };
}

- (CGFloat) textFieldListViewControllerTopPadding:(SCLTextFieldListViewController *)vc
{
    return 50.0f;
}

- (CGFloat) textFieldListViewControllerBottomPadding:(SCLTextFieldListViewController *)vc
{
    return 20.0f;
}

- (CGFloat) textFieldListViewControllerSidePadding:(SCLTextFieldListViewController *)vc
{
    return 40.0f;
}

- (CGFloat) textFieldListViewControllerVerticalSpacing:(SCLTextFieldListViewController *)vc
{
    return 100.0f;
}

@end
