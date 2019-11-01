//
//  CrabsView.swift
//  No Need For Crabs
//
//  Created by Ryan on 10/31/19.
//  Copyright © 2019 Ryan Harper. All rights reserved.
//

import ScreenSaver
import Metal
import MetalKit

class CrabsView: ScreenSaverView {
    private let numberOfCrabs = 2
    private var positionX: [Int]
    private var positionY: [Int]
    private var flip: [Int]
    private let screenRatio: Float
    private let viewWidth: Int
    
    private var mtlDevice: MTLDevice!
    private var mtkView: MTKView!
    private var renderer: Renderer!
    
    // MARK: - Initialization
    override init?(frame: NSRect, isPreview: Bool) {
        positionX = [Int]()
        positionY = [Int]()
        flip = [-1, 1]
        screenRatio = Float(frame.width / frame.height)
        viewWidth = Int(200 * screenRatio + 15)
        
        positionX.append(Int.random(in: 0...200))
        positionX.append(Int.random(in: 0...200))
        positionY.append(Int.random(in: 0...4) * 20)
        positionY.append(Int.random(in: 5...9) * 20)
        
        super.init(frame: frame, isPreview: isPreview)
        self.animationTimeInterval = 1/24.0
        
        mtlDevice = MTLCreateSystemDefaultDevice()!
        mtkView = MTKView(frame: frame, device: mtlDevice)
        mtkView.enableSetNeedsDisplay = true
        mtkView.device = mtlDevice
        mtkView.colorPixelFormat = .bgra8Unorm
        mtkView.clearColor = MTLClearColorMake(0.0, 0.5, 1.0, 1.0)
        renderer = Renderer(view: mtkView)
        renderer.mtkView(mtkView, drawableSizeWillChange: mtkView.drawableSize)
        mtkView.delegate = renderer
    }

//    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func draw(_ rect: NSRect) {
        // Draw a single frame in this function
        renderer.draw(in: mtkView)
    }

    override func animateOneFrame() {
        super.animateOneFrame()
        
        positionX[0] += 1
        positionX[1] += 1
        
        for crab in 0..<numberOfCrabs {
            let framesBetweenFlips = 4
            if positionX[crab] % framesBetweenFlips == 0 {
                flip[crab] *= -1
            }
            
            if positionX[crab] > viewWidth {
                positionX[crab] = -15
                positionY[crab] = Int.random(in: 0...9) * 20
                if crab == 0 {
                    while positionY[0] == positionY[1] {
                        positionY[0] = Int.random(in: 0...9) * 20
                    }
                }
            } else if positionX[crab] < -15 {
                positionX[crab] = viewWidth
                positionY[crab] = Int.random(in: 0...9) * 20
                if crab == 1 {
                    while positionY[1] == positionY[0] {
                        positionY[1] = Int.random(in: 0...9) * 20
                    }
                }
            }
        }
    }

}
