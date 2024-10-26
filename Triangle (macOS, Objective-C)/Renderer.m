#import "Renderer.h"

@implementation Renderer {
    id<MTLDevice> _device;
    id<MTLCommandQueue> _commandQueue;
    id<MTLBuffer> _vertexBuffer;
    id<MTLRenderPipelineState> _pipelineState;
}

const float vertices[] = {
    0.0f,  1.0f,
     -1.0f, -1.0f,
      1.0f, -1.0f  
};

- (instancetype)initWithView:(MTKView *)view {
    self = [super init];
    if (self) {
        _device = MTLCreateSystemDefaultDevice();
        view.device = _device;
        view.delegate = self;
        
        _commandQueue = [_device newCommandQueue];
        
        _vertexBuffer = [_device newBufferWithBytes:vertices
                                               length:sizeof(vertices)
                                              options:MTLResourceStorageModeShared];

        [self setupPipeline:view];
    }
    return self;
}

- (void)setupPipeline:(MTKView *)view {
    NSError *error = nil;

    id<MTLLibrary> library = [_device newDefaultLibrary];
    id<MTLFunction> vertexFunction = [library newFunctionWithName:@"vertex_main"];
    id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"fragment_main"];

    MTLRenderPipelineDescriptor *pipelineDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    pipelineDescriptor.vertexFunction = vertexFunction;
    pipelineDescriptor.fragmentFunction = fragmentFunction;
    pipelineDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat;

    _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];

    if (error) {
        NSLog(@"Error creating pipeline state: %@", error);
    }
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {}

- (void)drawInMTKView:(MTKView *)view {
    @autoreleasepool {
        id<CAMetalDrawable> drawable = [view currentDrawable];
        MTLRenderPassDescriptor *passDescriptor = view.currentRenderPassDescriptor;
        if (passDescriptor) {
            id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
            id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:passDescriptor];
            
            [renderEncoder setRenderPipelineState:_pipelineState];
            [renderEncoder setVertexBuffer:_vertexBuffer offset:0 atIndex:0];
            [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:3];
            [renderEncoder endEncoding];
            [commandBuffer presentDrawable:drawable];
            [commandBuffer commit];
        }
    }
}

@end
