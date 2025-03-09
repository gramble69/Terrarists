shader_type sky;
render_mode use_half_res_pass;
uniform vec3 skyColor : source_color;
uniform vec3 horizonTexture : source_color;
uniform sampler2D skyTexture;

void sky() {
	float col  = clamp(EYEDIR.y / 0.05, 0.0, 1.0);
	vec3 finalColor  = mix(horizonTexture,skyColor,col);
	COLOR = texture(skyTexture,SKY_COORDS).rgb;
}
