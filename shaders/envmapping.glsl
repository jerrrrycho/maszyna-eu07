#if ENVMAP_ENABLED
uniform samplerCube envmap;
#endif

vec3 envmap_color( vec3 normal )
{
#if ENVMAP_ENABLED
	vec3 refvec = reflect(f_pos.xyz, normal); // view space
	refvec = vec3(inv_view * vec4(refvec, 0.0)); // world space
	vec3 envcolor = texture(envmap, refvec).rgb;
#else
	vec3 envcolor = vec3(0.5);
#endif
	return envcolor;
}

// Roughness-aware env map lookup — uses mip levels for blurry reflections.
// lod 0.0 = mirror sharp, lod ~8.0 = fully diffuse blur.
vec3 envmap_color_lod(vec3 fragnormal, float lod)
{
#if ENVMAP_ENABLED
    vec3 refvec = reflect(f_pos.xyz, fragnormal); // view space — matches envmap_color exactly
    refvec = vec3(inv_view * vec4(refvec, 0.0));  // world space — was missing
    return textureLod(envmap, refvec, lod).rgb;
#else
    return vec3(0.5); // was vec3(0.0), match the non-LOD fallback
#endif
}