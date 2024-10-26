#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float3 color; // Pass color information to the fragment shader
};

vertex VertexOut vertex_main(const device float *vertexArray [[ buffer(0) ]],
                             uint vertexID [[ vertex_id ]]) {
    VertexOut out;
    out.position = float4(vertexArray[vertexID * 2], vertexArray[vertexID * 2 + 1], 0.0, 1.0);
    
    if (vertexID == 0) {
        out.color = float3(0.0, 1.0, 0.0); // hijau top
    } else if (vertexID == 1) {
        out.color = float3(1.0, 0.0, 0.0); // merah bottom left
    } else {
        out.color = float3(0.0, 0.0, 1.0); // biru bottom right
    }
    
    return out;
}

fragment float4 fragment_main(VertexOut in [[ stage_in ]]) {
    return float4(in.color, 1.0);
}
