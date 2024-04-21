// https://godotshaders.com/shader/crt-shader-2/

// Based on: https://www.shadertoy.com/view/Ms23DR
shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// Loosely based on postprocessing shader by inigo quilez, License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

vec2 curve(vec2 uv)
{
	uv = (uv - 0.5) * 2.0;
	uv *= 1.1;
	//
	uv.x *= 1.0 + pow((abs(uv.y) / 5.0), 2.0);
	uv.y *= 1.0 + pow((abs(uv.x) / 4.0), 2.0);
	//
	uv  = (uv / 2.0) + 0.5;
	uv =  uv * 0.92 + 0.04;
	return uv;
}
void fragment(  )
{
	// establishing things
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 q = FRAGCOORD.xy / iResolution.xy;
    vec2 uv = q;

	// applying curvature
    uv = curve( uv );

	// original color, unused
    //vec3 oricol = texture( screen_texture, vec2(q.x,q.y) ).xyz;
	
	// new output color
	vec3 col;

    col.r = texture(screen_texture,vec2(uv.x+0.001,uv.y+0.001)).x+0.05;
    col.g = texture(screen_texture,vec2(uv.x+0.000,uv.y-0.002)).y+0.05;
    col.b = texture(screen_texture,vec2(uv.x-0.002,uv.y+0.000)).z+0.05;
    col.r += 0.08*texture(screen_texture,0.75*vec2(0.025, -0.027)+vec2(uv.x+0.001,uv.y+0.001)).x;
    col.g += 0.05*texture(screen_texture,0.75*vec2(-0.022, -0.02)+vec2(uv.x+0.000,uv.y-0.002)).y;
    col.b += 0.08*texture(screen_texture,0.75*vec2(-0.02, -0.018)+vec2(uv.x-0.002,uv.y+0.000)).z;

	// brightening?
    col = clamp(col*0.6+0.4*col*col*1.0,0.0,1.0);

	// black vignette
    float vig = (0.0 + 1.0*16.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y));
	col *= vec3(pow(vig,0.3));

	// EXTENT OF PINK HUE
    col *= vec3(0.85,1.05,0.85);
	// brightening?
	col *= 2.8;

	// BLACK SCAN LINES
	float scans = clamp( 0.35+0.35*sin(3.5*TIME+uv.y*iResolution.y*1.5), 0.0, 1.0);
	float s = pow(scans,1.7);
	col = col*vec3( 0.4+0.7*s) ;

	// ABSOLUTE CORNER BLACKENING
    col *= 1.0+0.01*sin(110.0*TIME);
	if (uv.x < 0.0 || uv.x > 1.0)
		col *= 0.0;
	if (uv.y < 0.0 || uv.y > 1.0)
		col *= 0.0;
	
	// darkening?
	col*=1.0-0.65*vec3(clamp((mod(FRAGCOORD.x, 2.0)-1.0)*2.0,0.0,1.0));
	
	// final output
    COLOR = vec4(col,1.0);
}