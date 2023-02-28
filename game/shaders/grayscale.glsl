vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec4 px = Texel(tex, texture_coords);
    float ave = 0.299 * px.r + 0.587 * px.g + 0.114 * px.b;
    px.r = ave;
    px.g = ave;
    px.b = ave;
    return px;
}
