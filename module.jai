#import "Basic";
#import "String";
#import "System";
#import "Math";
#import "File";
#import "Debug";
#import "Bit_Operations";
#import "Hash_Table";

File_Watcher :: #import "File_Watcher";
#import "SDL";
#import "stb_image";
#import,dir "modules/stb_truetype";

wgpu :: #import,dir "modules/WebGPU";
#load "src/rendering/backends/webgpu.jai";

#load "src/engine.jai";
#load "src/input.jai";
#load "src/camera.jai";
#load "src/console.jai";
#load "src/resources.jai";

#load "src/rendering/text.jai";
#load "src/rendering/immediate.jai";
// #load "src/mesh.jai";
// #load "src/skinned_mesh.jai";
// #load "src/scene.jai";

#import,dir "modules/gltf_parser";

#load "src/math/math.jai";
#load "src/math/constants.jai";
#load "src/math/geometry.jai";
#load "src/math/gjk.jai";
#load "src/math/ray.jai";
#load "src/tween.jai";

