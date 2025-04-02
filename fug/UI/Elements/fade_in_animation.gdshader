shader_type canvas_item;

// Overall 0..1 progress of the entire fade-in → visible → fade-out cycle
uniform float progress : hint_range(0.0, 1.0) = 0.0;

// How long (fraction of [0..1]) it takes to fully fade in
uniform float fade_in_time : hint_range(0.0, 1.0) = 0.15;
// How long (fraction of [0..1]) it takes to fully fade out
uniform float fade_out_time : hint_range(0.0, 1.0) = 0.15;

// Controls how "soft" the primary fade edges are (the blend range)
uniform float fade_range : hint_range(0.0, 1.0) = 0.02;

// the fragment UV does not represent the UV of the
// canvas_item rect but some uv of the font texture
// in order to get the canvas item UV the item size
// needs to be passed into the shader.
// https://github.com/godotengine/godot/issues/23210
uniform vec2 size; 

varying vec2 iuv;

void vertex () {
  iuv = VERTEX.xy / size;
}

// --------------------------------------------------------------
// Explanation of timing:
//  1) [0 .. fade_in_time] => Diagonal Fade-In (UV.x + UV.y from 0..2)
//  2) [fade_in_time .. 1 - fade_out_time] => Fully visible
//  3) [1 - fade_out_time .. 1] => Diagonal Fade-Out (UV.x + UV.y from 2..0)
// 
// We create a separate rainbow "fringe zone" that is larger than `fade_range`
// so that the color fringe extends beyond the normal fade boundary.
// --------------------------------------------------------------
void fragment() {
    // Sample the color & alpha from the text texture
    vec4 base_color = texture(TEXTURE, UV);

    // Calculate how much time is left for the "middle" portion
    float middle_time = 1.0 - (fade_in_time + fade_out_time);
    if (middle_time < 0.0) {
        // Edge case: sum of fade_in_time + fade_out_time > 1
        middle_time = 0.0;
    }

    // Force invisibility at progress extremes
    if (progress <= 0.0 || progress >= 1.0) {
        discard;
    }

    // Figure out how far along we are in fade in or fade out
    float fade_value = 0.0;
    if (progress < fade_in_time) {
        // Fade in: goes from 0..2 in diagonal space
        float ratio_in = progress / fade_in_time;   // 0..1
        fade_value = 2.0 * ratio_in;
    } else if (progress < fade_in_time + middle_time) {
        // Middle: full coverage
        fade_value = 2.0; 
    } else {
        // Fade out: goes from 2..0 in diagonal space
        float start_out = fade_in_time + middle_time;
        float ratio_out = (progress - start_out) / fade_out_time; // 0..1
        fade_value = 2.0 * (1.0 - ratio_out);  // 2..0
    }
	
	float diagonal;
    // Diagonal coordinate: top-left ~0.0 → bottom-right ~2.0
	if (progress > fade_in_time + middle_time) {
		diagonal = 1.0 - iuv.x + UV.y;
	} else {
		diagonal = iuv.x + UV.y;
	}
    
    //--------------------------------------------------------------
    // 1) Compute the normal fade alpha based on 'fade_range'.
    //--------------------------------------------------------------
    //   alpha_mask = 1 - ((diagonal - fade_value) / fade_range)
    //   but clamped 0..1
    //--------------------------------------------------------------
	float dist_fade = (diagonal - fade_value) / fade_range;

    float alpha_mask = clamp(1.0 - dist_fade, 0.0, 1.0);

    //--------------------------------------------------------------
    // 2) Compute a bigger region for a rainbow fringe.
    //    - We'll scale up the fade_range so the rainbow extends
    //      beyond the normal fade boundary.
    //--------------------------------------------------------------
    float RAINBOW_EXPANSION = 3.0;  // spread the rainbow ~3x bigger than the normal fade
    float dist_rainbow = (diagonal - fade_value) / (fade_range * RAINBOW_EXPANSION);
    // This goes 1 -> 0 across the rainbow band
    float rainbow_mask = clamp(1.0 - dist_rainbow, 0.0, 1.0);

    //--------------------------------------------------------------
    // 3) We'll define a "fringe factor" that is nonzero where
    //    rainbow_mask > alpha_mask. That zone is outside the
    //    main fade but still inside the bigger rainbow region.
    //--------------------------------------------------------------
    float fringe_factor = clamp(rainbow_mask - alpha_mask, 0.0, 1.0);

    //--------------------------------------------------------------
    // 4) Create some "fun" rainbow colors.
    //    - We'll do multiple sine waves, offset by ~120° each,
    //      with enough frequency to see a few stripes across
    //      the diagonal.
    //--------------------------------------------------------------
    float frequency = 8.0;  // more stripes across the diagonal
    float phase = 6.2831 * frequency * diagonal; 
    vec3 rainbow_color = vec3(
        0.5 + 0.5 * sin(phase),
        0.5 + 0.5 * sin(phase + 2.094),   // +120°
        0.5 + 0.5 * sin(phase + 4.188)    // +240°
    );

    //--------------------------------------------------------------
    // 5) Blend the base color with the rainbow in the fringe zone.
    //    - In the fully opaque zone, alpha_mask=1 => no rainbow.
    //    - In the fully transparent zone, alpha=0 => no effect 
    //      anyway, but we can see a bit of color near the edge 
    //      if the material behind it is visible.
    //--------------------------------------------------------------
    // Let's blend in the rainbow where fringe_factor > 0. 
    // You can multiply fringe_factor by a constant to boost color.
    //--------------------------------------------------------------
    vec3 final_rgb = mix(base_color.rgb, rainbow_color, fringe_factor);

    //--------------------------------------------------------------
    // 6) Combine with the text's original alpha using alpha_mask.
    //--------------------------------------------------------------
    float final_alpha = base_color.a * alpha_mask;

    // Output
    COLOR = vec4(final_rgb, final_alpha);
}
