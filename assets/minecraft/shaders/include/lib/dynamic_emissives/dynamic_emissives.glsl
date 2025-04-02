#version 140 // Lowering version fixed some platform specific issues

/**
 * © 8Blits - 2025
 */

// Macro for transparent emissives config
#define DYNAMIC_EMISSIVE(a) return true; case a: color.rgb = emissiveColor; 

float remap_alpha(int inputAlpha) {
    if (inputAlpha == 252) return 255.0;
    
    return float(inputAlpha);
}

#ifdef FSH
/**
 * @param color - the target color
 * @param pureColor - the target color, but disregards the mipmap to prevent imprecisions
 * @param tintColor - tint from armor & leather_horse_armor
 */
bool make_emissive(inout vec4 color, vec4 pureColor, vec4 tintColor) {
    vec3 emissiveColor = pureColor.rgb * tintColor.rgb;
    int alpha = int(round(pureColor.a * 255.0));
    color.a = remap_alpha(alpha) / 255.0;

    switch (alpha) {
        case 252:
            color.rgb = emissiveColor;
    #moj_import<config/dynamic_emissives_config.glsl>
        return true;
    }

    return false;
}
#endif