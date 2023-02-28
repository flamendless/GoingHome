extern Image u_tex_palette;

vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )
{
    vec4 index = Texel(tex, texture_coords);

    if (index.a == 0)
      discard;

    vec4 pixel = Texel(u_tex_palette, vec2(index.x, 1));

    return pixel * color;
}
