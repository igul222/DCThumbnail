//
//  DCThumbnailDetailViewController.m
//  DCThumbnail
//
//  Created by Ishaan Gulrajani on 3/22/14.
//  Copyright (c) 2014 DeskConnnect. All rights reserved.
//

#import "DCThumbnailDetailViewController.h"
#import "DCThumbnail.h"

@interface DCThumbnailDetailViewController ()

@end

@implementation DCThumbnailDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadURL:(NSURL *)URL {
    renderer = [[DCThumbnail alloc] initWithURL:URL];
    [renderer beginRenderingWithSize:CGSizeMake(200, 200) completion:^(UIImage *image) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        imageView.image = image;

        imageView.backgroundColor = [UIColor magentaColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.center = CGPointMake(round(self.view.bounds.size.width / 2), round(self.view.bounds.size.height / 2));

        [self.view addSubview:imageView];
    } failure:^{
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoa!"
                                                        message:@"The thumbnail failed to render."
                                                       delegate:nil
                                              cancelButtonTitle:@":("
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

@end
