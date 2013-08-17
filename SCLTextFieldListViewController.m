//
//  SCLTextFieldListViewController.m
//  Components
//
//  Created by Scott Lessans on 2/19/13.
//  Copyright (c) 2013 Scott Lessans. All rights reserved.
//

#import "SCLTextFieldListViewController.h"
#import "SCLLayoutUtils.h"

static CGFloat const TopPaddingDefault = 11.0f;
static CGFloat const BottomPaddingDefault = TopPaddingDefault;
static CGFloat const SidePaddingDefault = 7.0f;
static CGFloat const VerticalSpacingDefault = 7.0f;
static CGFloat const DefaultAccessoryBarHeight = 44.0f;
static CGFloat const DefaultAccessoryBarSidePadding = 0.0f;

@interface SCLTextFieldListViewController ()

@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UIView * footerView;
@property (nonatomic, strong) UITapGestureRecognizer * tapRecognizer;
@property (nonatomic, strong) UISegmentedControl * prevNextControl;
@property (nonatomic, weak) UITextField * currentTextField;
@property (nonatomic, weak) UIScrollView * scrollView;
@property (nonatomic, strong) NSMutableArray * textFields;
@property (nonatomic, strong) NSMutableDictionary * textFieldDictionary;
@property (nonatomic, readonly) CGFloat topPadding;
@property (nonatomic, readonly) CGFloat bottomPadding;
@property (nonatomic, readonly) CGFloat sidePadding;
@property (nonatomic, readonly) CGFloat verticalSpacing;
@property (nonatomic, strong) UIToolbar * textFieldAccessoryViewBar;

- (void) setupTextFields;
- (void) setupScrollView;
- (void) setupSpacingMetrics;
- (void) setupAccessoryViewBar;
- (void) setupTapToExit;
- (void) setupHeaderAndFooterViews;

- (void) addTextFieldWithKey:(NSString *)key
                 displayText:(NSString *)displayText;

- (UITextField *) makeNewTextField;
- (BOOL) shouldCloseKeyboardOnTap;
- (BOOL) shouldShowAccessoryBarView;
- (BOOL) accessoryBarViewShouldShowPreviousAndNext;
- (BOOL) accessoryBarViewShouldShowCloseButton;
- (UIBarButtonItem *) closeButtonItemForAccessoryView;

- (void) closeKeyboardAction:(id)sender;
- (void) keyboardPreviousAction:(id)sender;
- (void) keyboardNextAction:(id)sender;
- (void) prevNextControlAction:(id)sender;
- (void) returnKeyAction:(id)sender;

- (void) closeKeyboardAction:(id)sender isLastField:(BOOL)isLast;

@end

@implementation SCLTextFieldListViewController

- (BOOL) shouldCloseKeyboardOnTap
{
    if ( [self.delegate respondsToSelector:@selector(textFieldListViewControllerDoesCloseKeyboardOnTap:)] ) {
        return [self.delegate textFieldListViewControllerDoesCloseKeyboardOnTap:self];
    }
    return YES;
}

- (BOOL) shouldShowAccessoryBarView
{
    if ( [self.delegate respondsToSelector:@selector(textFieldListViewControllerDoesShowAccessoryBarView:)] ) {
        return [self.delegate textFieldListViewControllerDoesShowAccessoryBarView:self];
    }
    return YES;
}

- (BOOL) accessoryBarViewShouldShowPreviousAndNext
{
    if ( [self.delegate respondsToSelector:@selector(textFieldListViewControllerAccessoryBarViewDoesShowPrevNext:)] ) {
        return [self.delegate textFieldListViewControllerAccessoryBarViewDoesShowPrevNext:self];
    }
    return YES;
}

- (BOOL) accessoryBarViewShouldShowCloseButton
{
    if ( [self.delegate respondsToSelector:@selector(textFieldListViewControllerAccessoryBarViewDoesShowClose:)] ) {
        return [self.delegate textFieldListViewControllerAccessoryBarViewDoesShowClose:self];
    }
    return YES;
}

- (NSString *) stringValueForTextFieldWithKey:(NSString *)key
{
    return ((UITextField *)self.textFieldDictionary[key]).text;
}

- (void) setStringValue:(NSString *)value forTextFieldWithKey:(NSString *)key
{
    ((UITextField *)self.textFieldDictionary[key]).text = value;
}

- (UIBarButtonItem *) closeButtonItemForAccessoryView
{
    UIBarButtonItem * button = nil;
    if ( [self.delegate respondsToSelector:@selector(textFieldListViewControllerCloseButtonItem:)] ) {
        button = [self.delegate textFieldListViewControllerCloseButtonItem:self];
    }
    if ( ! button ) {
        button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                               target:nil
                                                               action:nil];
    }
    return button;
}

