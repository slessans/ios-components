//
//  SCLTextFieldListViewController.h
//  Components
//
//  Created by Scott Lessans on 2/19/13.
//  Copyright (c) 2013 Scott Lessans. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCLTextFieldListViewControllerDelegate;

// if not instantiated with nib, will create its own view
@interface SCLTextFieldListViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak, readonly) UIScrollView * scrollView;
@property (nonatomic, weak) IBOutlet id<SCLTextFieldListViewControllerDelegate> delegate;

- (void) reloadFields;

@end

@protocol SCLTextFieldListViewControllerDelegate <NSObject>

// key NSString --> value NSString
// key is how you will refer to the text field, value is the display text
- (NSDictionary *) textFieldListViewControllerTextFields:(SCLTextFieldListViewController *)vc;

@optional
// array of keys in order of test fields. if not all are specified, the unspecified fields
// will be places after the ordered fields in an unspecified order
- (NSArray *) textFieldListViewControllerTextFieldOrder:(SCLTextFieldListViewController *)vc;

// called before text fields are layed out or placed in the view. sizing and constraints will be overwritten
- (void) textFieldListViewController:(SCLTextFieldListViewController *)vc prepareTextField:(UITextField *)textField key:(NSString *)key displayName:(NSString *)displayName;

// called after text field is added to the view. be careful not to mess up the flow of the layout
- (void) textFieldListViewController:(SCLTextFieldListViewController *)vc didLayoutTextField:(UITextField *)textField key:(NSString *)key displayName:(NSString *)displayName;

// called after all text fields have been added to the view
- (void) textFieldListViewControllerDidFinishLayingOutTextFields:(SCLTextFieldListViewController *)vc;

// space between first text field and top of view
- (CGFloat) textFieldListViewControllerTopPadding:(SCLTextFieldListViewController *)vc;

// space between last text field and bottom of view
- (CGFloat) textFieldListViewControllerBottomPadding:(SCLTextFieldListViewController *)vc;

// padding between each side of text field and side of view
- (CGFloat) textFieldListViewControllerSidePadding:(SCLTextFieldListViewController *)vc;

// space between each text field
- (CGFloat) textFieldListViewControllerVerticalSpacing:(SCLTextFieldListViewController *)vc;

- (BOOL) textFieldListViewControllerDoesCloseKeyboardOnTap:(SCLTextFieldListViewController *)vc;
- (BOOL) textFieldListViewControllerDoesShowAccessoryBarView:(SCLTextFieldListViewController *)vc;
- (BOOL) textFieldListViewControllerAccessoryBarViewDoesShowPrevNext:(SCLTextFieldListViewController *)vc;
- (BOOL) textFieldListViewControllerAccessoryBarViewDoesShowClose:(SCLTextFieldListViewController *)vc;

// the bar's frame will be auto set after and the items will be cleared so pretty much just
// if you want to style it or use some sort of subclass
- (UIToolbar *) textFieldListViewControllerAccessoryViewBar:(SCLTextFieldListViewController *)vc;

// target and selector will be auto set after this method returns
- (UIBarButtonItem *) textFieldListViewControllerCloseButtonItem:(SCLTextFieldListViewController *)vc;

- (void) textFieldListViewControllerWillReloadFields:(SCLTextFieldListViewController *)vc;
- (void) textFieldListViewControllerDidReloadFields:(SCLTextFieldListViewController *)vc;

@end
