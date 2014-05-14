//  HelpStack.m
//
//Copyright (c) 2014 HelpStack (http://helpstack.io)
//
//Permission is hereby granted, free of charge, to any person obtaining a cop
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

#import "HSHelpStack.h"


@interface HSHelpStack ()

@property (nonatomic, strong, readwrite) HSAppearance* appearance;

@end

@implementation HSHelpStack

/**
 Creates Singleton instance of class.
 **/
+ (id)instance {
    static HSHelpStack *helpStack = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helpStack = [[self alloc] init];
        helpStack.appearance = [HSAppearance instance];
        helpStack.requiresNetwork = YES;
        helpStack.showCredits = YES;
    });
    return helpStack;
}


- (void)setThemeFrompList:(NSString *)pListPath {
    [self.appearance setCustomThemeProperties:[self readThemePropertiesFrompList:pListPath]];
}

- (NSDictionary *)readThemePropertiesFrompList:(NSString *)pListPath {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:pListPath ofType:@"plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath]){
        NSDictionary *properties = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        return properties;
    }
    return nil;
}
/**
    start HelpStackController for given gear.
 */

- (void)showHelp:(UIViewController*)parentController {
    [self showHelp:parentController completion:nil];
}

- (void)showHelp:(UIViewController*)parentController completion:(void (^)(void))completion {
    
    UIViewController* mainController;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UIStoryboard* helpStoryboard = [UIStoryboard storyboardWithName:@"HelpStackStoryboard-iPad" bundle:[NSBundle mainBundle]];
        mainController = [helpStoryboard instantiateInitialViewController];
        [mainController setModalPresentationStyle:UIModalPresentationFormSheet];
        [parentController presentViewController:mainController animated:YES completion:completion];
        
    }
    else {
        UIStoryboard* helpStoryboard = [UIStoryboard storyboardWithName:@"HelpStackStoryboard" bundle:[NSBundle mainBundle]];
        mainController = [helpStoryboard instantiateInitialViewController];
        [parentController presentViewController:mainController animated:YES completion:completion];
    }
}



@end
