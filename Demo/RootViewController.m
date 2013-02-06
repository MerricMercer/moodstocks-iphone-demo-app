/**
 * Copyright (c) 2013 Moodstocks SAS
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "RootViewController.h"

#import "MSAppDelegate.h"
#import "MSScannerController.h"

@interface RootViewController ()

- (void)scanAction;

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

#pragma mark - View lifecycle

- (void) loadView {
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = [UIColor whiteColor];

    CGFloat bw = 160.0;
    CGFloat bh = 40.0;
    CGFloat ww = self.view.frame.size.width;
    CGFloat hh = self.view.frame.size.height - 44.0;

    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanButton addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchDown];
    [scanButton setTitle:@"Scan" forState:UIControlStateNormal];
    scanButton.frame = CGRectMake(0.5 * (ww - bw), 0.5 * (hh - bh), bw, bh);
    [self.view addSubview:scanButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Demo";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI Actions

- (void)scanAction {
    MSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (!appDelegate.isScannerAvailable) {
        // NOTE: in a real application you may want to hide the ability to launch the scanner when the
        // device is not compatible
        [[[[UIAlertView alloc] initWithTitle:@"Error"
                                     message:@"Your device is not compatible with the Moodstocks SDK."
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil] autorelease] show];

        return;
    }

    MSScannerController *scannerController = [[MSScannerController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:scannerController];

    [self presentModalViewController:navController animated:YES];

    [scannerController release];
    [navController release];
}

@end
