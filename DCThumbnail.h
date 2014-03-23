//
//  DCThumnail.h
//  DCThumbnail
//
//  Created by Ishaan Gulrajani on 3/22/14.
//  Copyright (c) 2014 DeskConnnect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCThumbnail : NSObject <UIWebViewDelegate> {
    NSURL *_URL;
    UIWebView *_webView;
    void (^_completion)(UIImage *);
    void (^_failure)();
    int framesLoaded;
}

-(id)initWithURL:(NSURL *)URL;
-(void)beginRenderingWithSize:(CGSize)size completion:(void (^)(UIImage *))completion failure:(void (^)())failure;

@end