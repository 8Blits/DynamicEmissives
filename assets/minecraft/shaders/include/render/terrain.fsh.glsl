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
in vec2 texCoord0;

out vec4 fragColor;

// Emissives START
#moj_import <lib/dynamic_emissives/dynamic_emissives.glsl>
// Emissives END

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    // Emissives START
    vec4 pureColor = textureLod(Sampler0, texCoord0, 0.0);
    make_emissive(color, pureColor, vec4(1.0));
    // Emissives END

#ifdef ALPHA_CUTOUT
    if (color.a < ALPHA_CUTOUT) {
        discard;
    }
#endif
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}