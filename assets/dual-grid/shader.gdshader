// Based on jess::codes https://www.youtube.com/watch?v=eYlBociPwdw and https://www.youtube.com/watch?v=QB2o5Dys6Tc

shader_type canvas_item;

group_uniforms Foreground;
uniform sampler2D fg_overlay: repeat_enable, filter_nearest;
uniform vec4 fg_mask : source_color;
group_uniforms Background;
uniform sampler2D bg_overlay: repeat_enable, filter_nearest;
uniform vec4 bg_mask : source_color;
group_uniforms;
uniform float tolerance : hint_range(0, 1);

uniform float tile_size = 128.0;
varying vec2 world_position;

void vertex() {
    world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
    vec4 curr_color = texture(TEXTURE, UV);

    if (curr_color.a <= tolerance) {
        discard;
    }

    vec2 scaled_position = world_position / tile_size;
    vec4 fg_overlay_color = texture(fg_overlay, scaled_position);
	vec4 bg_overlay_color = texture(bg_overlay, scaled_position);

    float dist_fg = distance(curr_color.rgb, fg_mask.rgb);
	float dist_bg = distance(curr_color.rgb, bg_mask.rgb);
    if (dist_fg <= tolerance) {
        COLOR = fg_overlay_color;
    } else if (dist_bg <= tolerance) {
		COLOR = bg_overlay_color;
	}
}