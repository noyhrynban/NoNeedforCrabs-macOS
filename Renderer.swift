import Foundation
import MetalKit
import simd

struct Uniforms {
    var modelViewMatrix: float4x4
    var projectionMatrix: float4x4
}

class Renderer: NSObject {
    let bundle: Bundle
    let device: MTLDevice
    let mtkView: MTKView
    let commandQueue: MTLCommandQueue
    var renderPipeline: MTLRenderPipelineState!
    var vertexDescriptor: MTLVertexDescriptor!
    var meshes: [MTKMesh] = []
    
    init(view: MTKView, device: MTLDevice) {
        self.mtkView = view
        self.device = device
        self.commandQueue = device.makeCommandQueue()!
        self.bundle = Bundle(for: Self.self)

        super.init()
        loadResources()
        buildPipeline()
    }
    
    func loadResources() {
        let crabModelURL = bundle.url(forResource: "crab", withExtension: "obj")!
        
        let vertexDescriptor = MDLVertexDescriptor()
        vertexDescriptor.attributes[0] = MDLVertexAttribute(name: MDLVertexAttributePosition, format: .float3, offset: 0, bufferIndex: 0)
        vertexDescriptor.attributes[1] = MDLVertexAttribute(name: MDLVertexAttributeNormal, format: .float3, offset: MemoryLayout<Float>.size * 3, bufferIndex: 0)
        vertexDescriptor.attributes[2] = MDLVertexAttribute(name: MDLVertexAttributeTextureCoordinate, format: .float2, offset: MemoryLayout<Float>.size * 6, bufferIndex: 0)
        vertexDescriptor.layouts[0] = MDLVertexBufferLayout(stride: MemoryLayout<Float>.size * 8)
        
        self.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(vertexDescriptor)
        
        let bufferAllocator = MTKMeshBufferAllocator(device: device)
        
        let asset = MDLAsset(url: crabModelURL, vertexDescriptor: vertexDescriptor, bufferAllocator: bufferAllocator)
        
        do {
            (_, meshes) = try MTKMesh.newMeshes(asset: asset, device: device)
        } catch {
            fatalError("Could not extract meshes from Model I/O asset")
        }
    }
    
    func buildPipeline() {
        guard let library = try? device.makeDefaultLibrary(bundle: bundle) else {
            fatalError("Could not load default library from main bundle")
        }
        
        let vertexFunction = library.makeFunction(name: "vertex_main")
        let fragmentFunction = library.makeFunction(name: "fragment_main")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        do {
            renderPipeline = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("Could not create render pipeline state object: \(error)")
        }
    }
    
    func ortho(left:Float, right:Float, bottom:Float, top:Float, near:Float, far:Float) -> float4x4 {
        return float4x4(
            SIMD4<Float>(2/(right-left), 0, 0, 0),
            SIMD4<Float>(0, 2/(top-bottom), 0, 0),
            SIMD4<Float>(0, 0, -2/(far-near), 0),
            SIMD4<Float>(-((right+left)/(right-left)), -((top+bottom)/(top-bottom)), -((far+near)/(far-near)), 1)
        )
    }
    
    func draw(crabs:[Crab]) {
        let commandBuffer = commandQueue.makeCommandBuffer()!
        
        if let renderPassDescriptor = mtkView.currentRenderPassDescriptor, let drawable = mtkView.currentDrawable {
            let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!

            for crab in crabs {
                let identity = float4x4(
                    SIMD4<Float>(1,0,0,0),
                    SIMD4<Float>(0,1,0,0),
                    SIMD4<Float>(0,0,1,0),
                    SIMD4<Float>(0,0,0,1)
                )
                
                let aspectRatio = Float(mtkView.drawableSize.width / mtkView.drawableSize.height)

                var mvMatrix = identity
                mvMatrix *= float4x4(translationBy: SIMD3<Float>(Float(crab.xPosition), Float(crab.yPosition), -7))
                mvMatrix *= float4x4(rotationAbout: SIMD3<Float>(0, 1, 0), by: Float.pi * Float(crab.flip ? 0 : 1))
                mvMatrix *= float4x4(translationBy: SIMD3<Float>(-15.5, 0, 0))
                
                let projectionMatrix = ortho(left: 0, right: 200 * aspectRatio, bottom: 0, top: 200, near: -1, far: 10)
                var uniforms = Uniforms(modelViewMatrix: mvMatrix, projectionMatrix: projectionMatrix)
                
                commandEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.size, index: 1)
                
                commandEncoder.setRenderPipelineState(renderPipeline)
                commandEncoder.setCullMode(MTLCullMode.back)
                
                for mesh in meshes {
                    let vertexBuffer = mesh.vertexBuffers.first!
                    commandEncoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index: 0)
                    
                    for submesh in mesh.submeshes {
                        let indexBuffer = submesh.indexBuffer
                        commandEncoder.drawIndexedPrimitives(type: submesh.primitiveType,
                                                             indexCount: submesh.indexCount,
                                                             indexType: submesh.indexType,
                                                             indexBuffer: indexBuffer.buffer,
                                                             indexBufferOffset: indexBuffer.offset)
                    }
                }
            }
            commandEncoder.endEncoding()
            commandBuffer.present(drawable)
            commandBuffer.commit()
        }
    }
}
