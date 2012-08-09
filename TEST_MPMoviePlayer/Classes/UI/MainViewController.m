//
//  MainViewController.m
//  TEST_MPMoviePlayer
//
//  Created by user on 04.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MainViewController ()

@property (nonatomic, retain) MPMoviePlayerController *player;

@end

@implementation MainViewController

@synthesize player = _player;

- (void)dealloc
{
    [_player release], _player = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setFrameForOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (self.player) {
        CGRect frame;
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
            frame = self.view.frame;            
        }
        else {
            frame.size.width = self.view.frame.size.height;
            frame.size.height = self.view.frame.size.width;
        }
        frame.origin = CGPointMake(0, 0);
        self.player.view.frame = frame;
    }
}

- (void)moviePlayerLoadStateChanged:(NSNotification*)notification
{
	// Unless state is unknown, start playback
	if ([self.player loadState] != MPMovieLoadStateUnknown) {
		// Remove observer
		[[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerLoadStateDidChangeNotification
                                                      object:nil];
        [self setFrameForOrientation:[UIDevice currentDevice].orientation];
		[self.view addSubview:[self.player view]];
        
		[self.player play];
	}
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{    
	// Remove observer
	[[NSNotificationCenter 	defaultCenter] removeObserver:self
                                                     name:MPMoviePlayerPlaybackDidFinishNotification 
                                                   object:nil];
    [self.player.view removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:path];
        
    self.player = [[[MPMoviePlayerController alloc] initWithContentURL:url] autorelease];
	
	if ([self.player respondsToSelector:@selector(loadState)]) {
//		self.player.controlStyle = MPMovieControlStyleDefault;
        self.player.controlStyle = MPMovieControlStyleNone;
		// May help to reduce latency
		[self.player prepareToPlay];
		// Register that the load state changed (movie is ready)
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(moviePlayerLoadStateChanged:) 
													 name:MPMoviePlayerLoadStateDidChangeNotification 
												   object:nil];
	}  
	// Register to receive a notification when the movie has finished playing. 
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(moviePlayBackDidFinish:) 
												 name:MPMoviePlayerPlaybackDidFinishNotification 
											   object:nil];    
    [self.player setFullscreen:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Allow only landscape modes
//	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    // rotation
    [self setFrameForOrientation:interfaceOrientation];
    return YES;
}

@end
