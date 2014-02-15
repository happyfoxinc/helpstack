//
//  HSTableView.h
//  HelpApp
//
//  Created by Santhana Amuthan on 19/12/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSHelpStack.h"

@interface HSTableView : UITableView


-(UIView *)getHeaderViewforFrame:(CGRect)frame forTitle:(NSString *)title;

@end
