shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back,diffuse_burley, specular_disabled, unshaded;

uniform sampler2D albedo : hint_default_black, source_color;

void fragment() {
	vec3 portal_color = texture(albedo, SCREEN_UV).rgb;
    ALBEDO = portal_color;
}