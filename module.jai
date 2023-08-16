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

#load "src/engine.jai";
#load "src/input.jai";

#import,dir "modules/Vulkan";
#load "src/vulkan/initialization.jai";
#load "src/vulkan/renderer.jai";
#load "src/vulkan/utils.jai";
#load "src/vulkan/buffer.jai";
#load "src/vulkan/buffer_pool.jai";
#load "src/vulkan/texture.jai";
#load "src/vulkan/pipelines.jai";
#load "src/vulkan/pipeline_builder.jai";
#load "src/vulkan/descriptor_set.jai";
#load "src/vulkan/swapchain.jai";

#load "src/renderer/text.jai";
#load "src/renderer/immediate.jai";
#load "src/camera.jai";
#load "src/console.jai";
#load "src/resources.jai";
#load "src/mesh.jai";
#load "src/skinned_mesh.jai";
#load "src/scene.jai";

#import,dir "modules/gltf_parser";

#load "src/math/math.jai";
#load "src/math/constants.jai";
#load "src/math/geometry.jai";
#load "src/math/gjk.jai";
#load "src/math/ray.jai";
#load "src/tween.jai";
