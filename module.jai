#module_parameters(BACKEND := "WGPU");
#assert(is_constant(BACKEND));

#import "Basic";
#import "String";
#import "System";
#import "Math";
#import "File";
#import "Debug";
#import "Bit_Operations";
#import "Hash_Table";
#import,dir "modules/jaison";

File_Watcher :: #import "File_Watcher";
#load "modules/SDL3/module.jai";
#import "stb_image";
#import,dir "modules/stb_truetype";

#if BACKEND == "WGPU" {
    #load "src/rendering/backends/webgpu.jai";
} else #if BACKEND == "VULKAN" {
    #load "src/rendering/backends/vulkan.jai";
}

#load "src/engine.jai";
#load "src/input.jai";

#load "src/camera.jai";
#load "src/console.jai";
#load "src/resources.jai";

#load "src/rendering/text.jai";
#load "src/rendering/immediate.jai";
#load "src/rendering/mesh.jai";
#load "src/rendering/skinned_mesh.jai";
// #load "src/scene.jai";
#load "src/animation.jai";

#import,dir "modules/gltf_parser";

#load "src/math/math.jai";
#load "src/math/constants.jai";
#load "src/math/geometry.jai";
#load "src/math/gjk.jai";
#load "src/math/ray.jai";
#load "src/tween.jai";
#load "src/save.jai";
