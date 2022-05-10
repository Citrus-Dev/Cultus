// ESTE LO HICE YO JIJUJIJIUJUI
shader_type canvas_item;

uniform float freq = 5.0;
uniform bool instante;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (instante){
		COLOR.a = sign(sin(TIME * freq));
	} else {
		COLOR.a = abs(sin(TIME * freq));
	}
}
