//
//  Shaders.metal
//  Iridescent
//
//  Created by Yahil Corcino on 2/23/26.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// HSV to RGB function

float3 hsv2rgb(float3 c){
    // offsets for each color on the color wheel
    float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    
    // c.xxx represents the hue, swizzling
    // K.xyz each offset is added to the hue
    float3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

[[ stitchable ]] half4 cdIridescence(float2 position, half4 color, float2 size, float time){
    // normalize position to 0-1
    float2 uv = position / size;
    float2 centered = uv - 0.5;
    
    // distance from center, angle is direcition -pi to pi aroudn the disk
    float angle = atan2(centered.y, centered.x);
    float dist = length(centered);
    
    // groove pattern, higher dist = more rings
    float grooves = sin(dist * 0.80 + angle * 2.0) * 0.5 + 0.5;
    
    // iridescence formula (convert angle to rad, factor in distance and time)
    float hue = fract(angle / (2.0 * M_PI_F) + dist * 1.5 + grooves * 0.3 + time * 0.15);
    
    // saturation drops near the center, making it more silver
    float saturation = smoothstep(0.05, 0.25, dist) * 0.99;
    
    float specular = pow(1.0 - dist * 1.2, 3.0) * 0.1;
    float brightnes = 0.6 + specular + grooves * 0.15;
    
    float3 rgb = hsv2rgb(float3(hue, saturation, brightnes));
    
    // fresnel edge darkening near the edge
    //float fresnel = smoothstep(0.5, 0.15, dist);
    //rgb *= fresnel;
    
    // silver base
    float3 silver = float3(0.8, 0.8, 0.85);
    rgb = mix(silver, rgb, 0.55);
    
    // the shader runs in every pixel in the bounding box
    return half4(half3(rgb) * color.a, color.a);
    // return half4(0.0, 0.0, 1.0, color.a);
}


