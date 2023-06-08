#import "Basic";
#import "String";
#import "System";
#import "Math";
#import "File";
#import "Debug";
#import "Bit_Operations";

File_Watcher :: #import "File_Watcher";
#import "Vulkan";
#import "SDL";
#import "stb_image";
#import "stb_truetype";

#load "src/engine.jai";
#load "src/input.jai";
#if RENDERER == .OPENGL {
    #load "src/opengl/renderer.jai";
    #load "src/opengl/render_texture.jai";
    #load "src/opengl/shaders.jai";
} else #if RENDERER == .VULKAN {
    #load "src/vulkan/immediate.jai";
    #load "src/vulkan/renderer.jai";
    #load "src/vulkan/utils.jai";
    #load "src/vulkan/buffer.jai";
    #load "src/vulkan/texture.jai";
    #load "src/vulkan/color_pass.jai";
    #load "src/vulkan/2d_pass.jai";
}
#load "src/renderer/text.jai";
#load "src/camera.jai";
#load "src/console.jai";
#load "src/resources.jai";

#load "src/math/constants.jai";
#load "src/math/geometry.jai";
#load "src/math/gjk.jai";
#load "src/math/ray.jai";

RendererBackend :: enum {
    OPENGL;
    VULKAN;
}

#module_parameters (RENDERER : RendererBackend = .OPENGL);