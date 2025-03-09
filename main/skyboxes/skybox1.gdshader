shader_type sky;

uniform sampler2D skyTexture;
uniform vec3 horizonColor: source_color;
uniform vec3 skycolor : source_color;

void sky() {

	float col = clamp(EYEDIR.y / 0.05, 0.0, 1.0);
	vec3 finalColor = mix(horizonColor,skycolor,col);
	COLOR = texture(skyTexture, SKY_COORDS).rgb;
	// Called for every visible pixel in the sky background, as well as all pixels
	// in the radiance cubemap.
}
