
#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float3 position  [[attribute(0)]];
};

struct VertexOut {
    float4 position [[position]];
};

struct Uniforms {
    float4x4 modelViewMatrix;
    float4x4 projectionMatrix;
};

vertex float4 vertexShader(VertexIn vertexIn [[stage_in]],
                           constant Uniforms &uniforms [[buffer(1)]])
{
    return uniforms.projectionMatrix * uniforms.modelViewMatrix * float4(vertexIn.position, 1);
}

fragment float4 fragmentShader() {
    return float4(0.6, 0, 0, 1);
}
