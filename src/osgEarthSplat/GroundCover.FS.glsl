#version $GLSL_VERSION_STR
#pragma vp_name       Land cover billboard texture application
#pragma vp_entryPoint oe_GroundCover_fragment
#pragma vp_location   fragment_coloring

#pragma import_defines(OE_GROUNDCOVER_HAS_MULTISAMPLES)
#pragma import_defines(OE_IS_SHADOW_CAMERA)

uniform sampler2DArray oe_GroundCover_billboardTex;
uniform float oe_GroundCover_exposure;

in vec2 oe_GroundCover_texCoord;

flat in float oe_GroundCover_atlasIndex; // from GroundCover.GS.glsl

// stage globals
float oe_roughness;
float oe_ambientOcclusion;
uniform float ao;

void oe_GroundCover_fragment(inout vec4 color)
{
    if (oe_GroundCover_atlasIndex < 0.0)
        discard;

    // modulate the texture
    color = texture(oe_GroundCover_billboardTex, vec3(oe_GroundCover_texCoord, oe_GroundCover_atlasIndex)) * color;
    color.rgb *= oe_GroundCover_exposure;

    oe_roughness = ao;
    oe_ambientOcclusion = 0.5;
    
    // if multisampling is off, use alpha-discard.
#if !defined(OE_GROUNDCOVER_HAS_MULTISAMPLES) || defined(OE_IS_SHADOW_CAMERA)
    if (color.a < 0.15)
        discard;
#endif
}
