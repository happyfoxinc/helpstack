//
//  HAZendDeskArticleViewController.h
//  HelpApp
//
//  Created by Tenmiles on 22/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSKBItem.h"
#import "HSViewController.h"

/**
    Display given article on webView.
    
    In given article, if htmlContent is set, it is used by default or else it uses textContent.
 
    If a link is clicked, it is open in new window.
 */
@interface HSArticleDetailViewController : HSViewController

@property (nonatomic, strong) HSKBItem* article;

@end
