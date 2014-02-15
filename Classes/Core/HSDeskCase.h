//
//  HSDeskCase.h
//  HelpApp
//
//  Created by Anand on 13/12/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSTicket.h"

@interface HSDeskCase : HSTicket <NSCoding>

@property (nonatomic, strong) NSString* apiHref;

@end
