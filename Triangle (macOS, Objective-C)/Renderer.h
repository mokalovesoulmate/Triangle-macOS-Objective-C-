#import <Foundation/Foundation.h>
#import <MetalKit/MetalKit.h>

@interface Renderer : NSObject <MTKViewDelegate>

- (instancetype)initWithView:(MTKView *)view;

@end
