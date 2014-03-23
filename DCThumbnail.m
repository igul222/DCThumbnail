//
//  DCThumnail.m
//  DCThumbnail
//
//  Created by Ishaan Gulrajani on 3/22/14.
//  Copyright (c) 2014 DeskConnnect. All rights reserved.
//

#import "DCThumbnail.h"
#import "NSURL+DCUTI.h"
#import "DCUTI.h"

@implementation DCThumbnail

-(id)initWithURL:(NSURL *)URL {
    self = [super init];
    if(self) {
        _URL = URL;
    }
    return self;
}

-(void)beginRenderingWithSize:(CGSize)size completion:(void (^)(UIImage *))completion {
    if([_URL isFileURL]) {
        DCUTI *UTI = [_URL fileUTI];
        if([UTI conformsToUTI:[DCUTI UTIWithString:@"public.image"]]) {
            // Don't resize the image manually because UIImageView will do it more efficiently when it renders anyway
            completion([UIImage imageWithContentsOfFile:[_URL path]]);
        }
    } else {
        // Web URL. Create an offscreen UIWebView, load the web page, and take a screenshot when loading completes.
        _callback = completion;
        CGFloat height = (320*size.height/size.width);
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(-320.0, -1*height, 320.0, height)];
        [[[UIApplication sharedApplication] keyWindow] addSubview:_webView];
        _webView.delegate = self;
        [_webView loadRequest:[NSURLRequest requestWithURL:_URL]];
    }
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    framesLoaded++;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    framesLoaded--;
    if(framesLoaded == 0) {
        
        // This is such a hack.
        
        // We need to check whether the web view has finished rendering, which happens a few ms
        // after it's finished "loading" (i.e. this delegate method). There are ways of doing
        // this (e.g. check document.readyState in JS), but they're imperfect and blocking. The best
        // option seems to be just waiting a second.
        
        // We're also rendering on a background thread, which isn't safe -- in theory, this could crash,
        // but from testing it doesn't seem to be a problem. If this starts crashing, render on the main
        // thread instead and you should be good.

        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
        dispatch_after(delay, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *screenshot = [DCThumbnail screenshotOfView:_webView];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _callback(screenshot);
                // cleanup
                [_webView removeFromSuperview];
                _webView = nil;
                _callback = nil;
            });
        });
    }
}

+(UIImage *)screenshotOfView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ([[NSThread currentThread] isMainThread] &&
        [view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        // iOS 7's method is a bit faster, but doesn't work at all in the background
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    } else {
        // ... not that iOS 6's method does work well in the background, but at least it kind of works
        [view.layer renderInContext:context];
    }
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenshot;
}

@end
