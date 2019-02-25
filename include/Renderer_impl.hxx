//
//  Renderer_impl.hxx
//  phoenix-apple-components
//
//  Created by Bodie Solomon on 2/16/19.
//

#ifndef PHX_MTLP_Renderer_impl_hxx
#define PHX_MTLP_Renderer_impl_hxx

template <typename PR>
Renderer<PR>::Renderer(PR* pr): r(pr) {};

template <typename PR>
void Renderer<PR>::postHooks() noexcept(true) {
    [PR postHooks];
};

template <typename PR>
void Renderer<PR>::update() {
    [r update];
}

template <typename PR>
void Renderer<PR>::draw() {
    [r draw];
}

template <typename PR>
void Renderer<PR>::clear() {
    [r clear];
}

template <typename PR>
void Renderer<PR>::drawPoint(int x, int y, int color) {

    double red = static_cast<double>((color & 0xFF000000) >> 6),
        green = static_cast<double>((color & 0x00FF0000) >> 4),
        blue = static_cast<double>((color & 0x0000FF00) >> 2),
        alpha = static_cast<double>(color & 0x000000FF);

    [r drawPointAt:simd_int2{x, y}
         withColor:MTLClearColorMake(red, green, blue, alpha)];
}

#endif /* PHX_MTLP_Renderer_impl_hxx */
