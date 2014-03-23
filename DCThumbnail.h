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
    void (^_callback)(UIImage *);
    UIWebView *_webView;
    int framesLoaded;
}

-(id)initWithURL:(NSURL *)URL;
-(void)beginRenderingWithSize:(CGSize)size completion:(void (^)(UIImage *))completion;

@end