//
//  DCThumnail.m
//  DCThumbnail
//
//  Created by Ishaan Gulrajani on 3/22/14.
//  Copyright (c) 2014 DeskConnnect. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "DCThumbnail.h"
#import "NSURL+DCUTI.h"
#import "DCUTI.h"
#import "UIImage-PDF/UIImage+PDF/UIImage+PDF.h"

@implementation DCThumbnail

-(id)initWithURL:(NSURL *)URL {
    self = [super init];
    if(self) {
        _URL = URL;
    }
    return self;
}

-(void)beginRenderingWithSize:(CGSize)size completion:(void (^)(UIImage *))completion failure:(void (^)())failure {
    if([_URL isFileURL]) {
        DCUTI *UTI = [_URL fileUTI];
        
        if([UTI conformsToUTI:[DCUTI UTIWithString:@"public.image"]]) {

            // Don't resize the image manually because UIImageView will do it more efficiently when it renders anyway
            completion([UIImage imageWithContentsOfFile:[_URL path]]);

        } else if([UTI conformsToUTI:[DCUTI UTIWithString:@"public.mpeg-4"]]) {

            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:_URL options:nil];
            AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
            generator.appliesPreferredTrackTransform = TRUE;

            // Take the thumbnail halfway through the video
            CMTime thumbTime = CMTimeMultiplyByRatio(asset.duration, 1, 2);
            
            CGFloat scale = [[UIScreen mainScreen] scale];
            generator.maximumSize = CGSizeMake(size.width * scale, size.height * scale);

            NSError *err;
            CGImageRef image = [generator copyCGImageAtTime:thumbTime actualTime:NULL error:&err];
            if(!err) {
                completion([UIImage imageWithCGImage:image]);
            } else {
                failure();
            }
            
        } else if([UTI conformsToUTI:[DCUTI UTIWithString:@"public.audio"]]) {
            
            AVAsset *asset = [AVURLAsset URLAssetWithURL:_URL options:nil];
            
            NSArray *keys = [NSArray arrayWithObjects:@"commonMetadata", nil];
            
            [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray *artworks = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata
                                                                       withKey:AVMetadataCommonKeyArtwork
                                                                      keySpace:AVMetadataKeySpaceCommon];
                    
                    for (AVMetadataItem *item in artworks) {
                        if ([item.keySpace isEqualToString:AVMetadataKeySpaceID3]) {
                            NSDictionary *dict = [item.value copyWithZone:nil];
                            completion([UIImage imageWithData:[dict objectForKey:@"data"]]);
                            return;
                        } else if ([item.keySpace isEqualToString:AVMetadataKeySpaceiTunes]) {
                            completion([UIImage imageWithData:[item.value copyWithZone:nil]]);
                            return;
                        }
                    }
                    
                    // Nothing found
                    failure();
                });
            }];
            
        } else if([UTI conformsToUTI:[DCUTI UTIWithString:@"com.adobe.pdf"]]) {
            
            UIImage *image = [UIImage imageWithPDFURL:_URL atWidth:size.width*[[UIScreen mainScreen] scale]];
            if(image)
                completion(image);
            else
                failure();
            
        } else if([UTI conformsToUTI:[DCUTI UTIWithString:@"public.composite-content"]]) {
            // Documents that aren't web pages, but that UIWebView can usually render (Office, iWork, etc.)
            
            [self setupWebViewRenderWithSize:size completion:completion failure:failure];
            [_webView loadRequest:[NSURLRequest requestWithURL:_URL]];
            
        } else {
            failure();
        }
        
    } else {
        // Web URL.
        [self setupWebViewRenderWithSize:size completion:completion failure:failure];
        [_webView loadRequest:[NSURLRequest requestWithURL:_URL]];
    }
}

#pragma mark - Web view rendering

-(void)setupWebViewRenderWithSize:(CGSize)size completion:(void (^)(UIImage *))completion failure:(void (^)())failure {
    // Create an offscreen UIWebView, load the thing, and take a screenshot when loading completes.
    _completion = completion;
    _failure = failure;
    
    CGFloat height = (320*size.height/size.width);
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(-320.0, -1*height, 320.0, height)];
    _webView.scalesPageToFit = YES;
    [[[UIApplication sharedApplication] keyWindow] addSubview:_webView];
    _webView.delegate = self;
}

-(void)cleanupWebViewRender {
    [_webView removeFromSuperview];
    _webView = nil;
    _completion = nil;
    _failure = nil;
    framesLoaded = 0;
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    framesLoaded++;

    // We want to avoid background web pages presenting alerts to the user
    [_webView stringByEvaluatingJavaScriptFromString:@"window.alert = null; window.prompt = null; window.confirm = null;"];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    framesLoaded--;
    if(framesLoaded == 0) {
        // This is such a hack.
        
        // We need to check whether the web view has finished rendering, which happens a few ms
        // after it's finished "loading" (i.e. this delegate method). There are ways of doing
        // this (e.g. check document.readyState in JS), but they're imperfect and not very reliable.
        // The best option seems to be just waiting for 200ms.
        
        // We're also rendering the sceenshot on a background thread, which isn't safe -- in theory,
        // this could crash, but from testing it doesn't seem to be a problem. If this starts crashing,
        // render on the main thread instead and you should be good.

        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
        dispatch_after(delay, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *screenshot = [DCThumbnail screenshotOfView:_webView];

            dispatch_async(dispatch_get_main_queue(), ^{
                _completion(screenshot);
                [self cleanupWebViewRender];
            });
        });
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    framesLoaded--;

    if(framesLoaded == 0) {
        if(_failure)
            _failure();
        [self cleanupWebViewRender];
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