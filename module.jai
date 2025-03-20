// Included modules 
#import "Basic";
#import "String";
#import "System";
#import "Math";
#import "File";
#import "Debug";
#import "Bit_Operations";
#import "Hash_Table";
#import "Reflection";
#import "Print_Color";
File_Watcher :: #import "File_Watcher";

// Our modules
#import "stb_image";
#load "modules/SDL3/module.jai";
#import,dir "modules/stb_truetype";
#import,dir "modules/jaison";
#import,dir "modules/gltf_parser";

// Code
#load "src/engine.jai";
#load "src/input.jai";
#load "src/camera.jai";
#load "src/console.jai";
#load "src/resources.jai";
#load "src/math/math.jai";
#load "src/math/constants.jai";
#load "src/math/geometry.jai";
#load "src/math/gjk.jai";
#load "src/math/ray.jai";
#load "src/tween.jai";
#load "src/save.jai";
#load "src/rendering/renderer.jai";
#load "src/rendering/immediate.jai";
#load "src/rendering/shaders.jai";
#load "src/rendering/buffer.jai";
#load "src/rendering/pipeline_builder.jai";
#load "src/rendering/rendering.jai";
#load "src/rendering/text.jai";
#load "src/rendering/buffer_pool.jai";
#load "src/rendering/mesh.jai";
#load "src/transform.jai";
// #load "src/rendering/skinned_mesh.jai";
// #load "src/animation.jai";
