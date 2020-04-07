#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float3 position  [[attribute(0)]];
};

struct VertexOut {
    float4 position [[position]];
};

struct Uniforms {
    // REVIEW: You MAY want to separate the model and view matrices. This is
    // more of a tradeoff, like, are you going to multiply more on the CPU or
    // the GPU (understanding that GPU multiplication is way faster).
    // Another possible tradeoff is how MUCH will you have to upload to the
    // GPU -- like, if you can keep something the same on the GPU, that's perf
    // savings. In this case, I think it's a wash either way, TBH. But something
    // to shelve for future reference, I guess.
    float4x4 modelViewMatrix;
    float4x4 projectionMatrix;
};

vertex VertexOut vertex_main(VertexIn vertexIn [[stage_in]],
                             constant Uniforms &uniforms [[buffer(1)]])
{
    VertexOut vertexOut;
    vertexOut.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * float4(vertexIn.position, 1);
    return vertexOut;
}

// REVIEW: A next step/feature would be to make the color also a uniform.
// But figure out how to make the model matrix a uniform first. ;)
fragment float4 fragment_main(VertexOut fragmentIn [[stage_in]]) {
    return float4(0.6, 0, 0, 1);
}
