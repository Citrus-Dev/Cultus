shader_type canvas_item;

uniform vec4 hit_color : hint_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float hit_strength : hint_range(0.0,1.0) = 0.0;
uniform bool efecto_flotar;
uniform float flotar_amplitud = 1.2;
uniform float flotar_velocidad = 5f;

void fragment() {
	vec4 custom_color = texture(TEXTURE, UV);
	custom_color.rgb = mix(custom_color.rgb, hit_color.rgb, hit_strength);
	COLOR = custom_color;
}

void vertex() {
	if (efecto_flotar){
		VERTEX.y = VERTEX.y + cos(TIME * flotar_velocidad) * flotar_amplitud;
		}
}