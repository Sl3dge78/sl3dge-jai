//
// This file was auto-generated using the following command:
//
// jai generate.jai
//



NO_SDL_VULKAN_TYPEDEFS :: 1;
SDL_SHADERCROSS_MAJOR_VERSION :: 3;
SDL_SHADERCROSS_MINOR_VERSION :: 0;
SDL_SHADERCROSS_MICRO_VERSION :: 0;
SDL_ShaderCross_ShaderStage :: enum s32 {
    VERTEX   :: 0;
    FRAGMENT :: 1;
    COMPUTE  :: 2;

    SDL_SHADERCROSS_SHADERSTAGE_VERTEX   :: VERTEX;
    SDL_SHADERCROSS_SHADERSTAGE_FRAGMENT :: FRAGMENT;
    SDL_SHADERCROSS_SHADERSTAGE_COMPUTE  :: COMPUTE;
}
SDL_ShaderCross_GraphicsShaderInfo :: struct {
    numSamplers:        Uint32;
    numStorageTextures: Uint32;
    numStorageBuffers:  Uint32;
    numUniformBuffers:  Uint32;
}
SDL_ShaderCross_ComputePipelineInfo :: struct {
    numSamplers:                 Uint32;
    numReadOnlyStorageTextures:  Uint32;
    numReadOnlyStorageBuffers:   Uint32;
    numReadWriteStorageTextures: Uint32;
    numReadWriteStorageBuffers:  Uint32;
    numUniformBuffers:           Uint32;
    threadCountX:                Uint32;
    threadCountY:                Uint32;
    threadCountZ:                Uint32;
}
SDL_ShaderCross_Init :: () -> bool #foreign sdl3_shadercross;
SDL_ShaderCross_Quit :: () -> void #foreign sdl3_shadercross;
SDL_ShaderCross_GetSPIRVShaderFormats :: () -> SDL_GPUShaderFormat #foreign sdl3_shadercross;
SDL_ShaderCross_TranspileMSLFromSPIRV :: (bytecode: *Uint8, bytecodeSize: u64, entrypoint: *u8, shaderStage: SDL_ShaderCross_ShaderStage) -> *void #foreign sdl3_shadercross;
SDL_ShaderCross_TranspileHLSLFromSPIRV :: (bytecode: *Uint8, bytecodeSize: u64, entrypoint: *u8, shaderStage: SDL_ShaderCross_ShaderStage) -> *void #foreign sdl3_shadercross;
SDL_ShaderCross_CompileDXBCFromSPIRV :: (bytecode: *Uint8, bytecodeSize: u64, entrypoint: *u8, shaderStage: SDL_ShaderCross_ShaderStage, size: *u64) -> *void #foreign sdl3_shadercross;
SDL_ShaderCross_CompileDXILFromSPIRV :: (bytecode: *Uint8, bytecodeSize: u64, entrypoint: *u8, shaderStage: SDL_ShaderCross_ShaderStage, size: *u64) -> *void #foreign sdl3_shadercross;
SDL_ShaderCross_CompileGraphicsShaderFromSPIRV :: (device: *SDL_GPUDevice, bytecode: *Uint8, bytecodeSize: u64, entrypoint: *u8, shaderStage: SDL_GPUShaderStage, info: *SDL_ShaderCross_GraphicsShaderInfo) -> *SDL_GPUShader #foreign sdl3_shadercross;
SDL_ShaderCross_CompileComputePipelineFromSPIRV :: (device: *SDL_GPUDevice, bytecode: *Uint8, bytecodeSize: u64, entrypoint: *u8, info: *SDL_ShaderCross_ComputePipelineInfo) -> *SDL_GPUComputePipeline #foreign sdl3_shadercross;
SDL_ShaderCross_ReflectGraphicsSPIRV :: (bytecode: *Uint8, bytecodeSize: u64, info: *SDL_ShaderCross_GraphicsShaderInfo) -> bool #foreign sdl3_shadercross;
SDL_ShaderCross_ReflectComputeSPIRV :: (bytecode: *Uint8, bytecodeSize: u64, info: *SDL_ShaderCross_ComputePipelineInfo) -> bool #foreign sdl3_shadercross;
SDL_ShaderCross_GetHLSLShaderFormats :: () -> SDL_GPUShaderFormat #foreign sdl3_shadercross;
SDL_ShaderCross_CompileDXBCFromHLSL :: (hlslSource: *u8, entrypoint: *u8, includeDir: *u8, defines: **u8, numDefines: Uint32, shaderStage: SDL_ShaderCross_ShaderStage, size: *u64) -> *void #foreign sdl3_shadercross;
SDL_ShaderCross_CompileDXILFromHLSL :: (hlslSource: *u8, entrypoint: *u8, includeDir: *u8, defines: **u8, numDefines: Uint32, shaderStage: SDL_ShaderCross_ShaderStage, size: *u64) -> *void #foreign sdl3_shadercross;
SDL_ShaderCross_CompileSPIRVFromHLSL :: (hlslSource: *u8, entrypoint: *u8, includeDir: *u8, defines: **u8, numDefines: Uint32, shaderStage: SDL_ShaderCross_ShaderStage, size: *u64) -> *void #foreign sdl3_shadercross;
SDL_ShaderCross_CompileGraphicsShaderFromHLSL :: (device: *SDL_GPUDevice, hlslSource: *u8, entrypoint: *u8, includeDir: *u8, defines: **u8, numDefines: Uint32, graphicsShaderStage: SDL_GPUShaderStage, info: *SDL_ShaderCross_GraphicsShaderInfo) -> *SDL_GPUShader #foreign sdl3_shadercross;
SDL_ShaderCross_CompileComputePipelineFromHLSL :: (device: *SDL_GPUDevice, hlslSource: *u8, entrypoint: *u8, includeDir: *u8, defines: **u8, numDefines: Uint32, info: *SDL_ShaderCross_ComputePipelineInfo) -> *SDL_GPUComputePipeline #foreign sdl3_shadercross;

#scope_file


#if OS == .WINDOWS {
    sdl3_shadercross:: #library,no_dll "lib/windows/SDL3_shadercross";
} else #if OS == .LINUX {
    sdl3_shadercross:: #library,no_dll "lib/linux/libSDL3";
} else {
    #assert(false);
}