- (void) setupSpacingMetrics
{
    _topPadding = TopPaddingDefault;
    _bottomPadding = BottomPaddingDefault;
    _sidePadding = SidePaddingDefault;
    _verticalSpacing = VerticalSpacingDefault;
    
    if ( [self.delegate respondsToSelector:@selector(textFieldListViewControllerTopPadding:)] ) {
        _topPadding = [self.delegate textFieldListViewControllerTopPadding:self];
    }
    
    if ( [self.delegate respondsToSelector:@selector(textFieldListViewControllerBottomPadding:)] ) {
        _bottomPadding = [self.delegate textFieldListViewControllerBottomPadding:self];
    }
    
    if ( [self.delegate respondsToSelector:@selector(textFieldListViewControllerSidePadding:)] ) {
        _sidePadding = [self.delegate textFieldListViewControllerSidePadding:self];
    }
    
    if ( [self.delegate respondsToSelector:@selector(textFieldListViewControllerVerticalSpacing:)] ) {
        _verticalSpacing = [self.delegate textFieldListViewControllerVerticalSpacing:self];
    }
    
}

- (void) setupTapToExit
{
    if ( self.tapRecognizer ) {
        [self.view removeGestureRecognizer:self.tapRecognizer];
        self.tapRecognizer = nil;
    }
    
    if ( ! [self shouldCloseKeyboardOnTap] ) return;
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(closeKeyboardAction:)];
    self.tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:self.tapRecognizer];
}

- (void) setupScrollView
{
    if ( self.scrollView ) return;
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:scrollView];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;    
    scrollView.backgroundColor = [UIColor greenColor];
    COVER(self.view, scrollView);
    self.scrollView = scrollView;
}

- (void) setupAccessoryViewBar
{
    if ( ! [self shouldShowAccessoryBarView] ) {
        self.textFieldAccessoryViewBar = nil;
        return;
    }
    
    // make a new toolbar
    CGRect toolbarFrame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, DefaultAccessoryBarHeight);
    UIToolbar * toolbar = nil;
    if ( [self.delegate respondsToSelector:@selector(textFieldListViewControllerAccessoryViewBar:)] ) {
        toolbar = [self.delegate textFieldListViewControllerAccessoryViewBar:self];
        toolbar.frame = toolbarFrame;
    }
    
    if ( ! toolbar ) {
        toolbar = [[UIToolbar alloc] initWithFrame:toolbarFrame];
        toolbar.barStyle = UIBarStyleBlackTranslucent;
    }
    
    // add items
    NSMutableArray * items = [[NSMutableArray alloc] initWithCapacity:7];
    
    if ( [self accessoryBarViewShouldShowPreviousAndNext] ) {
        self.prevNextControl = [[UISegmentedControl alloc] initWithItems:@[@"Previous", @"Next"]];
        self.prevNextControl.segmentedControlStyle = UISegmentedControlStyleBar;
        self.prevNextControl.momentary = YES;
        [self.prevNextControl addTarget:self
                                 action:@selector(prevNextControlAction:)
                       forControlEvents:UIControlEventValueChanged];
        UIBarButtonItem * prevNextBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.prevNextControl];
        
        UIBarButtonItem * leftSpacing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                      target:nil
                                                                                      action:NULL];
        leftSpacing.width = DefaultAccessoryBarSidePadding;
        
        [items addObject:leftSpacing];
        [items addObject:prevNextBtnItem];
    }
    
    if ( [self accessoryBarViewShouldShowCloseButton] ) {
        UIBarButtonItem * leftSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                    target:nil
                                                                                    action:NULL];
        UIBarButtonItem * rightSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                     target:nil
                                                                                     action:NULL];
        rightSpace.width = DefaultAccessoryBarSidePadding;
        UIBarButtonItem * closeBtn = [self closeButtonItemForAccessoryView];
        closeBtn.target = self;
        closeBtn.action = @selector(closeKeyboardAction:);
        
        
        [items addObject:leftSpace];
        [items addObject:closeBtn];
        [items addObject:rightSpace];
    }
    
    toolbar.items = items;
    self.textFieldAccessoryViewBar = toolbar;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self setupScrollView];
    [self reloadFields];
}

