shader_type canvas_item;

uniform float wave_speed : hint_range(0.1, 5.0) = 1.0;
uniform float wave_frequency : hint_range(1.0, 20.0) = 5.0;
uniform float wave_amplitude : hint_range(0.0, 0.1) = 0.02;
uniform vec4 color1 : source_color = vec4(0.2, 0.8, 0.3, 1.0);
uniform vec4 color2 : source_color = vec4(0.1, 0.5, 0.1, 1.0);

void vertex() {
	VERTEX.y += sin(VERTEX.x * 0.05 + TIME * wave_speed) * wave_amplitude * 100.0;
}

void fragment() {
	float wave = sin(UV.x * wave_frequency + TIME * wave_speed) * 0.5 + 0.5;
	wave += sin(UV.y * wave_frequency * 0.5 - TIME * wave_speed * 0.7) * 0.5;
	
	COLOR = mix(color1, color2, wave);
}