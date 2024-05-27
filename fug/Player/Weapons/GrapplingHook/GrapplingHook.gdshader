shader_type canvas_item;

uniform float amplitude;
uniform float frequency;
uniform float speed;

const float n = 3.0;
const float c1 = 1.0;
const float c2 = 0.6;
const float c3 = 0.2;

float f(float c, float x) {
	return sin(c * x);
}

void fragment() {
	float x = FRAGCOORD.x * 6.28 * frequency + TIME * speed;
	
	float y = f(c1, x);
	// y += f(c2, x);
	// y += f(c3, x);
	y /= n;
	
	vec2 mod_uv = vec2(UV.x, UV.y + y * amplitude);
	COLOR = texture(TEXTURE, mod_uv);
}