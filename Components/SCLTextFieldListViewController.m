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

@interface SCLTextFieldListViewController ()

@property (nonatomic, weak) UIScrollView * scrollView;
@property (nonatomic, strong) NSMutableArray * textFields;
@property (nonatomic, strong) NSMutableDictionary * textFieldDictionary;
@property (nonatomic, readonly) CGFloat topPadding;
@property (nonatomic, readonly) CGFloat bottomPadding;
@property (nonatomic, readonly) CGFloat sidePadding;
@property (nonatomic, readonly) CGFloat verticalSpacing;

- (void) setupTextFields;
- (void) setupScrollView;
- (void) setupSpacingMetrics;
- (void) validate;
- (void) addTextFieldWithKey:(NSString *)key
                 displayText:(NSString *)displayText;
- (UITextField *) makeNewTextField;

- (BOOL) shouldCloseKeyboardOnTap;
- (BOOL) shouldShowAccessoryBarView;
- (BOOL) accessoryBarViewShouldShowPreviousAndNext;
- (BOOL) accessoryBarViewShouldShowCloseButton;
- (UIBarButtonItem *) closeButtonItemForAccessoryView;

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

- (void) validate
{
    if ( ! self.delegate ) {
        NSString * reason = [NSString stringWithFormat:@"In %@ no delegate is set when viewDidLoad is called.", self];
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:reason
                                     userInfo:nil];
    }
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

- (void) setupScrollView
{
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:scrollView];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;    
    scrollView.backgroundColor = [UIColor greenColor];
    COVER(self.view, scrollView);
    self.scrollView = scrollView;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // if not valid will throw exception
    [self validate];
    
    // setup
    [self setupSpacingMetrics];
    [self setupScrollView];
    [self setupTextFields];
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
        BIND_BOTTOM_EDGE_PAD(self.scrollView, lastField, [self bottomPadding]);
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
        // no previous so align to top of view
        BIND_TOP_EDGE_PAD(self.scrollView, textField, [self topPadding]);
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
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    return textField;
}

@end
