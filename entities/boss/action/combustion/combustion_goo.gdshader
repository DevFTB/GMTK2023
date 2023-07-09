shader_type canvas_item;


uniform sampler2D goo_texture : filter_nearest;

void fragment() {
	vec4 original = texture(TEXTURE, UV);
	
	
	COLOR *= vec4(texture(goo_texture, UV + vec2(cos(TIME), sin(TIME))* TEXTURE_PIXEL_SIZE * (1.0/0.4)).rgb, original.a * 0.7);
	
	// Place fragment code here.
}
