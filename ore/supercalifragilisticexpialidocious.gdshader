shader_type canvas_item;

uniform float strength: hint_range(0., 1.) = 0.5;
uniform float speed: hint_range(0., 10.) = 0.5;
uniform float angle: hint_range(0., 360.) = 0.;
uniform bool enable_shader = true; // Add a boolean uniform variable to enable/disable the shader

void fragment() {
    // Get input color
    vec4 color = texture(TEXTURE, UV);
    
    // Check if the shader is enabled
    if (enable_shader) {
        // Convert UV coordinates to HSV space
        float hue = UV.x * cos(radians(angle)) - UV.y * sin(radians(angle));
        hue = fract(hue + fract(TIME * speed));
        
        // Calculate rainbow color based on hue
        float x = 1. - abs(mod(hue / (1. / 6.), 2.) - 1.);
        vec3 rainbow;
        if(hue < 1./6.) {
            rainbow = vec3(1., x, 0.);
        } else if (hue < 1./3.) {
            rainbow = vec3(x, 1., 0);
        } else if (hue < 0.5) {
            rainbow = vec3(0, 1., x);
        } else if (hue < 2./3.) {
            rainbow = vec3(0., x, 1.);
        } else if (hue < 5./6.) {
            rainbow = vec3(x, 0., 1.);
        } else {
            rainbow = vec3(1., 0., x);
        }
        
        // Calculate luminance
        float luminance = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
        
        // Apply rainbow effect only to white or near-white colors
        vec3 final_color = mix(color.rgb, rainbow, strength * smoothstep(0.9, 1.0, luminance));
        
        // Output final color
        COLOR = vec4(final_color, color.a);
    } else {
        // If the shader is disabled, output the input color directly
        COLOR = color;
    }
}
