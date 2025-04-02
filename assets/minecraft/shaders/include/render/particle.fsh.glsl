#version 140

#moj_import <minecraft:fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec2 texCoord0;
in vec4 vertexColor;

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

    if (color.a < 0.1) {
        discard;
    }
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}