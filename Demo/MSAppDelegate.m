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

#import "MSAppDelegate.h"

#import "RootViewController.h"

// Moodstocks SDK
#import "MSAvailability.h"
#import "MSDebug.h"
#import "MSScanner.h"

// -------------------------------------------------
// Moodstocks API key/secret pair
// -------------------------------------------------
#define MS_API_KEY @"ApIkEy"
#define MS_API_SEC @"ApIsEcReT"

@interface MSAppDelegate () <MSScannerDelegate>
- (void)scannerInit;
@end

@implementation MSAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize isScannerAvailable;
@synthesize scannerOpenError;
@synthesize scannerSyncError;

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Moodstocks SDK setup
    [self scannerInit];
    [self scannerSync];

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    RootViewController *rootViewController = [[[RootViewController alloc] init] autorelease];
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:rootViewController] autorelease];
    [self.window setRootViewController:self.navigationController];

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self scannerSync];
}

#pragma mark - Moodstocks SDK

- (void)scannerInit {
    isScannerAvailable = NO;
    scannerOpenError = -1;
    scannerSyncError = -1; // no sync yet
    if (MSDeviceCompatibleWithSDK()) {
#if MS_SDK_REQUIREMENTS
        isScannerAvailable = YES;
        scannerOpenError = MS_SUCCESS;
        NSError *err;
        MSScanner *scanner = [MSScanner sharedInstance];
        if (![scanner openWithKey:MS_API_KEY secret:MS_API_SEC error:&err]) {
            scannerOpenError = [err code];
            // == DO NOT USE IN PRODUCTION: THIS IS A HELP MESSAGE FOR DEVELOPERS
            if (scannerOpenError == MS_CREDMISMATCH) {
                NSString *errStr = @"there is a problem with your key/secret pair: "
                "the current pair does NOT match with the one recorded within the on-disk datastore. "
                "This could happen if:\n"
                " * you have first built & run the app without replacing the default"
                " \"ApIkEy\" and \"ApIsEcReT\" pair, and later on replaced it with your real key/secret,\n"
                " * or, you have first made a typo on the key/secret pair, built & run the"
                " app, and later on fixed the typo and re-deployed.\n"
                "\n"
                "To solve your problem:\n"
                " 1) uninstall the app from your device,\n"
                " 2) make sure to properly configure your key/secret pair within MSScanner.m\n"
                " 3) re-build & run\n";
                MSDLog(@"\n\n [MOODSTOCKS SDK] SCANNER OPEN ERROR: %@", errStr);

                // NOTE: we purposely crash the app here so that the developer detects the problem
                [[NSException exceptionWithName:@"MSScannerException"
                                         reason:@"Credentials mismatch"
                                       userInfo:nil] raise];
            }
            // == DO NOT USE IN PRODUCTION: THIS IS A HELP MESSAGE FOR DEVELOPERS
            else {
                MSDLog(@" [MOODSTOCKS SDK] SCANNER OPEN ERROR: %@", MSErrMsg(scannerOpenError));
            }
        }
#endif
    }
}

- (void)scannerSync {
#if MS_SDK_REQUIREMENTS
    MSScanner *scanner = [MSScanner sharedInstance];
    if ([scanner isSyncing]) return;
    [scanner syncWithDelegate:self];
#endif
}

- (void)scannerDidSync:(MSScanner *)scanner {
    scannerSyncError = MS_SUCCESS;
}

- (void)scanner:(MSScanner *)scanner failedToSyncWithError:(NSError *)error {
    ms_errcode ecode = [error code];
    if (ecode == MS_BUSY) return;
    scannerSyncError = ecode;
    MSDLog(@" [MOODSTOCKS SDK] SYNC ERROR: %@", MSErrMsg(ecode));
}

@end
