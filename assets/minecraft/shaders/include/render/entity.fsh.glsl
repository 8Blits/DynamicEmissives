#version 140

#moj_import <minecraft:fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform int FogShape;
uniform mat4 ProjMat;

in float vertexDistance;
in vec4 vertexColor;
in vec4 lightMapColor;
in vec4 overlayColor;
in vec2 texCoord0;
// Emissives START
in vec4 tintColor;
// Emissives END

out vec4 fragColor;

#moj_import <lib/dynamic_emissives/dynamic_emissives.glsl>

void main() {
    vec4 color = texture(Sampler0, texCoord0);
    color *= vertexColor * ColorModulator;
#ifndef NO_OVERLAY
    color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
#endif
#ifndef EMISSIVE
    color *= lightMapColor;
#endif

    // Emissives START
    vec4 pureColor = textureLod(Sampler0, texCoord0, 0.0);
    make_emissive(color, pureColor, tintColor);
    // Emissives END

#ifdef ALPHA_CUTOUT
    if (color.a < ALPHA_CUTOUT) {
        discard;
    }
#endif
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}