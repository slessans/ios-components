//
//  SCLLayouUtils.h
//  Components
//
//  Created by Scott Lessans on 2/19/13.
//  Copyright (c) 2013 Scott Lessans. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Geometry
#define RECTCENTER(rect) CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))

#pragma mark - Constraints

// Center along axis
#define CENTER_VIEW_H(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]]
#define CENTER_VIEW_V(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]]
#define CENTER_VIEW(PARENT, VIEW) {CENTER_VIEW_H(PARENT, VIEW); CENTER_VIEW_V(PARENT, VIEW);}

// Align to parent
#define BIND_EDGE(PARENT, VIEW, EDGE, CONST) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute:EDGE relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:EDGE multiplier:1.0f constant:CONST]]

#define BIND_LEFT_EDGE_PAD(PARENT, VIEW, CONST) {BIND_EDGE(PARENT, VIEW, NSLayoutAttributeLeft, CONST);}
#define BIND_RIGHT_EDGE_PAD(PARENT, VIEW, CONST) {BIND_EDGE(PARENT, VIEW, NSLayoutAttributeRight, -CONST);}
#define BIND_TOP_EDGE_PAD(PARENT, VIEW, CONST) {BIND_EDGE(PARENT, VIEW, NSLayoutAttributeTop, CONST);}
#define BIND_BOTTOM_EDGE_PAD(PARENT, VIEW, CONST) {BIND_EDGE(PARENT, VIEW, NSLayoutAttributeBottom, -CONST);}

#define BIND_LEFT_EDGE(PARENT, VIEW) { BIND_LEFT_EDGE_PAD(PARENT, VIEW, 0); }
#define BIND_RIGHT_EDGE(PARENT, VIEW) { BIND_RIGHT_EDGE_PAD(PARENT, VIEW, 0); }
#define BIND_TOP_EDGE(PARENT, VIEW) { BIND_TOP_EDGE_PAD(PARENT, VIEW, 0); }
#define BIND_BOTTOM_EDGE(PARENT, VIEW) { BIND_BOTTOM_EDGE_PAD(PARENT, VIEW, 0); }

#define BIND_EDGES_PAD_H(PARENT, VIEW, PAD) {BIND_LEFT_EDGE_PAD(PARENT, VIEW, PAD); BIND_RIGHT_EDGE_PAD(PARENT, VIEW, PAD);}
#define BIND_EDGES_PAD_V(PARENT, VIEW, PAD) {BIND_TOP_EDGE_PAD(PARENT, VIEW, PAD); BIND_BOTTOM_EDGE_PAD(PARENT, VIEW, PAD);}

#define BIND_EDGES_H(PARENT, VIEW) {BIND_EDGES_PAD_H(PARENT, VIEW, 0);}
#define BIND_EDGES_V(PARENT, VIEW) {BIND_EDGES_PAD_V(PARENT, VIEW, 0);}

#define COVER(PARENT, VIEW) {BIND_EDGES_H(PARENT, VIEW); BIND_EDGES_V(PARENT, VIEW);}

// edges and cover for siblings
#define BIND_SIBLING_EDGE(PARENT, SIB1, SIB2, EDGE, CONST) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:SIB1 attribute:EDGE relatedBy:NSLayoutRelationEqual toItem:SIB2 attribute:EDGE multiplier:1.0f constant:CONST]]

#define BIND_SIBLING_LEFT_EDGE_PAD(PARENT, SIB1, SIB2, CONST) {BIND_SIBLING_EDGE(PARENT, SIB1, SIB2, NSLayoutAttributeLeft, CONST);}
#define BIND_SIBLING_RIGHT_EDGE_PAD(PARENT, SIB1, SIB2, CONST) {BIND_SIBLING_EDGE(PARENT, SIB1, SIB2, NSLayoutAttributeRight, -CONST);}
#define BIND_SIBLING_TOP_EDGE_PAD(PARENT, SIB1, SIB2, CONST) {BIND_SIBLING_EDGE(PARENT, SIB1, SIB2, NSLayoutAttributeTop, CONST);}
#define BIND_SIBLING_BOTTOM_EDGE_PAD(PARENT, SIB1, SIB2, CONST) {BIND_SIBLING_EDGE(PARENT, SIB1, SIB2, NSLayoutAttributeBottom, -CONST);}

