//
//  Util.swift
//  No Need For Crabs
//
//  Created by Ryan on 11/4/19.
//  Copyright © 2019 Ryan Harper. All rights reserved.
//

import Foundation
import simd

extension float4x4 {
    init(scaleBy s: Float) {
        self.init(SIMD4<Float>(s, 0, 0, 0),
                  SIMD4<Float>(0, s, 0, 0),
                  SIMD4<Float>(0, 0, s, 0),
                  SIMD4<Float>(0, 0, 0, 1))
    }
    
    init(rotationAbout axis: SIMD3<Float>, by angleRadians: Float) {
        let x = axis.x, y = axis.y, z = axis.z
        let c = cosf(angleRadians)
        let s = sinf(angleRadians)
        let t = 1 - c
        self.init(SIMD4<Float>( t * x * x + c,     t * x * y + z * s, t * x * z - y * s, 0),
                  SIMD4<Float>( t * x * y - z * s, t * y * y + c,     t * y * z + x * s, 0),
                  SIMD4<Float>( t * x * z + y * s, t * y * z - x * s,     t * z * z + c, 0),
                  SIMD4<Float>(                 0,                 0,                 0, 1))
    }
    
    init(translationBy t: SIMD3<Float>) {
        self.init(SIMD4<Float>(   1,    0,    0, 0),
                  SIMD4<Float>(   0,    1,    0, 0),
                  SIMD4<Float>(   0,    0,    1, 0),
                  SIMD4<Float>(t[0], t[1], t[2], 1))
    }
    
    // orthographic projection
    init(left:Float, right:Float, bottom:Float, top:Float, near:Float, far:Float) {
        self.init(SIMD4<Float>(2/(right-left), 0, 0, 0),
                  SIMD4<Float>(0, 2/(top-bottom), 0, 0),
                  SIMD4<Float>(0, 0, -2/(far-near), 0),
                  SIMD4<Float>(-((right+left)/(right-left)), -((top+bottom)/(top-bottom)), -((far+near)/(far-near)), 1)
        )
    }
}

class Util {
    
}

struct Uniforms {
    var modelViewMatrix: float4x4
    var projectionMatrix: float4x4
}
