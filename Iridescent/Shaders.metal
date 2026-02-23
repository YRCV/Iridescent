//
//  Shaders.metal
//  Iridescent
//
//  Created by Yahil Corcino on 2/23/26.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]] half4 cdIridescence(float2 position, half4 color, float2 size, float time){
    // normalize position to 0-1
    float2 uv = position / size;
    float2 centered = uv - 0.5;
    
    // angle from center for a sweep effect
    float angle = atan2(centered.y, centered.x);
    float dist = length(centered);
    
    // iridescence formula (convert angle to rad, factor in distance and time)
    float hue = fract(angle / (2.0 * M_PI_F) + dist * 2.0 + time * 0.2);
    
    // HSV to RGB
    float3 rgb = clamp(abs(fmod(hue * 6.0 + float3(0, 4, 2), 6.0) - 3.0) - 1.0, 0.0, 1.0);
    
    // the shader runs in every pixel in the bounding box
    // by multiplying by a (alpha/opacity), only the cd area have the shader
    return half4(half3(rgb), color.a);
    // return half4(0.0, 0.0, 1.0, color.a);
}