#define BIND_SIBLING_LEFT_EDGE(PARENT, SIB1, SIB2) { BIND_SIBLING_LEFT_EDGE_PAD(PARENT, SIB1, SIB2, 0); }
#define BIND_SIBLING_RIGHT_EDGE(PARENT, SIB1, SIB2) { BIND_SIBLING_RIGHT_EDGE_PAD(PARENT, SIB1, SIB2, 0); }
#define BIND_SIBLING_TOP_EDGE(PARENT, SIB1, SIB2) { BIND_SIBLING_TOP_EDGE_PAD(PARENT, SIB1, SIB2, 0); }
#define BIND_SIBLING_BOTTOM_EDGE(PARENT, SIB1, SIB2) { BIND_SIBLING_BOTTOM_EDGE_PAD(PARENT, SIB1, SIB2, 0); }

#define BIND_SIBLING_EDGES_PAD_H(PARENT, SIB1, SIB2, PAD) {BIND_SIBLING_LEFT_EDGE_PAD(PARENT, SIB1, SIB2, PAD); BIND_SIBLING_RIGHT_EDGE_PAD(PARENT, SIB1, SIB2, PAD);}
#define BIND_SIBLING_EDGES_PAD_V(PARENT, SIB1, SIB2, PAD) {BIND_SIBLING_TOP_EDGE_PAD(PARENT, SIB1, SIB2, PAD); BIND_SIBLING_BOTTOM_EDGE_PAD(PARENT, SIB1, SIB2, PAD);}

#define BIND_SIBLING_EDGES_H(PARENT, SIB1, SIB2) {BIND_SIBLING_EDGES_PAD_H(PARENT, SIB1, SIB2, 0);}
#define BIND_SIBLING_EDGES_V(PARENT, SIB1, SIB2) {BIND_SIBLING_EDGES_PAD_V(PARENT, SIB1, SIB2, 0);}

#define COVER_SIBLINGS(PARENT, SIB1, SIB2) {BIND_SIBLING_EDGES_H(PARENT, SIB1, SIB2); BIND_SIBLING_EDGES_V(PARENT, SIB1, SIB2);}


// set size relative
#define BIND_SINGLE_ATTR(PARENT, VIEW, ATTR, MULT, CONST) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute:ATTR relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:ATTR multiplier:MULT constant:CONST]]

#define BIND_WIDTH(PARENT, VIEW, MULT) {BIND_SINGLE_ATTR(PARENT, VIEW, NSLayoutAttributeWidth, MULT, 0.0f);}
#define BIND_HEIGHT(PARENT, VIEW, MULT) {BIND_SINGLE_ATTR(PARENT, VIEW, NSLayoutAttributeHeight, MULT, 0.0f);}

// Set Size absolute
#define CONSTRAIN_SINGLE_ATTR(VIEW, ATTR, CONST) [VIEW addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute:ATTR relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:CONST]]

#define CONSTRAIN_SIZE_H(VIEW, SIZE) {CONSTRAIN_SINGLE_ATTR(VIEW, NSLayoutAttributeHeight, SIZE);}
#define CONSTRAIN_SIZE_W(VIEW, SIZE) {CONSTRAIN_SINGLE_ATTR(VIEW, NSLayoutAttributeWidth, SIZE);}
#define CONSTRAIN_SIZE(VIEW, WIDTH, HEIGHT) {CONSTRAIN_SIZE_H(VIEW, HEIGHT); CONSTRAIN_SIZE_W(VIEW, WIDTH);}

#define BIND_SELF_HEIGHT_TO_WIDTH(VIEW, RATIO) [VIEW addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:VIEW attribute:NSLayoutAttributeWidth multiplier:RATIO constant:0.0f]]

#define BIND_SELF_WIDTH_TO_HEIGHT(VIEW, RATIO) [VIEW addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:VIEW attribute:NSLayoutAttributeHeight multiplier:RATIO constant:0.0f]]

// setting constraints between siblings
#define BIND_SIBLING_VERTICAL_SPACING(PARENT, TOP_VIEW, BOTTOM_VIEW, SPACING) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:BOTTOM_VIEW attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:TOP_VIEW attribute:NSLayoutAttributeBottom multiplier:1.0f constant:SPACING]]

#define BIND_SIBLING_HORIZONTAL_SPACING(PARENT, LEFT_VIEW, RIGHT_VIEW, SPACING) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:LEFT_VIEW attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:RIGHT_VIEW attribute:NSLayoutAttributeLeft multiplier:1.0f constant:-SPACING]];

#define SCLNSNullForNil(obj) ((obj == nil) ? [NSNull null] : obj)

@interface SCLLayoutUtils : NSObject

@end











