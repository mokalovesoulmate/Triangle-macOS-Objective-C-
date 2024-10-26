//
//  ViewController.m
//  Triangle (macOS, Objective-C)
//
//  Created by Moses Kurniawan on 26/10/2024.
//

#import "ViewController.h"
#import "Renderer.h"
#import <MetalKit/MetalKit.h>

@interface ViewController ()
@property (strong) Renderer *renderer;
@property (strong) MTKView *metalView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.metalView = [[MTKView alloc] initWithFrame:self.view.bounds];
    self.metalView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    self.metalView.device = MTLCreateSystemDefaultDevice();

    [self.view addSubview:self.metalView];

    self.renderer = [[Renderer alloc] initWithView:self.metalView];
}

@end
