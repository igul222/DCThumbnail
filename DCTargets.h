//
//  DCTargets.h
//  DeskConnect
//
//  Created by Ari on 11/27/13.
//  Copyright (c) 2013 Squish Software. All rights reserved.
//

// OS macros
#define DC_TARGET_IOS TARGET_OS_IPHONE
#define DC_TARGET_IOS_SIMULATOR TARGET_IPHONE_SIMULATOR
#define DC_TARGET_MAC (TARGET_OS_MAC && !TARGET_OS_IPHONE)
#define DC_TARGET_WINDOWS TARGET_OS_WIN32
#define DC_TARGET_ANDROID ANDROID

// Objective-C runtime types
#define DC_TARGET_LEGACY_RUNTIME (DC_TARGET_WINDOWS || (DC_TARGET_MAC && !__LP64__))
#define DC_TARGET_MODERN_RUNTIME !DC_TARGET_LEGACY_RUNTIME

// Cocoa target type macros
#define DC_TARGET_DESKTOP (DC_TARGET_MAC || DC_TARGET_WINDOWS)
#define DC_TARGET_MOBILE (DC_TARGET_IOS || DC_TARGET_ANDROID)

// Feature macros
#define HAVE_ICLOUD (MAC_SANDBOXED || DC_TARGET_IOS)
#define PRODUCTION_APNS TARGET_PRODUCTION

// Runtime macros
#define IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
