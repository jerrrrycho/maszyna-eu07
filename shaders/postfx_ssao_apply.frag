in vec2 f_coords;
layout(location = 0) out vec4 out_color;

#texture (color_tex, 0, RGB)
uniform sampler2D color_tex;

#texture (ssao_tex, 1, R)
uniform sampler2D ssao_tex;

const float SSAO_STRENGTH = 0.8;
const float SSAO_MIN      = 0.3;   // floor on darkening so shadows don't go pitch black

void main() {
    vec3  c   = texture(color_tex, f_coords).rgb;
    float occ = texture(ssao_tex, f_coords).r;

    // remap occlusion with strength and a minimum floor
    occ = pow(clamp(occ, 0.0, 1.0), SSAO_STRENGTH);
    occ = mix(SSAO_MIN, 1.0, occ);

    out_color = vec4(c * occ, 1.0);
}