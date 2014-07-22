attribute vec2 position;

varying vec4 f_color;

uniform float scale_x;

void main(void) {
    gl_Position = vec4(position.x * scale_x, position.y, 0, 1);
    f_color = vec4(position.xy / 2.0 + 0.5, 1, 1);
}