- (void) setupHeaderAndFooterViews
{
    if ( self.headerView ) [self.headerView removeFromSuperview];
    if ( self.footerView ) [self.footerView removeFromSuperview];
    self.headerView = nil;
    self.footerView = nil;
    
    UIView * headerView = nil;
    UIView * footerView = nil;
    if ( [self.delegate respondsToSelector:@selector(textFieldListViewControllerHeaderView:)] ) {
        headerView = [self.delegate textFieldListViewControllerHeaderView:self];
    }
    if ( [self.delegate respondsToSelector:@selector(textFieldListViewControllerFooterView:)] ) {
        footerView = [self.delegate textFieldListViewControllerFooterView:self];
    }
    
    // constrain header and footer views
    if ( headerView ) {
        [self.scrollView addSubview:headerView];
        headerView.translatesAutoresizingMaskIntoConstraints = NO;
        BIND_TOP_EDGE(self.scrollView, headerView);
        BIND_EDGES_H(self.view, headerView);
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:headerView
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationLessThanOrEqual
                                                                       toItem:self.scrollView
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0f
                                                                     constant:0.0f]];
    }
    
    if ( footerView ) {
        [self.scrollView addSubview:footerView];
        footerView.translatesAutoresizingMaskIntoConstraints = NO;
        BIND_BOTTOM_EDGE(self.scrollView, footerView);
        BIND_EDGES_H(self.view, footerView);
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:footerView
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                       toItem:self.scrollView
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f
                                                                     constant:0.0f]];
    }
    
    if ( headerView && footerView ) {
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:headerView
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationLessThanOrEqual
                                                                       toItem:footerView
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f
                                                                     constant:0.0f]];
    }
    
    self.headerView = headerView;
    self.footerView = footerView;
}

- (void) reloadFields
{
    if ( [self.delegate respondsToSelector:@selector(textFieldListViewControllerWillReloadFields:)] ) {
        [self.delegate textFieldListViewControllerWillReloadFields:self];
    }
    
    // reset
    self.currentTextField = nil;
    self.textFieldDictionary = nil;
    
    // remove fields
    for ( UITextField * textField in self.textFields ) [textField removeFromSuperview];
    self.textFields = nil;
    
    // setup
    [self setupSpacingMetrics];
    [self setupHeaderAndFooterViews];
    [self setupAccessoryViewBar];
    [self setupTapToExit];
    [self setupTextFields];
    
    if ( [self.delegate respondsToSelector:@selector(textFieldListViewControllerDidReloadFields:)] ) {
        [self.delegate textFieldListViewControllerDidReloadFields:self];
    }
}

- (void) setupTextFields
{
    // setup ivars
    NSMutableDictionary * fields = [[NSMutableDictionary alloc] initWithDictionary:[self.delegate textFieldListViewControllerTextFields:self]];
    self.textFields = [[NSMutableArray alloc] initWithCapacity:[fields count]];
    self.textFieldDictionary = [[NSMutableDictionary alloc] initWithCapacity:[fields count]];
    
    // go through and add text fields starting with the optionally specified order
    NSArray * orderedFields = nil;
    if ( [self.delegate respondsToSelector:@selector(textFieldListViewControllerTextFieldOrder:)] ) {
        orderedFields = [self.delegate textFieldListViewControllerTextFieldOrder:self];
    }
    
    // add ordered fields
    for ( NSString * fieldKey in orderedFields ) {
        NSString * displayName = fields[fieldKey];
        if ( displayName ) {
            [fields removeObjectForKey:fieldKey];
            [self addTextFieldWithKey:fieldKey
                          displayText:displayName];
        }
    }
    
    // add rest of fields
    [fields enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * displayText, BOOL *stop) {
        [self addTextFieldWithKey:key displayText:displayText];
    }];
    
    // align bottom of last field to bottom of container
    UITextField * lastField = [self.textFields lastObject];
    if ( lastField ) {
        if ( self.footerView ) {
            BIND_SIBLING_VERTICAL_SPACING(self.scrollView, lastField, self.footerView, [self bottomPadding]);
        } else {
            BIND_BOTTOM_EDGE_PAD(self.scrollView, lastField, [self bottomPadding]);
        }
        
        // make return key type according to delegate
        UIReturnKeyType type = UIReturnKeyDone; // default
        if ( [self.delegate respondsToSelector:@selector(textFieldListViewControllerFinalReturnKeyType:)] ) {
            type = [self.delegate textFieldListViewControllerFinalReturnKeyType:self];
        }
        lastField.returnKeyType = type;
    }
    
    // alert delegate
    if ( [self.delegate respondsToSelector:@selector(textFieldListViewControllerDidFinishLayingOutTextFields:)] ) {
        [self.delegate textFieldListViewControllerDidFinishLayingOutTextFields:self];
    }
}

