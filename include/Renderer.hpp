//
//  Renderer.h
//  phoenix-apple-components
//
//  Created by Bodie Solomon on 2/16/19.
//

#ifndef PHX_MTLP_Renderer_hpp
#define PHX_MTLP_Renderer_hpp

#include "PHXRenderer.hpp"

namespace mtlp {

    template <typename PR>
    class Renderer {
    public:
        Renderer(PR*);

        Renderer() = delete;
        Renderer(PR&) = delete;

        static void postHooks() noexcept(true);

        void update();
        void draw();
        void clear();

        void drawPoint(int x, int y, int color);

    private:
        // Note that PHXRenderer is a pure Objective-C interface, which must be
        // accessed in Objective-C ways.  Since the Phoenix host is pure C++,
        // and thus may only use the pmtl::Renderer class through its C++
        // interface, the Objective-C++ implementation is hidden.
        //
        // This also means that in order to handle iOS or macOS UI and OS
        // events, an Objective-C / Objective-C++ interface must be offered
        // through a wrapper for Phoenix itself; this interface is offered in
        // the PHXEventHandler class.
        PR* r;
    };

#include "Renderer_impl.hxx"

    using MetalRenderer = Renderer<PHXMetalRenderer>;
};

#endif /* PHX_MTLP_Renderer_hpp */
