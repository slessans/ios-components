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
    return @{@"fire" : @"first on the",
             @"a" : @"sdfsdf",
             @"foo" : @"var"};
}

- (UIView *) textFieldListViewControllerFooterView:(SCLTextFieldListViewController *)vc
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    CONSTRAIN_SIZE_H(view, 100.0f);
    view.backgroundColor = [UIColor redColor];
    return nil;
}

- (UIView *) textFieldListViewControllerHeaderView:(SCLTextFieldListViewController *)vc
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    CONSTRAIN_SIZE_H(view, 100.0f);
    view.backgroundColor = [UIColor blueColor];
    return view;
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
