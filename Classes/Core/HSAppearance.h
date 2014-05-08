//
//  HSAppearance.h
//  HelpApp
//
//  Created by Santhana Amuthan on 16/11/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSAppearance : NSObject

@property (nonatomic, strong) NSDictionary *customThemeProperties;

+ (id)instance;

- (UIColor *)getBackgroundColor;
- (void)customizeNavigationBar:(UINavigationBar *)navigationBar;
- (void)customizeTableView:(UITableView *)tableView;
- (void)customizeTableHeader:(UIView *)view;
- (void)customizeHeaderTitle:(UILabel *)title;
- (void)customizeCell:(UITableViewCell *)cell;
- (void)customizeTextLabel:(UILabel *)title;
- (void)customizeSmallTextLabel:(UILabel *)title;
- (void)customizeTextView:(UITextView *)textView;
- (void)customizeButton:(UIButton *)button;
- (void)customizeRightBubble:(UIView *)bubble;
- (void)customizeLeftBubble:(UIView *)bubble;
- (void)customizeBubbleText:(UITextView *)BubbleText;
- (UIFont *)getBubbleTextFont;
-(void)customizeRightBubbleText:(UITextView *)BubbleText;
-(void)customizeLeftBubbleText:(UITextView *)BubbleText;

+ (BOOL)isTall;
+ (BOOL)isIPad;
+ (BOOL)isIOS6;


@end
