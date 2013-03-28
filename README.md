# Moodstocks SDK - iPhone sample app

This demo application illustrates the setup and use of the Moodstocks SDK for iOS.

## Features

* This demo uses Moodstocks SDK for iOS and its iOS wrapper.
* It demonstrates in a simple context the use of Moodstocks SDK.
* It illustrates the best practices to build an application with the Moodstocks SDK: feel free to explore the code and use it as a reference to build your own application!

## Prerequisites

* An iOS development environment.
* A Moodstocks [ developer account ](https://developers.moodstocks.com/register).

## Usage

### 1. Setup the SDK

The Moodstocks SDK is not contained in this repo, but must be downloaded and set up following [this tutorial](https://developers.moodstocks.com/doc/tuto-ios/2).

### 2. Setup your credentials

Open `MSAppDelegate.m` and replace the two `MS_API_KEY` and `MS_API_SEC` fields with your own credentials:

```objective-c
  // -------------------------------------------------
  // Moodstocks API key/secret pair
  // -------------------------------------------------
  #define MS_API_KEY @"ApIkEy"
  #define MS_API_SEC @"ApIsEcReT"
```

### 3. Run the app

That's it: the Moodstocks demo application is ready to be launched and tried!

## Help

Need help? Check out our [Help Center](http://help.moodstocks.com/).

## Copyright

Copyright (c) 2013 [Moodstocks SAS](http://www.moodstocks.com)