- (void) addTextFieldWithKey:(NSString *)key
                 displayText:(NSString *)displayText
{
    if ( self.textFieldDictionary[key] != nil ) {
        // already contains key, don't add
        NSLog(@"Warning in %@ %s trying to add text field for key %@ (display name %@), but already exists!",
              NSStringFromClass([self class]),
              __PRETTY_FUNCTION__,
              key,
              displayText);
        return;
    }
    
    UITextField * textField = [self makeNewTextField];
    if ( [self.delegate respondsToSelector:@selector(textFieldListViewController:prepareTextField:key:displayName:)] ) {
        [self.delegate textFieldListViewController:self
                                  prepareTextField:textField
                                               key:key
                                       displayName:displayText];
    }
    
    // control
    textField.inputAccessoryView = self.textFieldAccessoryViewBar;
    textField.returnKeyType = UIReturnKeyNext;
    textField.delegate = self;
    [textField addTarget:self
                  action:@selector(returnKeyAction:)
        forControlEvents:UIControlEventEditingDidEndOnExit];
    
    // constraints
    [self.scrollView addSubview:textField];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    
    // bind sides to side of view
    BIND_EDGES_PAD_H(self.view, textField, [self sidePadding]);
    
    // bind top
    UITextField * previousTextField = [self.textFields lastObject];
    if ( previousTextField ) {
        // bind to bottom of previous field
        BIND_SIBLING_VERTICAL_SPACING(self.scrollView, previousTextField, textField, [self verticalSpacing]);
    } else {
        // no previous so align to top of view or header if there is one
        if ( self.headerView ) {
            // align to bottom of header
            BIND_SIBLING_VERTICAL_SPACING(self.scrollView, self.headerView, textField, [self topPadding]);
        } else {
            // align to top of container
            BIND_TOP_EDGE_PAD(self.scrollView, textField, [self topPadding]);
        }
    }
    
    self.textFieldDictionary[key] = textField;
    [self.textFields addObject:textField];

    if ( [self.delegate respondsToSelector:@selector(textFieldListViewController:didLayoutTextField:key:displayName:)] ) {
        [self.delegate textFieldListViewController:self
                                didLayoutTextField:textField
                                               key:key
                                       displayName:displayText];
    }
    
}

- (UITextField *) makeNewTextField
{
    UITextField * textField = nil;
    
    if ( [self.delegate respondsToSelector:@selector(textFieldListViewControllerMakeTextField:)] ) {
        textField = [self.delegate textFieldListViewControllerMakeTextField:self];
    }
    
    if ( ! textField ) {
        textField = [[UITextField alloc] initWithFrame:CGRectZero];
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }
    
    return textField;
}

#pragma mark actions
- (void) closeKeyboardAction:(id)sender isLastField:(BOOL)isLast
{
    [self.currentTextField resignFirstResponder];
    
    const CGFloat maxScroll = MAX(self.scrollView.contentSize.height - self.scrollView.frame.size.height, 0);
    if ( self.scrollView.contentOffset.y > maxScroll ) {
        [self.scrollView setContentOffset:CGPointMake(0, maxScroll)
                                 animated:YES];
    }
}

- (void) closeKeyboardAction:(id)sender
{
    [self closeKeyboardAction:sender isLastField:NO];
}

- (void) keyboardPreviousAction:(id)sender
{
    if ( ! self.currentTextField ) return;
    NSInteger index = [self.textFields indexOfObject:self.currentTextField];
    if ( index != NSNotFound && (index - 1) >= 0 ) {
        [self.currentTextField resignFirstResponder];
        self.currentTextField = self.textFields[index - 1];
        [self.currentTextField becomeFirstResponder];
    }
}

- (void) keyboardNextAction:(id)sender
{
    if ( ! self.currentTextField ) return;
    NSInteger index = [self.textFields indexOfObject:self.currentTextField];
    if ( index != NSNotFound && (index + 1) < [self.textFields count] ) {
        [self.currentTextField resignFirstResponder];
        self.currentTextField = self.textFields[index + 1];
        [self.currentTextField becomeFirstResponder];
    }
}

- (void) prevNextControlAction:(id)sender
{
    if ( self.prevNextControl.selectedSegmentIndex == 0 ) {
        [self keyboardPreviousAction:sender];
    } else {
        [self keyboardNextAction:sender];
    }
}

- (void) returnKeyAction:(id)sender
{
    if ( sender == [self.textFields lastObject] ) {
        [self closeKeyboardAction:sender isLastField:YES];
        if ( [self.delegate respondsToSelector:@selector(textFieldListViewControllerDidReturnOnLastField:)] ) {
            [self.delegate textFieldListViewControllerDidReturnOnLastField:self];
        }
    } else {
        [self keyboardNextAction:sender];
    }
}

#pragma mark text field delegate
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    NSInteger index = [self.textFields indexOfObject:textField];
    if ( index == NSNotFound ) return;
    
    BOOL isFirst = (index == 0);
    BOOL isLast = ((index + 1) == [self.textFields count]);
    
    self.currentTextField = textField;
    [self.prevNextControl setEnabled:!isFirst forSegmentAtIndex:0];
    [self.prevNextControl setEnabled:!isLast forSegmentAtIndex:1];

    if ( self.currentTextField ) {
        [self.scrollView setContentOffset:CGPointMake(0, MAX(self.currentTextField.frame.origin.y - [self topPadding], 0))
                                 animated:YES];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    self.currentTextField = nil;
}

@end






