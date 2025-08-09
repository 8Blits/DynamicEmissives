#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec2 texCoord1;
// Emissives START
in vec4 tintColor;
// Emissives END

out vec4 fragColor;

// Emissives START
#moj_import <lib/dynamic_emissives/dynamic_emissives.glsl>
// Emissives END

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    // Emissives START
    vec4 pureColor = textureLod(Sampler0, texCoord0, 0.0);
    make_emissive(color, pureColor, tintColor);
    // Emissives END

    if (color.a < 0.1) {
        discard;
    }
    fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}