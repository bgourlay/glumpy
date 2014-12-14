// ----------------------------------------------------------------------------
// Copyright (c) 2014, Nicolas P. Rougier. All Rights Reserved.
// Distributed under the (new) BSD License.
// ----------------------------------------------------------------------------

// Externs
// ------------------------------------
// vec2 position;
// vec2 texcoord;
// float scale;
// vec3 origin;
// vec3 direction
// vec4 color;

// Varyings
// ------------------------------------
varying float v_scale;
varying vec2  v_texcoord;
varying vec4  v_color;


vec2 NDC_to_viewport(vec4 position, vec2 viewport)
{
    vec2 p = position.xy/position.w;
    return (p+1.0)/2.0 * viewport;
}


// Main
// ------------------------------------
void main()
{
    fetch_uniforms();

    vec3 tangent = normalize(direction);
    vec3 ortho   = cross(tangent, vec3(0,0,-1));
    vec3 P1 = origin + scale*(tangent*position.x + ortho*position.y);
    vec4 P1_ = <transform(P1)>;
    vec2 p1 = NDC_to_viewport(P1_, viewport.zw);

    // This compute an estimation of the actual size of the glyph
    vec3 P2 = origin + scale*(tangent*(position.x+64.0) + ortho*(position.y));
    vec4 P2_ = <transform(P2)>;
    vec2 p2 = NDC_to_viewport(P2_, viewport.zw);

    vec3 P3 = origin + scale*(tangent*(position.x) + ortho*(position.y+64.0));
    vec4 P3_ = <transform(P3)>;
    vec2 p3 = NDC_to_viewport(P3_, viewport.zw);

    float d2 = length(p2 - p1);
    float d3 = length(p3 - p1);
    v_scale = min(d2,d3);


    gl_Position = P1_;
    v_texcoord = texcoord;
    v_color = color;
}
