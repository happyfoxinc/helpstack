//
//  UIImage+Extended.m
//  HelpApp
//
//  Created by Anand on 05/11/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "UIImage+Extended.h"

@implementation UIImage (Extended)

- (NSString*)base64EncodedString
{
    NSData* imageencodedData = [UIImagePNGRepresentation(self) base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return [NSString stringWithUTF8String:[imageencodedData bytes]];
}

@end
