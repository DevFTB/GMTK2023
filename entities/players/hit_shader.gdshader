shader_type canvas_item;

uniform bool should_flash = true;
uniform float flash_speed = 0.2;
uniform vec4 flash_color : source_color;

void fragment() {
	vec4 previous = texture(TEXTURE, UV);
	vec4 flash = mix(previous, vec4(flash_color.rgb, previous.a), flash_color.a);
	if (should_flash == true) 
	{
		float y = sin(TIME * 1.0 / flash_speed);
		if (y > 0.0) {
			COLOR = flash;
		} else{
			COLOR = previous;
		}
	} else {
		COLOR = previous;
	}
}
