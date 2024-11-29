//
// This file was auto-generated using the following command:
//
// jai generate.jai
//



SDL_ASSERT_LEVEL :: 1;
SDL_AUDIO_MASK_BITSIZE :: 0xFF;
SDL_AUDIO_MASK_FLOAT :: 1<<8;
SDL_AUDIO_MASK_BIG_ENDIAN :: 1<<12;
SDL_AUDIO_MASK_SIGNED :: 1<<15;
SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK :: cast(SDL_AudioDeviceID) 0xFFFFFFFF;
SDL_AUDIO_DEVICE_DEFAULT_RECORDING :: cast(SDL_AudioDeviceID) 0xFFFFFFFE;
SDL_BLENDMODE_NONE :: 0x00000000;
SDL_BLENDMODE_BLEND :: 0x00000001;
SDL_BLENDMODE_BLEND_PREMULTIPLIED :: 0x00000010;
SDL_BLENDMODE_ADD :: 0x00000002;
SDL_BLENDMODE_ADD_PREMULTIPLIED :: 0x00000020;
SDL_BLENDMODE_MOD :: 0x00000004;
SDL_BLENDMODE_MUL :: 0x00000008;
SDL_BLENDMODE_INVALID :: 0x7FFFFFFF;
SDL_CACHELINE_SIZE :: 128;
SDL_GLOB_CASEINSENSITIVE :: 1 << 0;
SDL_GPU_TEXTUREUSAGE_SAMPLER :: 1 << 0;
SDL_GPU_TEXTUREUSAGE_COLOR_TARGET :: 1 << 1;
SDL_GPU_TEXTUREUSAGE_DEPTH_STENCIL_TARGET :: 1 << 2;
SDL_GPU_TEXTUREUSAGE_GRAPHICS_STORAGE_READ :: 1 << 3;
SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_READ :: 1 << 4;
SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_WRITE :: 1 << 5;
SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE :: 1 << 6;
SDL_GPU_BUFFERUSAGE_VERTEX :: 1 << 0;
SDL_GPU_BUFFERUSAGE_INDEX :: 1 << 1;
SDL_GPU_BUFFERUSAGE_INDIRECT :: 1 << 2;
SDL_GPU_BUFFERUSAGE_GRAPHICS_STORAGE_READ :: 1 << 3;
SDL_GPU_BUFFERUSAGE_COMPUTE_STORAGE_READ :: 1 << 4;
SDL_GPU_BUFFERUSAGE_COMPUTE_STORAGE_WRITE :: 1 << 5;
SDL_GPU_SHADERFORMAT_INVALID :: 0;
SDL_GPU_SHADERFORMAT_PRIVATE :: 1 << 0;
SDL_GPU_SHADERFORMAT_SPIRV :: 1 << 1;
SDL_GPU_SHADERFORMAT_DXBC :: 1 << 2;
SDL_GPU_SHADERFORMAT_DXIL :: 1 << 3;
SDL_GPU_SHADERFORMAT_MSL :: 1 << 4;
SDL_GPU_SHADERFORMAT_METALLIB :: 1 << 5;
SDL_GPU_COLORCOMPONENT_R :: 1 << 0;
SDL_GPU_COLORCOMPONENT_G :: 1 << 1;
SDL_GPU_COLORCOMPONENT_B :: 1 << 2;
SDL_GPU_COLORCOMPONENT_A :: 1 << 3;
SDL_PROP_GPU_CREATETEXTURE_D3D12_CLEAR_R_FLOAT :: "SDL.gpu.createtexture.d3d12.clear.r";
SDL_PROP_GPU_CREATETEXTURE_D3D12_CLEAR_G_FLOAT :: "SDL.gpu.createtexture.d3d12.clear.g";
SDL_PROP_GPU_CREATETEXTURE_D3D12_CLEAR_B_FLOAT :: "SDL.gpu.createtexture.d3d12.clear.b";
SDL_PROP_GPU_CREATETEXTURE_D3D12_CLEAR_A_FLOAT :: "SDL.gpu.createtexture.d3d12.clear.a";
SDL_PROP_GPU_CREATETEXTURE_D3D12_CLEAR_DEPTH_FLOAT :: "SDL.gpu.createtexture.d3d12.clear.depth";
SDL_PROP_GPU_CREATETEXTURE_D3D12_CLEAR_STENCIL_UINT8 :: "SDL.gpu.createtexture.d3d12.clear.stencil";
SDL_PROP_GPU_DEVICE_CREATE_DEBUGMODE_BOOLEAN :: "SDL.gpu.device.create.debugmode";
SDL_PROP_GPU_DEVICE_CREATE_PREFERLOWPOWER_BOOLEAN :: "SDL.gpu.device.create.preferlowpower";
SDL_PROP_GPU_DEVICE_CREATE_NAME_STRING :: "SDL.gpu.device.create.name";
SDL_PROP_GPU_DEVICE_CREATE_SHADERS_PRIVATE_BOOLEAN :: "SDL.gpu.device.create.shaders.private";
SDL_PROP_GPU_DEVICE_CREATE_SHADERS_SPIRV_BOOLEAN :: "SDL.gpu.device.create.shaders.spirv";
SDL_PROP_GPU_DEVICE_CREATE_SHADERS_DXBC_BOOLEAN :: "SDL.gpu.device.create.shaders.dxbc";
SDL_PROP_GPU_DEVICE_CREATE_SHADERS_DXIL_BOOLEAN :: "SDL.gpu.device.create.shaders.dxil";
SDL_PROP_GPU_DEVICE_CREATE_SHADERS_MSL_BOOLEAN :: "SDL.gpu.device.create.shaders.msl";
SDL_PROP_GPU_DEVICE_CREATE_SHADERS_METALLIB_BOOLEAN :: "SDL.gpu.device.create.shaders.metallib";
SDL_PROP_GPU_DEVICE_CREATE_D3D12_SEMANTIC_NAME_STRING :: "SDL.gpu.device.create.d3d12.semantic";
SDL_INIT_AUDIO :: 0x00000010;
SDL_INIT_VIDEO :: 0x00000020;
SDL_INIT_JOYSTICK :: 0x00000200;
SDL_INIT_HAPTIC :: 0x00001000;
SDL_INIT_GAMEPAD :: 0x00002000;
SDL_INIT_EVENTS :: 0x00004000;
SDL_INIT_SENSOR :: 0x00008000;
SDL_INIT_CAMERA :: 0x00010000;
SDL_PROP_APP_METADATA_NAME_STRING :: "SDL.app.metadata.name";
SDL_PROP_APP_METADATA_VERSION_STRING :: "SDL.app.metadata.version";
SDL_PROP_APP_METADATA_IDENTIFIER_STRING :: "SDL.app.metadata.identifier";
SDL_PROP_APP_METADATA_CREATOR_STRING :: "SDL.app.metadata.creator";
SDL_PROP_APP_METADATA_COPYRIGHT_STRING :: "SDL.app.metadata.copyright";
SDL_PROP_APP_METADATA_URL_STRING :: "SDL.app.metadata.url";
SDL_PROP_APP_METADATA_TYPE_STRING :: "SDL.app.metadata.type";
SDL_MESSAGEBOX_ERROR :: 0x00000010;
SDL_MESSAGEBOX_WARNING :: 0x00000020;
SDL_MESSAGEBOX_INFORMATION :: 0x00000040;
SDL_MESSAGEBOX_BUTTONS_LEFT_TO_RIGHT :: 0x00000080;
SDL_MESSAGEBOX_BUTTONS_RIGHT_TO_LEFT :: 0x00000100;
SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT :: 0x00000001;
SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT :: 0x00000002;
SDL_PROP_PROCESS_CREATE_ARGS_POINTER :: "SDL.process.create.args";
SDL_PROP_PROCESS_CREATE_ENVIRONMENT_POINTER :: "SDL.process.create.environment";
SDL_PROP_PROCESS_CREATE_STDIN_NUMBER :: "SDL.process.create.stdin_option";
SDL_PROP_PROCESS_CREATE_STDIN_POINTER :: "SDL.process.create.stdin_source";
SDL_PROP_PROCESS_CREATE_STDOUT_NUMBER :: "SDL.process.create.stdout_option";
SDL_PROP_PROCESS_CREATE_STDOUT_POINTER :: "SDL.process.create.stdout_source";
SDL_PROP_PROCESS_CREATE_STDERR_NUMBER :: "SDL.process.create.stderr_option";
SDL_PROP_PROCESS_CREATE_STDERR_POINTER :: "SDL.process.create.stderr_source";
SDL_PROP_PROCESS_CREATE_STDERR_TO_STDOUT_BOOLEAN :: "SDL.process.create.stderr_to_stdout";
SDL_PROP_PROCESS_CREATE_BACKGROUND_BOOLEAN :: "SDL.process.create.background";
SDL_PROP_PROCESS_PID_NUMBER :: "SDL.process.pid";
SDL_PROP_PROCESS_STDIN_POINTER :: "SDL.process.stdin";
SDL_PROP_PROCESS_STDOUT_POINTER :: "SDL.process.stdout";
SDL_PROP_PROCESS_STDERR_POINTER :: "SDL.process.stderr";
SDL_PROP_PROCESS_BACKGROUND_BOOLEAN :: "SDL.process.background";
SDL_SOFTWARE_RENDERER :: "software";
SDL_PROP_RENDERER_CREATE_NAME_STRING :: "SDL.renderer.create.name";
SDL_PROP_RENDERER_CREATE_WINDOW_POINTER :: "SDL.renderer.create.window";
SDL_PROP_RENDERER_CREATE_SURFACE_POINTER :: "SDL.renderer.create.surface";
SDL_PROP_RENDERER_CREATE_OUTPUT_COLORSPACE_NUMBER :: "SDL.renderer.create.output_colorspace";
SDL_PROP_RENDERER_CREATE_PRESENT_VSYNC_NUMBER :: "SDL.renderer.create.present_vsync";
SDL_PROP_RENDERER_CREATE_VULKAN_INSTANCE_POINTER :: "SDL.renderer.create.vulkan.instance";
SDL_PROP_RENDERER_CREATE_VULKAN_SURFACE_NUMBER :: "SDL.renderer.create.vulkan.surface";
SDL_PROP_RENDERER_CREATE_VULKAN_PHYSICAL_DEVICE_POINTER :: "SDL.renderer.create.vulkan.physical_device";
SDL_PROP_RENDERER_CREATE_VULKAN_DEVICE_POINTER :: "SDL.renderer.create.vulkan.device";
SDL_PROP_RENDERER_CREATE_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER :: "SDL.renderer.create.vulkan.graphics_queue_family_index";
SDL_PROP_RENDERER_CREATE_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER :: "SDL.renderer.create.vulkan.present_queue_family_index";
SDL_PROP_RENDERER_NAME_STRING :: "SDL.renderer.name";
SDL_PROP_RENDERER_WINDOW_POINTER :: "SDL.renderer.window";
SDL_PROP_RENDERER_SURFACE_POINTER :: "SDL.renderer.surface";
SDL_PROP_RENDERER_VSYNC_NUMBER :: "SDL.renderer.vsync";
SDL_PROP_RENDERER_MAX_TEXTURE_SIZE_NUMBER :: "SDL.renderer.max_texture_size";
SDL_PROP_RENDERER_TEXTURE_FORMATS_POINTER :: "SDL.renderer.texture_formats";
SDL_PROP_RENDERER_OUTPUT_COLORSPACE_NUMBER :: "SDL.renderer.output_colorspace";
SDL_PROP_RENDERER_HDR_ENABLED_BOOLEAN :: "SDL.renderer.HDR_enabled";
SDL_PROP_RENDERER_SDR_WHITE_POINT_FLOAT :: "SDL.renderer.SDR_white_point";
SDL_PROP_RENDERER_HDR_HEADROOM_FLOAT :: "SDL.renderer.HDR_headroom";
SDL_PROP_RENDERER_D3D9_DEVICE_POINTER :: "SDL.renderer.d3d9.device";
SDL_PROP_RENDERER_D3D11_DEVICE_POINTER :: "SDL.renderer.d3d11.device";
SDL_PROP_RENDERER_D3D11_SWAPCHAIN_POINTER :: "SDL.renderer.d3d11.swap_chain";
SDL_PROP_RENDERER_D3D12_DEVICE_POINTER :: "SDL.renderer.d3d12.device";
SDL_PROP_RENDERER_D3D12_SWAPCHAIN_POINTER :: "SDL.renderer.d3d12.swap_chain";
SDL_PROP_RENDERER_D3D12_COMMAND_QUEUE_POINTER :: "SDL.renderer.d3d12.command_queue";
SDL_PROP_RENDERER_VULKAN_INSTANCE_POINTER :: "SDL.renderer.vulkan.instance";
SDL_PROP_RENDERER_VULKAN_SURFACE_NUMBER :: "SDL.renderer.vulkan.surface";
SDL_PROP_RENDERER_VULKAN_PHYSICAL_DEVICE_POINTER :: "SDL.renderer.vulkan.physical_device";
SDL_PROP_RENDERER_VULKAN_DEVICE_POINTER :: "SDL.renderer.vulkan.device";
SDL_PROP_RENDERER_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER :: "SDL.renderer.vulkan.graphics_queue_family_index";
SDL_PROP_RENDERER_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER :: "SDL.renderer.vulkan.present_queue_family_index";
SDL_PROP_RENDERER_VULKAN_SWAPCHAIN_IMAGE_COUNT_NUMBER :: "SDL.renderer.vulkan.swapchain_image_count";
SDL_PROP_TEXTURE_CREATE_COLORSPACE_NUMBER :: "SDL.texture.create.colorspace";
SDL_PROP_TEXTURE_CREATE_FORMAT_NUMBER :: "SDL.texture.create.format";
SDL_PROP_TEXTURE_CREATE_ACCESS_NUMBER :: "SDL.texture.create.access";
SDL_PROP_TEXTURE_CREATE_WIDTH_NUMBER :: "SDL.texture.create.width";
SDL_PROP_TEXTURE_CREATE_HEIGHT_NUMBER :: "SDL.texture.create.height";
SDL_PROP_TEXTURE_CREATE_SDR_WHITE_POINT_FLOAT :: "SDL.texture.create.SDR_white_point";
SDL_PROP_TEXTURE_CREATE_HDR_HEADROOM_FLOAT :: "SDL.texture.create.HDR_headroom";
SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_POINTER :: "SDL.texture.create.d3d11.texture";
SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_U_POINTER :: "SDL.texture.create.d3d11.texture_u";
SDL_PROP_TEXTURE_CREATE_D3D11_TEXTURE_V_POINTER :: "SDL.texture.create.d3d11.texture_v";
SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_POINTER :: "SDL.texture.create.d3d12.texture";
SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_U_POINTER :: "SDL.texture.create.d3d12.texture_u";
SDL_PROP_TEXTURE_CREATE_D3D12_TEXTURE_V_POINTER :: "SDL.texture.create.d3d12.texture_v";
SDL_PROP_TEXTURE_CREATE_METAL_PIXELBUFFER_POINTER :: "SDL.texture.create.metal.pixelbuffer";
SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_NUMBER :: "SDL.texture.create.opengl.texture";
SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_UV_NUMBER :: "SDL.texture.create.opengl.texture_uv";
SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_U_NUMBER :: "SDL.texture.create.opengl.texture_u";
SDL_PROP_TEXTURE_CREATE_OPENGL_TEXTURE_V_NUMBER :: "SDL.texture.create.opengl.texture_v";
SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_NUMBER :: "SDL.texture.create.opengles2.texture";
SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_UV_NUMBER :: "SDL.texture.create.opengles2.texture_uv";
SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_U_NUMBER :: "SDL.texture.create.opengles2.texture_u";
SDL_PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_V_NUMBER :: "SDL.texture.create.opengles2.texture_v";
SDL_PROP_TEXTURE_CREATE_VULKAN_TEXTURE_NUMBER :: "SDL.texture.create.vulkan.texture";
SDL_PROP_TEXTURE_COLORSPACE_NUMBER :: "SDL.texture.colorspace";
SDL_PROP_TEXTURE_FORMAT_NUMBER :: "SDL.texture.format";
SDL_PROP_TEXTURE_ACCESS_NUMBER :: "SDL.texture.access";
SDL_PROP_TEXTURE_WIDTH_NUMBER :: "SDL.texture.width";
SDL_PROP_TEXTURE_HEIGHT_NUMBER :: "SDL.texture.height";
SDL_PROP_TEXTURE_SDR_WHITE_POINT_FLOAT :: "SDL.texture.SDR_white_point";
SDL_PROP_TEXTURE_HDR_HEADROOM_FLOAT :: "SDL.texture.HDR_headroom";
SDL_PROP_TEXTURE_D3D11_TEXTURE_POINTER :: "SDL.texture.d3d11.texture";
SDL_PROP_TEXTURE_D3D11_TEXTURE_U_POINTER :: "SDL.texture.d3d11.texture_u";
SDL_PROP_TEXTURE_D3D11_TEXTURE_V_POINTER :: "SDL.texture.d3d11.texture_v";
SDL_PROP_TEXTURE_D3D12_TEXTURE_POINTER :: "SDL.texture.d3d12.texture";
SDL_PROP_TEXTURE_D3D12_TEXTURE_U_POINTER :: "SDL.texture.d3d12.texture_u";
SDL_PROP_TEXTURE_D3D12_TEXTURE_V_POINTER :: "SDL.texture.d3d12.texture_v";
SDL_PROP_TEXTURE_OPENGL_TEXTURE_NUMBER :: "SDL.texture.opengl.texture";
SDL_PROP_TEXTURE_OPENGL_TEXTURE_UV_NUMBER :: "SDL.texture.opengl.texture_uv";
SDL_PROP_TEXTURE_OPENGL_TEXTURE_U_NUMBER :: "SDL.texture.opengl.texture_u";
SDL_PROP_TEXTURE_OPENGL_TEXTURE_V_NUMBER :: "SDL.texture.opengl.texture_v";
SDL_PROP_TEXTURE_OPENGL_TEXTURE_TARGET_NUMBER :: "SDL.texture.opengl.target";
SDL_PROP_TEXTURE_OPENGL_TEX_W_FLOAT :: "SDL.texture.opengl.tex_w";
SDL_PROP_TEXTURE_OPENGL_TEX_H_FLOAT :: "SDL.texture.opengl.tex_h";
SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_NUMBER :: "SDL.texture.opengles2.texture";
SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_UV_NUMBER :: "SDL.texture.opengles2.texture_uv";
SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_U_NUMBER :: "SDL.texture.opengles2.texture_u";
SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_V_NUMBER :: "SDL.texture.opengles2.texture_v";
SDL_PROP_TEXTURE_OPENGLES2_TEXTURE_TARGET_NUMBER :: "SDL.texture.opengles2.target";
SDL_PROP_TEXTURE_VULKAN_TEXTURE_NUMBER :: "SDL.texture.vulkan.texture";
SDL_RENDERER_VSYNC_DISABLED :: 0;
SDL_RENDERER_VSYNC_ADAPTIVE :: -1;
SDL_DEBUG_TEXT_FONT_CHARACTER_SIZE :: 8;
SDL_REVISION :: "preview-3.1.6-0-g78cc5c173";
SDL_MS_PER_SECOND :: 1000;
SDL_US_PER_SECOND :: 1000000;
SDL_NS_PER_SECOND :: 1000000000;
SDL_NS_PER_MS :: 1000000;
SDL_NS_PER_US :: 1000;
SDL_MAJOR_VERSION :: 3;
SDL_MINOR_VERSION :: 1;
SDL_MICRO_VERSION :: 6;
SDL_AssertState :: enum s32 {
    RETRY         :: 0;
    BREAK         :: 1;
    ABORT         :: 2;
    IGNORE        :: 3;
    ALWAYS_IGNORE :: 4;

    SDL_ASSERTION_RETRY         :: RETRY;
    SDL_ASSERTION_BREAK         :: BREAK;
    SDL_ASSERTION_ABORT         :: ABORT;
    SDL_ASSERTION_IGNORE        :: IGNORE;
    SDL_ASSERTION_ALWAYS_IGNORE :: ALWAYS_IGNORE;
}
SDL_AssertData :: struct {
    always_ignore: bool;
    trigger_count: u32;
    condition:     *u8;
    filename:      *u8;
    linenum:       s32;
    function:      *u8;
    next:          *SDL_AssertData;
}
SDL_ReportAssertion :: (data: *SDL_AssertData, func: *u8, file: *u8, line: s32) -> SDL_AssertState #foreign sdl3;
SDL_AssertionHandler :: #type (data: *SDL_AssertData, userdata: *void) -> SDL_AssertState #c_call;
SDL_SetAssertionHandler :: (handler: SDL_AssertionHandler, userdata: *void) -> void #foreign sdl3;
SDL_GetDefaultAssertionHandler :: () -> SDL_AssertionHandler #foreign sdl3;
SDL_GetAssertionHandler :: (puserdata: **void) -> SDL_AssertionHandler #foreign sdl3;
SDL_GetAssertionReport :: () -> *SDL_AssertData #foreign sdl3;
SDL_ResetAssertionReport :: () -> void #foreign sdl3;
SDL_SpinLock :: s32;
SDL_TryLockSpinlock :: (lock: *SDL_SpinLock) -> bool #foreign sdl3;
SDL_LockSpinlock :: (lock: *SDL_SpinLock) -> void #foreign sdl3;
SDL_UnlockSpinlock :: (lock: *SDL_SpinLock) -> void #foreign sdl3;
SDL_MemoryBarrierReleaseFunction :: () -> void #foreign sdl3;
SDL_MemoryBarrierAcquireFunction :: () -> void #foreign sdl3;
SDL_AtomicInt :: struct {
    value: s32;
}
SDL_CompareAndSwapAtomicInt :: (a: *SDL_AtomicInt, oldval: s32, newval: s32) -> bool #foreign sdl3;
SDL_SetAtomicInt :: (a: *SDL_AtomicInt, v: s32) -> s32 #foreign sdl3;
SDL_GetAtomicInt :: (a: *SDL_AtomicInt) -> s32 #foreign sdl3;
SDL_AddAtomicInt :: (a: *SDL_AtomicInt, v: s32) -> s32 #foreign sdl3;
SDL_AtomicU32 :: struct {
    value: Uint32;
}
SDL_CompareAndSwapAtomicU32 :: (a: *SDL_AtomicU32, oldval: Uint32, newval: Uint32) -> bool #foreign sdl3;
SDL_SetAtomicU32 :: (a: *SDL_AtomicU32, v: Uint32) -> Uint32 #foreign sdl3;
SDL_GetAtomicU32 :: (a: *SDL_AtomicU32) -> Uint32 #foreign sdl3;
SDL_CompareAndSwapAtomicPointer :: (a: **void, oldval: *void, newval: *void) -> bool #foreign sdl3;
SDL_SetAtomicPointer :: (a: **void, v: *void) -> *void #foreign sdl3;
SDL_GetAtomicPointer :: (a: **void) -> *void #foreign sdl3;
SDL_AudioFormat :: enum s32 {
    UNKNOWN :: 0;
    U8      :: 8;
    S8      :: 32776;
    S16LE   :: 32784;
    S16BE   :: 36880;
    S32LE   :: 32800;
    S32BE   :: 36896;
    F32LE   :: 33056;
    F32BE   :: 37152;
    S16     :: 32784;
    S32     :: 32800;
    F32     :: 33056;

    SDL_AUDIO_UNKNOWN :: UNKNOWN;
    SDL_AUDIO_U8      :: U8;
    SDL_AUDIO_S8      :: S8;
    SDL_AUDIO_S16LE   :: S16LE;
    SDL_AUDIO_S16BE   :: S16BE;
    SDL_AUDIO_S32LE   :: S32LE;
    SDL_AUDIO_S32BE   :: S32BE;
    SDL_AUDIO_F32LE   :: F32LE;
    SDL_AUDIO_F32BE   :: F32BE;
    SDL_AUDIO_S16     :: S16;
    SDL_AUDIO_S32     :: S32;
    SDL_AUDIO_F32     :: F32;
}
SDL_AudioDeviceID :: Uint32;
SDL_AudioSpec :: struct {
    format:   SDL_AudioFormat;
    channels: s32;
    freq:     s32;
}
SDL_AudioStream :: struct {}
SDL_GetNumAudioDrivers :: () -> s32 #foreign sdl3;
SDL_GetAudioDriver :: (index: s32) -> *u8 #foreign sdl3;
SDL_GetCurrentAudioDriver :: () -> *u8 #foreign sdl3;
SDL_GetAudioPlaybackDevices :: (count: *s32) -> *SDL_AudioDeviceID #foreign sdl3;
SDL_GetAudioRecordingDevices :: (count: *s32) -> *SDL_AudioDeviceID #foreign sdl3;
SDL_GetAudioDeviceName :: (devid: SDL_AudioDeviceID) -> *u8 #foreign sdl3;
SDL_GetAudioDeviceFormat :: (devid: SDL_AudioDeviceID, spec: *SDL_AudioSpec, sample_frames: *s32) -> bool #foreign sdl3;
SDL_GetAudioDeviceChannelMap :: (devid: SDL_AudioDeviceID, count: *s32) -> *s32 #foreign sdl3;
SDL_OpenAudioDevice :: (devid: SDL_AudioDeviceID, spec: *SDL_AudioSpec) -> SDL_AudioDeviceID #foreign sdl3;
SDL_PauseAudioDevice :: (dev: SDL_AudioDeviceID) -> bool #foreign sdl3;
SDL_ResumeAudioDevice :: (dev: SDL_AudioDeviceID) -> bool #foreign sdl3;
SDL_AudioDevicePaused :: (dev: SDL_AudioDeviceID) -> bool #foreign sdl3;
SDL_GetAudioDeviceGain :: (devid: SDL_AudioDeviceID) -> float #foreign sdl3;
SDL_SetAudioDeviceGain :: (devid: SDL_AudioDeviceID, gain: float) -> bool #foreign sdl3;
SDL_CloseAudioDevice :: (devid: SDL_AudioDeviceID) -> void #foreign sdl3;
SDL_BindAudioStreams :: (devid: SDL_AudioDeviceID, streams: **SDL_AudioStream, num_streams: s32) -> bool #foreign sdl3;
SDL_BindAudioStream :: (devid: SDL_AudioDeviceID, stream: *SDL_AudioStream) -> bool #foreign sdl3;
SDL_UnbindAudioStreams :: (streams: **SDL_AudioStream, num_streams: s32) -> void #foreign sdl3;
SDL_UnbindAudioStream :: (stream: *SDL_AudioStream) -> void #foreign sdl3;
SDL_GetAudioStreamDevice :: (stream: *SDL_AudioStream) -> SDL_AudioDeviceID #foreign sdl3;
SDL_CreateAudioStream :: (src_spec: *SDL_AudioSpec, dst_spec: *SDL_AudioSpec) -> *SDL_AudioStream #foreign sdl3;
SDL_GetAudioStreamProperties :: (stream: *SDL_AudioStream) -> SDL_PropertiesID #foreign sdl3;
SDL_GetAudioStreamFormat :: (stream: *SDL_AudioStream, src_spec: *SDL_AudioSpec, dst_spec: *SDL_AudioSpec) -> bool #foreign sdl3;
SDL_SetAudioStreamFormat :: (stream: *SDL_AudioStream, src_spec: *SDL_AudioSpec, dst_spec: *SDL_AudioSpec) -> bool #foreign sdl3;
SDL_GetAudioStreamFrequencyRatio :: (stream: *SDL_AudioStream) -> float #foreign sdl3;
SDL_SetAudioStreamFrequencyRatio :: (stream: *SDL_AudioStream, ratio: float) -> bool #foreign sdl3;
SDL_GetAudioStreamGain :: (stream: *SDL_AudioStream) -> float #foreign sdl3;
SDL_SetAudioStreamGain :: (stream: *SDL_AudioStream, gain: float) -> bool #foreign sdl3;
SDL_GetAudioStreamInputChannelMap :: (stream: *SDL_AudioStream, count: *s32) -> *s32 #foreign sdl3;
SDL_GetAudioStreamOutputChannelMap :: (stream: *SDL_AudioStream, count: *s32) -> *s32 #foreign sdl3;
SDL_SetAudioStreamInputChannelMap :: (stream: *SDL_AudioStream, chmap: *s32, count: s32) -> bool #foreign sdl3;
SDL_SetAudioStreamOutputChannelMap :: (stream: *SDL_AudioStream, chmap: *s32, count: s32) -> bool #foreign sdl3;
SDL_PutAudioStreamData :: (stream: *SDL_AudioStream, buf: *void, len: s32) -> bool #foreign sdl3;
SDL_GetAudioStreamData :: (stream: *SDL_AudioStream, buf: *void, len: s32) -> s32 #foreign sdl3;
SDL_GetAudioStreamAvailable :: (stream: *SDL_AudioStream) -> s32 #foreign sdl3;
SDL_GetAudioStreamQueued :: (stream: *SDL_AudioStream) -> s32 #foreign sdl3;
SDL_FlushAudioStream :: (stream: *SDL_AudioStream) -> bool #foreign sdl3;
SDL_ClearAudioStream :: (stream: *SDL_AudioStream) -> bool #foreign sdl3;
SDL_PauseAudioStreamDevice :: (stream: *SDL_AudioStream) -> bool #foreign sdl3;
SDL_ResumeAudioStreamDevice :: (stream: *SDL_AudioStream) -> bool #foreign sdl3;
SDL_LockAudioStream :: (stream: *SDL_AudioStream) -> bool #foreign sdl3;
SDL_UnlockAudioStream :: (stream: *SDL_AudioStream) -> bool #foreign sdl3;
SDL_AudioStreamCallback :: #type (userdata: *void, stream: *SDL_AudioStream, additional_amount: s32, total_amount: s32) -> void #c_call;
SDL_SetAudioStreamGetCallback :: (stream: *SDL_AudioStream, callback: SDL_AudioStreamCallback, userdata: *void) -> bool #foreign sdl3;
SDL_SetAudioStreamPutCallback :: (stream: *SDL_AudioStream, callback: SDL_AudioStreamCallback, userdata: *void) -> bool #foreign sdl3;
SDL_DestroyAudioStream :: (stream: *SDL_AudioStream) -> void #foreign sdl3;
SDL_OpenAudioDeviceStream :: (devid: SDL_AudioDeviceID, spec: *SDL_AudioSpec, callback: SDL_AudioStreamCallback, userdata: *void) -> *SDL_AudioStream #foreign sdl3;
SDL_AudioPostmixCallback :: #type (userdata: *void, spec: *SDL_AudioSpec, buffer: *float, buflen: s32) -> void #c_call;
SDL_SetAudioPostmixCallback :: (devid: SDL_AudioDeviceID, callback: SDL_AudioPostmixCallback, userdata: *void) -> bool #foreign sdl3;
SDL_LoadWAV_IO :: (src: *SDL_IOStream, closeio: bool, spec: *SDL_AudioSpec, audio_buf: **Uint8, audio_len: *Uint32) -> bool #foreign sdl3;
SDL_LoadWAV :: (path: *u8, spec: *SDL_AudioSpec, audio_buf: **Uint8, audio_len: *Uint32) -> bool #foreign sdl3;
SDL_MixAudio :: (dst: *Uint8, src: *Uint8, format: SDL_AudioFormat, len: Uint32, volume: float) -> bool #foreign sdl3;
SDL_ConvertAudioSamples :: (src_spec: *SDL_AudioSpec, src_data: *Uint8, src_len: s32, dst_spec: *SDL_AudioSpec, dst_data: **Uint8, dst_len: *s32) -> bool #foreign sdl3;
SDL_GetAudioFormatName :: (format: SDL_AudioFormat) -> *u8 #foreign sdl3;
SDL_GetSilenceValueForFormat :: (format: SDL_AudioFormat) -> s32 #foreign sdl3;
SDL_BlendMode :: Uint32;
SDL_BlendOperation :: enum s32 {
    ADD          :: 1;
    SUBTRACT     :: 2;
    REV_SUBTRACT :: 3;
    MINIMUM      :: 4;
    MAXIMUM      :: 5;

    SDL_BLENDOPERATION_ADD          :: ADD;
    SDL_BLENDOPERATION_SUBTRACT     :: SUBTRACT;
    SDL_BLENDOPERATION_REV_SUBTRACT :: REV_SUBTRACT;
    SDL_BLENDOPERATION_MINIMUM      :: MINIMUM;
    SDL_BLENDOPERATION_MAXIMUM      :: MAXIMUM;
}
SDL_BlendFactor :: enum s32 {
    ZERO                :: 1;
    ONE                 :: 2;
    SRC_COLOR           :: 3;
    ONE_MINUS_SRC_COLOR :: 4;
    SRC_ALPHA           :: 5;
    ONE_MINUS_SRC_ALPHA :: 6;
    DST_COLOR           :: 7;
    ONE_MINUS_DST_COLOR :: 8;
    DST_ALPHA           :: 9;
    ONE_MINUS_DST_ALPHA :: 10;

    SDL_BLENDFACTOR_ZERO                :: ZERO;
    SDL_BLENDFACTOR_ONE                 :: ONE;
    SDL_BLENDFACTOR_SRC_COLOR           :: SRC_COLOR;
    SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOR :: ONE_MINUS_SRC_COLOR;
    SDL_BLENDFACTOR_SRC_ALPHA           :: SRC_ALPHA;
    SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA :: ONE_MINUS_SRC_ALPHA;
    SDL_BLENDFACTOR_DST_COLOR           :: DST_COLOR;
    SDL_BLENDFACTOR_ONE_MINUS_DST_COLOR :: ONE_MINUS_DST_COLOR;
    SDL_BLENDFACTOR_DST_ALPHA           :: DST_ALPHA;
    SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA :: ONE_MINUS_DST_ALPHA;
}
SDL_ComposeCustomBlendMode :: (srcColorFactor: SDL_BlendFactor, dstColorFactor: SDL_BlendFactor, colorOperation: SDL_BlendOperation, srcAlphaFactor: SDL_BlendFactor, dstAlphaFactor: SDL_BlendFactor, alphaOperation: SDL_BlendOperation) -> SDL_BlendMode #foreign sdl3;
SDL_CameraID :: Uint32;
SDL_Camera :: struct {}
SDL_CameraSpec :: struct {
    format:                SDL_PixelFormat;
    colorspace:            SDL_Colorspace;
    width:                 s32;
    height:                s32;
    framerate_numerator:   s32;
    framerate_denominator: s32;
}
SDL_CameraPosition :: enum s32 {
    UNKNOWN      :: 0;
    FRONT_FACING :: 1;
    BACK_FACING  :: 2;

    SDL_CAMERA_POSITION_UNKNOWN      :: UNKNOWN;
    SDL_CAMERA_POSITION_FRONT_FACING :: FRONT_FACING;
    SDL_CAMERA_POSITION_BACK_FACING  :: BACK_FACING;
}
SDL_GetNumCameraDrivers :: () -> s32 #foreign sdl3;
SDL_GetCameraDriver :: (index: s32) -> *u8 #foreign sdl3;
SDL_GetCurrentCameraDriver :: () -> *u8 #foreign sdl3;
SDL_GetCameras :: (count: *s32) -> *SDL_CameraID #foreign sdl3;
SDL_GetCameraSupportedFormats :: (devid: SDL_CameraID, count: *s32) -> **SDL_CameraSpec #foreign sdl3;
SDL_GetCameraName :: (instance_id: SDL_CameraID) -> *u8 #foreign sdl3;
SDL_GetCameraPosition :: (instance_id: SDL_CameraID) -> SDL_CameraPosition #foreign sdl3;
SDL_OpenCamera :: (instance_id: SDL_CameraID, spec: *SDL_CameraSpec) -> *SDL_Camera #foreign sdl3;
SDL_GetCameraPermissionState :: (camera: *SDL_Camera) -> s32 #foreign sdl3;
SDL_GetCameraID :: (camera: *SDL_Camera) -> SDL_CameraID #foreign sdl3;
SDL_GetCameraProperties :: (camera: *SDL_Camera) -> SDL_PropertiesID #foreign sdl3;
SDL_GetCameraFormat :: (camera: *SDL_Camera, spec: *SDL_CameraSpec) -> bool #foreign sdl3;
SDL_AcquireCameraFrame :: (camera: *SDL_Camera, timestampNS: *Uint64) -> *SDL_Surface #foreign sdl3;
SDL_ReleaseCameraFrame :: (camera: *SDL_Camera, frame: *SDL_Surface) -> void #foreign sdl3;
SDL_CloseCamera :: (camera: *SDL_Camera) -> void #foreign sdl3;
SDL_SetClipboardText :: (text: *u8) -> bool #foreign sdl3;
SDL_GetClipboardText :: () -> *u8 #foreign sdl3;
SDL_HasClipboardText :: () -> bool #foreign sdl3;
SDL_SetPrimarySelectionText :: (text: *u8) -> bool #foreign sdl3;
SDL_GetPrimarySelectionText :: () -> *u8 #foreign sdl3;
SDL_HasPrimarySelectionText :: () -> bool #foreign sdl3;
SDL_ClipboardDataCallback :: #type (userdata: *void, mime_type: *u8, size: *u64) -> *void #c_call;
SDL_ClipboardCleanupCallback :: #type (userdata: *void) -> void #c_call;
SDL_SetClipboardData :: (callback: SDL_ClipboardDataCallback, cleanup: SDL_ClipboardCleanupCallback, userdata: *void, mime_types: **u8, num_mime_types: u64) -> bool #foreign sdl3;
SDL_ClearClipboardData :: () -> bool #foreign sdl3;
SDL_GetClipboardData :: (mime_type: *u8, size: *u64) -> *void #foreign sdl3;
SDL_HasClipboardData :: (mime_type: *u8) -> bool #foreign sdl3;
SDL_GetClipboardMimeTypes :: (num_mime_types: *u64) -> **u8 #foreign sdl3;
SDL_GetNumLogicalCPUCores :: () -> s32 #foreign sdl3;
SDL_GetCPUCacheLineSize :: () -> s32 #foreign sdl3;
SDL_HasAltiVec :: () -> bool #foreign sdl3;
SDL_HasMMX :: () -> bool #foreign sdl3;
SDL_HasSSE :: () -> bool #foreign sdl3;
SDL_HasSSE2 :: () -> bool #foreign sdl3;
SDL_HasSSE3 :: () -> bool #foreign sdl3;
SDL_HasSSE41 :: () -> bool #foreign sdl3;
SDL_HasSSE42 :: () -> bool #foreign sdl3;
SDL_HasAVX :: () -> bool #foreign sdl3;
SDL_HasAVX2 :: () -> bool #foreign sdl3;
SDL_HasAVX512F :: () -> bool #foreign sdl3;
SDL_HasARMSIMD :: () -> bool #foreign sdl3;
SDL_HasNEON :: () -> bool #foreign sdl3;
SDL_HasLSX :: () -> bool #foreign sdl3;
SDL_HasLASX :: () -> bool #foreign sdl3;
SDL_GetSystemRAM :: () -> s32 #foreign sdl3;
SDL_GetSIMDAlignment :: () -> u64 #foreign sdl3;
SDL_DialogFileFilter :: struct {
    name:    *u8;
    pattern: *u8;
}
SDL_DialogFileCallback :: #type (userdata: *void, filelist: **u8, filter: s32) -> void #c_call;
SDL_ShowOpenFileDialog :: (callback: SDL_DialogFileCallback, userdata: *void, window: *SDL_Window, filters: *SDL_DialogFileFilter, nfilters: s32, default_location: *u8, allow_many: bool) -> void #foreign sdl3;
SDL_ShowSaveFileDialog :: (callback: SDL_DialogFileCallback, userdata: *void, window: *SDL_Window, filters: *SDL_DialogFileFilter, nfilters: s32, default_location: *u8) -> void #foreign sdl3;
SDL_ShowOpenFolderDialog :: (callback: SDL_DialogFileCallback, userdata: *void, window: *SDL_Window, default_location: *u8, allow_many: bool) -> void #foreign sdl3;
SDL_EventType :: enum s32 {
    FIRST                         :: 0;
    QUIT                          :: 256;
    TERMINATING                   :: 257;
    LOW_MEMORY                    :: 258;
    WILL_ENTER_BACKGROUND         :: 259;
    DID_ENTER_BACKGROUND          :: 260;
    WILL_ENTER_FOREGROUND         :: 261;
    DID_ENTER_FOREGROUND          :: 262;
    LOCALE_CHANGED                :: 263;
    SYSTEM_THEME_CHANGED          :: 264;
    DISPLAY_ORIENTATION           :: 337;
    DISPLAY_ADDED                 :: 338;
    DISPLAY_REMOVED               :: 339;
    DISPLAY_MOVED                 :: 340;
    DISPLAY_DESKTOP_MODE_CHANGED  :: 341;
    DISPLAY_CURRENT_MODE_CHANGED  :: 342;
    DISPLAY_CONTENT_SCALE_CHANGED :: 343;
    DISPLAY_FIRST                 :: 337;
    DISPLAY_LAST                  :: 343;
    WINDOW_SHOWN                  :: 514;
    WINDOW_HIDDEN                 :: 515;
    WINDOW_EXPOSED                :: 516;
    WINDOW_MOVED                  :: 517;
    WINDOW_RESIZED                :: 518;
    WINDOW_PIXEL_SIZE_CHANGED     :: 519;
    WINDOW_METAL_VIEW_RESIZED     :: 520;
    WINDOW_MINIMIZED              :: 521;
    WINDOW_MAXIMIZED              :: 522;
    WINDOW_RESTORED               :: 523;
    WINDOW_MOUSE_ENTER            :: 524;
    WINDOW_MOUSE_LEAVE            :: 525;
    WINDOW_FOCUS_GAINED           :: 526;
    WINDOW_FOCUS_LOST             :: 527;
    WINDOW_CLOSE_REQUESTED        :: 528;
    WINDOW_HIT_TEST               :: 529;
    WINDOW_ICCPROF_CHANGED        :: 530;
    WINDOW_DISPLAY_CHANGED        :: 531;
    WINDOW_DISPLAY_SCALE_CHANGED  :: 532;
    WINDOW_SAFE_AREA_CHANGED      :: 533;
    WINDOW_OCCLUDED               :: 534;
    WINDOW_ENTER_FULLSCREEN       :: 535;
    WINDOW_LEAVE_FULLSCREEN       :: 536;
    WINDOW_DESTROYED              :: 537;
    WINDOW_HDR_STATE_CHANGED      :: 538;
    WINDOW_FIRST                  :: 514;
    WINDOW_LAST                   :: 538;
    KEY_DOWN                      :: 768;
    KEY_UP                        :: 769;
    TEXT_EDITING                  :: 770;
    TEXT_INPUT                    :: 771;
    KEYMAP_CHANGED                :: 772;
    KEYBOARD_ADDED                :: 773;
    KEYBOARD_REMOVED              :: 774;
    TEXT_EDITING_CANDIDATES       :: 775;
    MOUSE_MOTION                  :: 1024;
    MOUSE_BUTTON_DOWN             :: 1025;
    MOUSE_BUTTON_UP               :: 1026;
    MOUSE_WHEEL                   :: 1027;
    MOUSE_ADDED                   :: 1028;
    MOUSE_REMOVED                 :: 1029;
    JOYSTICK_AXIS_MOTION          :: 1536;
    JOYSTICK_BALL_MOTION          :: 1537;
    JOYSTICK_HAT_MOTION           :: 1538;
    JOYSTICK_BUTTON_DOWN          :: 1539;
    JOYSTICK_BUTTON_UP            :: 1540;
    JOYSTICK_ADDED                :: 1541;
    JOYSTICK_REMOVED              :: 1542;
    JOYSTICK_BATTERY_UPDATED      :: 1543;
    JOYSTICK_UPDATE_COMPLETE      :: 1544;
    GAMEPAD_AXIS_MOTION           :: 1616;
    GAMEPAD_BUTTON_DOWN           :: 1617;
    GAMEPAD_BUTTON_UP             :: 1618;
    GAMEPAD_ADDED                 :: 1619;
    GAMEPAD_REMOVED               :: 1620;
    GAMEPAD_REMAPPED              :: 1621;
    GAMEPAD_TOUCHPAD_DOWN         :: 1622;
    GAMEPAD_TOUCHPAD_MOTION       :: 1623;
    GAMEPAD_TOUCHPAD_UP           :: 1624;
    GAMEPAD_SENSOR_UPDATE         :: 1625;
    GAMEPAD_UPDATE_COMPLETE       :: 1626;
    GAMEPAD_STEAM_HANDLE_UPDATED  :: 1627;
    FINGER_DOWN                   :: 1792;
    FINGER_UP                     :: 1793;
    FINGER_MOTION                 :: 1794;
    CLIPBOARD_UPDATE              :: 2304;
    DROP_FILE                     :: 4096;
    DROP_TEXT                     :: 4097;
    DROP_BEGIN                    :: 4098;
    DROP_COMPLETE                 :: 4099;
    DROP_POSITION                 :: 4100;
    AUDIO_DEVICE_ADDED            :: 4352;
    AUDIO_DEVICE_REMOVED          :: 4353;
    AUDIO_DEVICE_FORMAT_CHANGED   :: 4354;
    SENSOR_UPDATE                 :: 4608;
    PEN_PROXIMITY_IN              :: 4864;
    PEN_PROXIMITY_OUT             :: 4865;
    PEN_DOWN                      :: 4866;
    PEN_UP                        :: 4867;
    PEN_BUTTON_DOWN               :: 4868;
    PEN_BUTTON_UP                 :: 4869;
    PEN_MOTION                    :: 4870;
    PEN_AXIS                      :: 4871;
    CAMERA_DEVICE_ADDED           :: 5120;
    CAMERA_DEVICE_REMOVED         :: 5121;
    CAMERA_DEVICE_APPROVED        :: 5122;
    CAMERA_DEVICE_DENIED          :: 5123;
    RENDER_TARGETS_RESET          :: 8192;
    RENDER_DEVICE_RESET           :: 8193;
    RENDER_DEVICE_LOST            :: 8194;
    PRIVATE0                      :: 16384;
    PRIVATE1                      :: 16385;
    PRIVATE2                      :: 16386;
    PRIVATE3                      :: 16387;
    POLL_SENTINEL                 :: 32512;
    USER                          :: 32768;
    LAST                          :: 65535;
    ENUM_PADDING                  :: 2147483647;

    SDL_EVENT_FIRST                         :: FIRST;
    SDL_EVENT_QUIT                          :: QUIT;
    SDL_EVENT_TERMINATING                   :: TERMINATING;
    SDL_EVENT_LOW_MEMORY                    :: LOW_MEMORY;
    SDL_EVENT_WILL_ENTER_BACKGROUND         :: WILL_ENTER_BACKGROUND;
    SDL_EVENT_DID_ENTER_BACKGROUND          :: DID_ENTER_BACKGROUND;
    SDL_EVENT_WILL_ENTER_FOREGROUND         :: WILL_ENTER_FOREGROUND;
    SDL_EVENT_DID_ENTER_FOREGROUND          :: DID_ENTER_FOREGROUND;
    SDL_EVENT_LOCALE_CHANGED                :: LOCALE_CHANGED;
    SDL_EVENT_SYSTEM_THEME_CHANGED          :: SYSTEM_THEME_CHANGED;
    SDL_EVENT_DISPLAY_ORIENTATION           :: DISPLAY_ORIENTATION;
    SDL_EVENT_DISPLAY_ADDED                 :: DISPLAY_ADDED;
    SDL_EVENT_DISPLAY_REMOVED               :: DISPLAY_REMOVED;
    SDL_EVENT_DISPLAY_MOVED                 :: DISPLAY_MOVED;
    SDL_EVENT_DISPLAY_DESKTOP_MODE_CHANGED  :: DISPLAY_DESKTOP_MODE_CHANGED;
    SDL_EVENT_DISPLAY_CURRENT_MODE_CHANGED  :: DISPLAY_CURRENT_MODE_CHANGED;
    SDL_EVENT_DISPLAY_CONTENT_SCALE_CHANGED :: DISPLAY_CONTENT_SCALE_CHANGED;
    SDL_EVENT_DISPLAY_FIRST                 :: DISPLAY_FIRST;
    SDL_EVENT_DISPLAY_LAST                  :: DISPLAY_LAST;
    SDL_EVENT_WINDOW_SHOWN                  :: WINDOW_SHOWN;
    SDL_EVENT_WINDOW_HIDDEN                 :: WINDOW_HIDDEN;
    SDL_EVENT_WINDOW_EXPOSED                :: WINDOW_EXPOSED;
    SDL_EVENT_WINDOW_MOVED                  :: WINDOW_MOVED;
    SDL_EVENT_WINDOW_RESIZED                :: WINDOW_RESIZED;
    SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED     :: WINDOW_PIXEL_SIZE_CHANGED;
    SDL_EVENT_WINDOW_METAL_VIEW_RESIZED     :: WINDOW_METAL_VIEW_RESIZED;
    SDL_EVENT_WINDOW_MINIMIZED              :: WINDOW_MINIMIZED;
    SDL_EVENT_WINDOW_MAXIMIZED              :: WINDOW_MAXIMIZED;
    SDL_EVENT_WINDOW_RESTORED               :: WINDOW_RESTORED;
    SDL_EVENT_WINDOW_MOUSE_ENTER            :: WINDOW_MOUSE_ENTER;
    SDL_EVENT_WINDOW_MOUSE_LEAVE            :: WINDOW_MOUSE_LEAVE;
    SDL_EVENT_WINDOW_FOCUS_GAINED           :: WINDOW_FOCUS_GAINED;
    SDL_EVENT_WINDOW_FOCUS_LOST             :: WINDOW_FOCUS_LOST;
    SDL_EVENT_WINDOW_CLOSE_REQUESTED        :: WINDOW_CLOSE_REQUESTED;
    SDL_EVENT_WINDOW_HIT_TEST               :: WINDOW_HIT_TEST;
    SDL_EVENT_WINDOW_ICCPROF_CHANGED        :: WINDOW_ICCPROF_CHANGED;
    SDL_EVENT_WINDOW_DISPLAY_CHANGED        :: WINDOW_DISPLAY_CHANGED;
    SDL_EVENT_WINDOW_DISPLAY_SCALE_CHANGED  :: WINDOW_DISPLAY_SCALE_CHANGED;
    SDL_EVENT_WINDOW_SAFE_AREA_CHANGED      :: WINDOW_SAFE_AREA_CHANGED;
    SDL_EVENT_WINDOW_OCCLUDED               :: WINDOW_OCCLUDED;
    SDL_EVENT_WINDOW_ENTER_FULLSCREEN       :: WINDOW_ENTER_FULLSCREEN;
    SDL_EVENT_WINDOW_LEAVE_FULLSCREEN       :: WINDOW_LEAVE_FULLSCREEN;
    SDL_EVENT_WINDOW_DESTROYED              :: WINDOW_DESTROYED;
    SDL_EVENT_WINDOW_HDR_STATE_CHANGED      :: WINDOW_HDR_STATE_CHANGED;
    SDL_EVENT_WINDOW_FIRST                  :: WINDOW_FIRST;
    SDL_EVENT_WINDOW_LAST                   :: WINDOW_LAST;
    SDL_EVENT_KEY_DOWN                      :: KEY_DOWN;
    SDL_EVENT_KEY_UP                        :: KEY_UP;
    SDL_EVENT_TEXT_EDITING                  :: TEXT_EDITING;
    SDL_EVENT_TEXT_INPUT                    :: TEXT_INPUT;
    SDL_EVENT_KEYMAP_CHANGED                :: KEYMAP_CHANGED;
    SDL_EVENT_KEYBOARD_ADDED                :: KEYBOARD_ADDED;
    SDL_EVENT_KEYBOARD_REMOVED              :: KEYBOARD_REMOVED;
    SDL_EVENT_TEXT_EDITING_CANDIDATES       :: TEXT_EDITING_CANDIDATES;
    SDL_EVENT_MOUSE_MOTION                  :: MOUSE_MOTION;
    SDL_EVENT_MOUSE_BUTTON_DOWN             :: MOUSE_BUTTON_DOWN;
    SDL_EVENT_MOUSE_BUTTON_UP               :: MOUSE_BUTTON_UP;
    SDL_EVENT_MOUSE_WHEEL                   :: MOUSE_WHEEL;
    SDL_EVENT_MOUSE_ADDED                   :: MOUSE_ADDED;
    SDL_EVENT_MOUSE_REMOVED                 :: MOUSE_REMOVED;
    SDL_EVENT_JOYSTICK_AXIS_MOTION          :: JOYSTICK_AXIS_MOTION;
    SDL_EVENT_JOYSTICK_BALL_MOTION          :: JOYSTICK_BALL_MOTION;
    SDL_EVENT_JOYSTICK_HAT_MOTION           :: JOYSTICK_HAT_MOTION;
    SDL_EVENT_JOYSTICK_BUTTON_DOWN          :: JOYSTICK_BUTTON_DOWN;
    SDL_EVENT_JOYSTICK_BUTTON_UP            :: JOYSTICK_BUTTON_UP;
    SDL_EVENT_JOYSTICK_ADDED                :: JOYSTICK_ADDED;
    SDL_EVENT_JOYSTICK_REMOVED              :: JOYSTICK_REMOVED;
    SDL_EVENT_JOYSTICK_BATTERY_UPDATED      :: JOYSTICK_BATTERY_UPDATED;
    SDL_EVENT_JOYSTICK_UPDATE_COMPLETE      :: JOYSTICK_UPDATE_COMPLETE;
    SDL_EVENT_GAMEPAD_AXIS_MOTION           :: GAMEPAD_AXIS_MOTION;
    SDL_EVENT_GAMEPAD_BUTTON_DOWN           :: GAMEPAD_BUTTON_DOWN;
    SDL_EVENT_GAMEPAD_BUTTON_UP             :: GAMEPAD_BUTTON_UP;
    SDL_EVENT_GAMEPAD_ADDED                 :: GAMEPAD_ADDED;
    SDL_EVENT_GAMEPAD_REMOVED               :: GAMEPAD_REMOVED;
    SDL_EVENT_GAMEPAD_REMAPPED              :: GAMEPAD_REMAPPED;
    SDL_EVENT_GAMEPAD_TOUCHPAD_DOWN         :: GAMEPAD_TOUCHPAD_DOWN;
    SDL_EVENT_GAMEPAD_TOUCHPAD_MOTION       :: GAMEPAD_TOUCHPAD_MOTION;
    SDL_EVENT_GAMEPAD_TOUCHPAD_UP           :: GAMEPAD_TOUCHPAD_UP;
    SDL_EVENT_GAMEPAD_SENSOR_UPDATE         :: GAMEPAD_SENSOR_UPDATE;
    SDL_EVENT_GAMEPAD_UPDATE_COMPLETE       :: GAMEPAD_UPDATE_COMPLETE;
    SDL_EVENT_GAMEPAD_STEAM_HANDLE_UPDATED  :: GAMEPAD_STEAM_HANDLE_UPDATED;
    SDL_EVENT_FINGER_DOWN                   :: FINGER_DOWN;
    SDL_EVENT_FINGER_UP                     :: FINGER_UP;
    SDL_EVENT_FINGER_MOTION                 :: FINGER_MOTION;
    SDL_EVENT_CLIPBOARD_UPDATE              :: CLIPBOARD_UPDATE;
    SDL_EVENT_DROP_FILE                     :: DROP_FILE;
    SDL_EVENT_DROP_TEXT                     :: DROP_TEXT;
    SDL_EVENT_DROP_BEGIN                    :: DROP_BEGIN;
    SDL_EVENT_DROP_COMPLETE                 :: DROP_COMPLETE;
    SDL_EVENT_DROP_POSITION                 :: DROP_POSITION;
    SDL_EVENT_AUDIO_DEVICE_ADDED            :: AUDIO_DEVICE_ADDED;
    SDL_EVENT_AUDIO_DEVICE_REMOVED          :: AUDIO_DEVICE_REMOVED;
    SDL_EVENT_AUDIO_DEVICE_FORMAT_CHANGED   :: AUDIO_DEVICE_FORMAT_CHANGED;
    SDL_EVENT_SENSOR_UPDATE                 :: SENSOR_UPDATE;
    SDL_EVENT_PEN_PROXIMITY_IN              :: PEN_PROXIMITY_IN;
    SDL_EVENT_PEN_PROXIMITY_OUT             :: PEN_PROXIMITY_OUT;
    SDL_EVENT_PEN_DOWN                      :: PEN_DOWN;
    SDL_EVENT_PEN_UP                        :: PEN_UP;
    SDL_EVENT_PEN_BUTTON_DOWN               :: PEN_BUTTON_DOWN;
    SDL_EVENT_PEN_BUTTON_UP                 :: PEN_BUTTON_UP;
    SDL_EVENT_PEN_MOTION                    :: PEN_MOTION;
    SDL_EVENT_PEN_AXIS                      :: PEN_AXIS;
    SDL_EVENT_CAMERA_DEVICE_ADDED           :: CAMERA_DEVICE_ADDED;
    SDL_EVENT_CAMERA_DEVICE_REMOVED         :: CAMERA_DEVICE_REMOVED;
    SDL_EVENT_CAMERA_DEVICE_APPROVED        :: CAMERA_DEVICE_APPROVED;
    SDL_EVENT_CAMERA_DEVICE_DENIED          :: CAMERA_DEVICE_DENIED;
    SDL_EVENT_RENDER_TARGETS_RESET          :: RENDER_TARGETS_RESET;
    SDL_EVENT_RENDER_DEVICE_RESET           :: RENDER_DEVICE_RESET;
    SDL_EVENT_RENDER_DEVICE_LOST            :: RENDER_DEVICE_LOST;
    SDL_EVENT_PRIVATE0                      :: PRIVATE0;
    SDL_EVENT_PRIVATE1                      :: PRIVATE1;
    SDL_EVENT_PRIVATE2                      :: PRIVATE2;
    SDL_EVENT_PRIVATE3                      :: PRIVATE3;
    SDL_EVENT_POLL_SENTINEL                 :: POLL_SENTINEL;
    SDL_EVENT_USER                          :: USER;
    SDL_EVENT_LAST                          :: LAST;
    SDL_EVENT_ENUM_PADDING                  :: ENUM_PADDING;
}
SDL_CommonEvent :: struct {
    type:      Uint32;
    reserved:  Uint32;
    timestamp: Uint64;
}
SDL_DisplayEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    displayID: SDL_DisplayID;
    data1:     Sint32;
    data2:     Sint32;
}
SDL_WindowEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    data1:     Sint32;
    data2:     Sint32;
}
SDL_KeyboardDeviceEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_KeyboardID;
}
SDL_KeyboardEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    which:     SDL_KeyboardID;
    scancode:  SDL_Scancode;
    key:       SDL_Keycode;
    mod:       SDL_Keymod;
    raw:       Uint16;
    down:      bool;
    repeat:    bool;
}
SDL_TextEditingEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    text:      *u8;
    start:     Sint32;
    length:    Sint32;
}
SDL_TextEditingCandidatesEvent :: struct {
    type:               SDL_EventType;
    reserved:           Uint32;
    timestamp:          Uint64;
    windowID:           SDL_WindowID;
    candidates:         **u8;
    num_candidates:     Sint32;
    selected_candidate: Sint32;
    horizontal:         bool;
    padding1:           Uint8;
    padding2:           Uint8;
    padding3:           Uint8;
}
SDL_TextInputEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    text:      *u8;
}
SDL_MouseDeviceEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_MouseID;
}
SDL_MouseMotionEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    which:     SDL_MouseID;
    state:     SDL_MouseButtonFlags;
    x:         float;
    y:         float;
    xrel:      float;
    yrel:      float;
}
SDL_MouseButtonEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    which:     SDL_MouseID;
    button:    Uint8;
    down:      bool;
    clicks:    Uint8;
    padding:   Uint8;
    x:         float;
    y:         float;
}
SDL_MouseWheelEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    which:     SDL_MouseID;
    x:         float;
    y:         float;
    direction: SDL_MouseWheelDirection;
    mouse_x:   float;
    mouse_y:   float;
}
SDL_JoyAxisEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_JoystickID;
    axis:      Uint8;
    padding1:  Uint8;
    padding2:  Uint8;
    padding3:  Uint8;
    value:     Sint16;
    padding4:  Uint16;
}
SDL_JoyBallEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_JoystickID;
    ball:      Uint8;
    padding1:  Uint8;
    padding2:  Uint8;
    padding3:  Uint8;
    xrel:      Sint16;
    yrel:      Sint16;
}
SDL_JoyHatEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_JoystickID;
    hat:       Uint8;
    value:     Uint8;
    padding1:  Uint8;
    padding2:  Uint8;
}
SDL_JoyButtonEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_JoystickID;
    button:    Uint8;
    down:      bool;
    padding1:  Uint8;
    padding2:  Uint8;
}
SDL_JoyDeviceEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_JoystickID;
}
SDL_JoyBatteryEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_JoystickID;
    state:     SDL_PowerState;
    percent:   s32;
}
SDL_GamepadAxisEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_JoystickID;
    axis:      Uint8;
    padding1:  Uint8;
    padding2:  Uint8;
    padding3:  Uint8;
    value:     Sint16;
    padding4:  Uint16;
}
SDL_GamepadButtonEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_JoystickID;
    button:    Uint8;
    down:      bool;
    padding1:  Uint8;
    padding2:  Uint8;
}
SDL_GamepadDeviceEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_JoystickID;
}
SDL_GamepadTouchpadEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_JoystickID;
    touchpad:  Sint32;
    finger:    Sint32;
    x:         float;
    y:         float;
    pressure:  float;
}
SDL_GamepadSensorEvent :: struct {
    type:             SDL_EventType;
    reserved:         Uint32;
    timestamp:        Uint64;
    which:            SDL_JoystickID;
    sensor:           Sint32;
    data:             [3] float;
    sensor_timestamp: Uint64;
}
SDL_AudioDeviceEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_AudioDeviceID;
    recording: bool;
    padding1:  Uint8;
    padding2:  Uint8;
    padding3:  Uint8;
}
SDL_CameraDeviceEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    which:     SDL_CameraID;
}
SDL_TouchFingerEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    touchID:   SDL_TouchID;
    fingerID:  SDL_FingerID;
    x:         float;
    y:         float;
    dx:        float;
    dy:        float;
    pressure:  float;
    windowID:  SDL_WindowID;
}
SDL_PenProximityEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    which:     SDL_PenID;
}
SDL_PenMotionEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    which:     SDL_PenID;
    pen_state: SDL_PenInputFlags;
    x:         float;
    y:         float;
}
SDL_PenTouchEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    which:     SDL_PenID;
    pen_state: SDL_PenInputFlags;
    x:         float;
    y:         float;
    eraser:    bool;
    down:      bool;
}
SDL_PenButtonEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    which:     SDL_PenID;
    pen_state: SDL_PenInputFlags;
    x:         float;
    y:         float;
    button:    Uint8;
    down:      bool;
}
SDL_PenAxisEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    which:     SDL_PenID;
    pen_state: SDL_PenInputFlags;
    x:         float;
    y:         float;
    axis:      SDL_PenAxis;
    value:     float;
}
SDL_DropEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    x:         float;
    y:         float;
    source:    *u8;
    data:      *u8;
}
SDL_ClipboardEvent :: struct {
    type:         SDL_EventType;
    reserved:     Uint32;
    timestamp:    Uint64;
    owner:        bool;
    n_mime_types: Sint32;
    mime_types:   **u8;
}
SDL_SensorEvent :: struct {
    type:             SDL_EventType;
    reserved:         Uint32;
    timestamp:        Uint64;
    which:            SDL_SensorID;
    data:             [6] float;
    sensor_timestamp: Uint64;
}
SDL_QuitEvent :: struct {
    type:      SDL_EventType;
    reserved:  Uint32;
    timestamp: Uint64;
}
SDL_UserEvent :: struct {
    type:      Uint32;
    reserved:  Uint32;
    timestamp: Uint64;
    windowID:  SDL_WindowID;
    code:      Sint32;
    data1:     *void;
    data2:     *void;
}
SDL_Event :: union {
    type:            Uint32;
    common:          SDL_CommonEvent;
    display:         SDL_DisplayEvent;
    window:          SDL_WindowEvent;
    kdevice:         SDL_KeyboardDeviceEvent;
    key:             SDL_KeyboardEvent;
    edit:            SDL_TextEditingEvent;
    edit_candidates: SDL_TextEditingCandidatesEvent;
    text:            SDL_TextInputEvent;
    mdevice:         SDL_MouseDeviceEvent;
    motion:          SDL_MouseMotionEvent;
    button:          SDL_MouseButtonEvent;
    wheel:           SDL_MouseWheelEvent;
    jdevice:         SDL_JoyDeviceEvent;
    jaxis:           SDL_JoyAxisEvent;
    jball:           SDL_JoyBallEvent;
    jhat:            SDL_JoyHatEvent;
    jbutton:         SDL_JoyButtonEvent;
    jbattery:        SDL_JoyBatteryEvent;
    gdevice:         SDL_GamepadDeviceEvent;
    gaxis:           SDL_GamepadAxisEvent;
    gbutton:         SDL_GamepadButtonEvent;
    gtouchpad:       SDL_GamepadTouchpadEvent;
    gsensor:         SDL_GamepadSensorEvent;
    adevice:         SDL_AudioDeviceEvent;
    cdevice:         SDL_CameraDeviceEvent;
    sensor:          SDL_SensorEvent;
    quit:            SDL_QuitEvent;
    user:            SDL_UserEvent;
    tfinger:         SDL_TouchFingerEvent;
    pproximity:      SDL_PenProximityEvent;
    ptouch:          SDL_PenTouchEvent;
    pmotion:         SDL_PenMotionEvent;
    pbutton:         SDL_PenButtonEvent;
    paxis:           SDL_PenAxisEvent;
    drop:            SDL_DropEvent;
    clipboard:       SDL_ClipboardEvent;
    padding:         [128] Uint8;
}
SDL_PumpEvents :: () -> void #foreign sdl3;
SDL_EventAction :: enum s32 {
    ADDEVENT  :: 0;
    PEEKEVENT :: 1;
    GETEVENT  :: 2;

    SDL_ADDEVENT  :: ADDEVENT;
    SDL_PEEKEVENT :: PEEKEVENT;
    SDL_GETEVENT  :: GETEVENT;
}
SDL_PeepEvents :: (events: *SDL_Event, numevents: s32, action: SDL_EventAction, minType: Uint32, maxType: Uint32) -> s32 #foreign sdl3;
SDL_HasEvent :: (type: Uint32) -> bool #foreign sdl3;
SDL_HasEvents :: (minType: Uint32, maxType: Uint32) -> bool #foreign sdl3;
SDL_FlushEvent :: (type: Uint32) -> void #foreign sdl3;
SDL_FlushEvents :: (minType: Uint32, maxType: Uint32) -> void #foreign sdl3;
SDL_PollEvent :: (event: *SDL_Event) -> bool #foreign sdl3;
SDL_WaitEvent :: (event: *SDL_Event) -> bool #foreign sdl3;
SDL_WaitEventTimeout :: (event: *SDL_Event, timeoutMS: Sint32) -> bool #foreign sdl3;
SDL_PushEvent :: (event: *SDL_Event) -> bool #foreign sdl3;
SDL_EventFilter :: #type (userdata: *void, event: *SDL_Event) -> bool #c_call;
SDL_SetEventFilter :: (filter: SDL_EventFilter, userdata: *void) -> void #foreign sdl3;
SDL_GetEventFilter :: (filter: *SDL_EventFilter, userdata: **void) -> bool #foreign sdl3;
SDL_AddEventWatch :: (filter: SDL_EventFilter, userdata: *void) -> bool #foreign sdl3;
SDL_RemoveEventWatch :: (filter: SDL_EventFilter, userdata: *void) -> void #foreign sdl3;
SDL_FilterEvents :: (filter: SDL_EventFilter, userdata: *void) -> void #foreign sdl3;
SDL_SetEventEnabled :: (type: Uint32, enabled: bool) -> void #foreign sdl3;
SDL_EventEnabled :: (type: Uint32) -> bool #foreign sdl3;
SDL_RegisterEvents :: (numevents: s32) -> Uint32 #foreign sdl3;
SDL_GetWindowFromEvent :: (event: *SDL_Event) -> *SDL_Window #foreign sdl3;
SDL_GetBasePath :: () -> *u8 #foreign sdl3;
SDL_GetPrefPath :: (org: *u8, app: *u8) -> *u8 #foreign sdl3;
SDL_Folder :: enum s32 {
    HOME        :: 0;
    DESKTOP     :: 1;
    DOCUMENTS   :: 2;
    DOWNLOADS   :: 3;
    MUSIC       :: 4;
    PICTURES    :: 5;
    PUBLICSHARE :: 6;
    SAVEDGAMES  :: 7;
    SCREENSHOTS :: 8;
    TEMPLATES   :: 9;
    VIDEOS      :: 10;
    COUNT       :: 11;

    SDL_FOLDER_HOME        :: HOME;
    SDL_FOLDER_DESKTOP     :: DESKTOP;
    SDL_FOLDER_DOCUMENTS   :: DOCUMENTS;
    SDL_FOLDER_DOWNLOADS   :: DOWNLOADS;
    SDL_FOLDER_MUSIC       :: MUSIC;
    SDL_FOLDER_PICTURES    :: PICTURES;
    SDL_FOLDER_PUBLICSHARE :: PUBLICSHARE;
    SDL_FOLDER_SAVEDGAMES  :: SAVEDGAMES;
    SDL_FOLDER_SCREENSHOTS :: SCREENSHOTS;
    SDL_FOLDER_TEMPLATES   :: TEMPLATES;
    SDL_FOLDER_VIDEOS      :: VIDEOS;
    SDL_FOLDER_COUNT       :: COUNT;
}
SDL_GetUserFolder :: (folder: SDL_Folder) -> *u8 #foreign sdl3;
SDL_PathType :: enum s32 {
    NONE      :: 0;
    FILE      :: 1;
    DIRECTORY :: 2;
    OTHER     :: 3;

    SDL_PATHTYPE_NONE      :: NONE;
    SDL_PATHTYPE_FILE      :: FILE;
    SDL_PATHTYPE_DIRECTORY :: DIRECTORY;
    SDL_PATHTYPE_OTHER     :: OTHER;
}
SDL_PathInfo :: struct {
    type:        SDL_PathType;
    size:        Uint64;
    create_time: SDL_Time;
    modify_time: SDL_Time;
    access_time: SDL_Time;
}
SDL_GlobFlags :: Uint32;
SDL_CreateDirectory :: (path: *u8) -> bool #foreign sdl3;
SDL_EnumerationResult :: enum s32 {
    CONTINUE :: 0;
    SUCCESS  :: 1;
    FAILURE  :: 2;

    SDL_ENUM_CONTINUE :: CONTINUE;
    SDL_ENUM_SUCCESS  :: SUCCESS;
    SDL_ENUM_FAILURE  :: FAILURE;
}
SDL_EnumerateDirectoryCallback :: #type (userdata: *void, dirname: *u8, fname: *u8) -> SDL_EnumerationResult #c_call;
SDL_EnumerateDirectory :: (path: *u8, callback: SDL_EnumerateDirectoryCallback, userdata: *void) -> bool #foreign sdl3;
SDL_RemovePath :: (path: *u8) -> bool #foreign sdl3;
SDL_RenamePath :: (oldpath: *u8, newpath: *u8) -> bool #foreign sdl3;
SDL_CopyFile :: (oldpath: *u8, newpath: *u8) -> bool #foreign sdl3;
SDL_GetPathInfo :: (path: *u8, info: *SDL_PathInfo) -> bool #foreign sdl3;
SDL_GlobDirectory :: (path: *u8, pattern: *u8, flags: SDL_GlobFlags, count: *s32) -> **u8 #foreign sdl3;
SDL_GPUDevice :: struct {}
SDL_GPUBuffer :: struct {}
SDL_GPUTransferBuffer :: struct {}
SDL_GPUTexture :: struct {}
SDL_GPUSampler :: struct {}
SDL_GPUShader :: struct {}
SDL_GPUComputePipeline :: struct {}
SDL_GPUGraphicsPipeline :: struct {}
SDL_GPUCommandBuffer :: struct {}
SDL_GPURenderPass :: struct {}
SDL_GPUComputePass :: struct {}
SDL_GPUCopyPass :: struct {}
SDL_GPUFence :: struct {}
SDL_GPUPrimitiveType :: enum s32 {
    TRIANGLELIST  :: 0;
    TRIANGLESTRIP :: 1;
    LINELIST      :: 2;
    LINESTRIP     :: 3;
    POINTLIST     :: 4;

    SDL_GPU_PRIMITIVETYPE_TRIANGLELIST  :: TRIANGLELIST;
    SDL_GPU_PRIMITIVETYPE_TRIANGLESTRIP :: TRIANGLESTRIP;
    SDL_GPU_PRIMITIVETYPE_LINELIST      :: LINELIST;
    SDL_GPU_PRIMITIVETYPE_LINESTRIP     :: LINESTRIP;
    SDL_GPU_PRIMITIVETYPE_POINTLIST     :: POINTLIST;
}
SDL_GPULoadOp :: enum s32 {
    LOAD      :: 0;
    CLEAR     :: 1;
    DONT_CARE :: 2;

    SDL_GPU_LOADOP_LOAD      :: LOAD;
    SDL_GPU_LOADOP_CLEAR     :: CLEAR;
    SDL_GPU_LOADOP_DONT_CARE :: DONT_CARE;
}
SDL_GPUStoreOp :: enum s32 {
    STORE             :: 0;
    DONT_CARE         :: 1;
    RESOLVE           :: 2;
    RESOLVE_AND_STORE :: 3;

    SDL_GPU_STOREOP_STORE             :: STORE;
    SDL_GPU_STOREOP_DONT_CARE         :: DONT_CARE;
    SDL_GPU_STOREOP_RESOLVE           :: RESOLVE;
    SDL_GPU_STOREOP_RESOLVE_AND_STORE :: RESOLVE_AND_STORE;
}
SDL_GPUIndexElementSize :: enum s32 {
    _16BIT :: 0;
    _32BIT :: 1;

    SDL_GPU_INDEXELEMENTSIZE_16BIT :: _16BIT;
    SDL_GPU_INDEXELEMENTSIZE_32BIT :: _32BIT;
}
SDL_GPUTextureFormat :: enum s32 {
    INVALID               :: 0;
    A8_UNORM              :: 1;
    R8_UNORM              :: 2;
    R8G8_UNORM            :: 3;
    R8G8B8A8_UNORM        :: 4;
    R16_UNORM             :: 5;
    R16G16_UNORM          :: 6;
    R16G16B16A16_UNORM    :: 7;
    R10G10B10A2_UNORM     :: 8;
    B5G6R5_UNORM          :: 9;
    B5G5R5A1_UNORM        :: 10;
    B4G4R4A4_UNORM        :: 11;
    B8G8R8A8_UNORM        :: 12;
    BC1_RGBA_UNORM        :: 13;
    BC2_RGBA_UNORM        :: 14;
    BC3_RGBA_UNORM        :: 15;
    BC4_R_UNORM           :: 16;
    BC5_RG_UNORM          :: 17;
    BC7_RGBA_UNORM        :: 18;
    BC6H_RGB_FLOAT        :: 19;
    BC6H_RGB_UFLOAT       :: 20;
    R8_SNORM              :: 21;
    R8G8_SNORM            :: 22;
    R8G8B8A8_SNORM        :: 23;
    R16_SNORM             :: 24;
    R16G16_SNORM          :: 25;
    R16G16B16A16_SNORM    :: 26;
    R16_FLOAT             :: 27;
    R16G16_FLOAT          :: 28;
    R16G16B16A16_FLOAT    :: 29;
    R32_FLOAT             :: 30;
    R32G32_FLOAT          :: 31;
    R32G32B32A32_FLOAT    :: 32;
    R11G11B10_UFLOAT      :: 33;
    R8_UINT               :: 34;
    R8G8_UINT             :: 35;
    R8G8B8A8_UINT         :: 36;
    R16_UINT              :: 37;
    R16G16_UINT           :: 38;
    R16G16B16A16_UINT     :: 39;
    R32_UINT              :: 40;
    R32G32_UINT           :: 41;
    R32G32B32A32_UINT     :: 42;
    R8_INT                :: 43;
    R8G8_INT              :: 44;
    R8G8B8A8_INT          :: 45;
    R16_INT               :: 46;
    R16G16_INT            :: 47;
    R16G16B16A16_INT      :: 48;
    R32_INT               :: 49;
    R32G32_INT            :: 50;
    R32G32B32A32_INT      :: 51;
    R8G8B8A8_UNORM_SRGB   :: 52;
    B8G8R8A8_UNORM_SRGB   :: 53;
    BC1_RGBA_UNORM_SRGB   :: 54;
    BC2_RGBA_UNORM_SRGB   :: 55;
    BC3_RGBA_UNORM_SRGB   :: 56;
    BC7_RGBA_UNORM_SRGB   :: 57;
    D16_UNORM             :: 58;
    D24_UNORM             :: 59;
    D32_FLOAT             :: 60;
    D24_UNORM_S8_UINT     :: 61;
    D32_FLOAT_S8_UINT     :: 62;
    ASTC_4x4_UNORM        :: 63;
    ASTC_5x4_UNORM        :: 64;
    ASTC_5x5_UNORM        :: 65;
    ASTC_6x5_UNORM        :: 66;
    ASTC_6x6_UNORM        :: 67;
    ASTC_8x5_UNORM        :: 68;
    ASTC_8x6_UNORM        :: 69;
    ASTC_8x8_UNORM        :: 70;
    ASTC_10x5_UNORM       :: 71;
    ASTC_10x6_UNORM       :: 72;
    ASTC_10x8_UNORM       :: 73;
    ASTC_10x10_UNORM      :: 74;
    ASTC_12x10_UNORM      :: 75;
    ASTC_12x12_UNORM      :: 76;
    ASTC_4x4_UNORM_SRGB   :: 77;
    ASTC_5x4_UNORM_SRGB   :: 78;
    ASTC_5x5_UNORM_SRGB   :: 79;
    ASTC_6x5_UNORM_SRGB   :: 80;
    ASTC_6x6_UNORM_SRGB   :: 81;
    ASTC_8x5_UNORM_SRGB   :: 82;
    ASTC_8x6_UNORM_SRGB   :: 83;
    ASTC_8x8_UNORM_SRGB   :: 84;
    ASTC_10x5_UNORM_SRGB  :: 85;
    ASTC_10x6_UNORM_SRGB  :: 86;
    ASTC_10x8_UNORM_SRGB  :: 87;
    ASTC_10x10_UNORM_SRGB :: 88;
    ASTC_12x10_UNORM_SRGB :: 89;
    ASTC_12x12_UNORM_SRGB :: 90;
    ASTC_4x4_FLOAT        :: 91;
    ASTC_5x4_FLOAT        :: 92;
    ASTC_5x5_FLOAT        :: 93;
    ASTC_6x5_FLOAT        :: 94;
    ASTC_6x6_FLOAT        :: 95;
    ASTC_8x5_FLOAT        :: 96;
    ASTC_8x6_FLOAT        :: 97;
    ASTC_8x8_FLOAT        :: 98;
    ASTC_10x5_FLOAT       :: 99;
    ASTC_10x6_FLOAT       :: 100;
    ASTC_10x8_FLOAT       :: 101;
    ASTC_10x10_FLOAT      :: 102;
    ASTC_12x10_FLOAT      :: 103;
    ASTC_12x12_FLOAT      :: 104;

    SDL_GPU_TEXTUREFORMAT_INVALID               :: INVALID;
    SDL_GPU_TEXTUREFORMAT_A8_UNORM              :: A8_UNORM;
    SDL_GPU_TEXTUREFORMAT_R8_UNORM              :: R8_UNORM;
    SDL_GPU_TEXTUREFORMAT_R8G8_UNORM            :: R8G8_UNORM;
    SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UNORM        :: R8G8B8A8_UNORM;
    SDL_GPU_TEXTUREFORMAT_R16_UNORM             :: R16_UNORM;
    SDL_GPU_TEXTUREFORMAT_R16G16_UNORM          :: R16G16_UNORM;
    SDL_GPU_TEXTUREFORMAT_R16G16B16A16_UNORM    :: R16G16B16A16_UNORM;
    SDL_GPU_TEXTUREFORMAT_R10G10B10A2_UNORM     :: R10G10B10A2_UNORM;
    SDL_GPU_TEXTUREFORMAT_B5G6R5_UNORM          :: B5G6R5_UNORM;
    SDL_GPU_TEXTUREFORMAT_B5G5R5A1_UNORM        :: B5G5R5A1_UNORM;
    SDL_GPU_TEXTUREFORMAT_B4G4R4A4_UNORM        :: B4G4R4A4_UNORM;
    SDL_GPU_TEXTUREFORMAT_B8G8R8A8_UNORM        :: B8G8R8A8_UNORM;
    SDL_GPU_TEXTUREFORMAT_BC1_RGBA_UNORM        :: BC1_RGBA_UNORM;
    SDL_GPU_TEXTUREFORMAT_BC2_RGBA_UNORM        :: BC2_RGBA_UNORM;
    SDL_GPU_TEXTUREFORMAT_BC3_RGBA_UNORM        :: BC3_RGBA_UNORM;
    SDL_GPU_TEXTUREFORMAT_BC4_R_UNORM           :: BC4_R_UNORM;
    SDL_GPU_TEXTUREFORMAT_BC5_RG_UNORM          :: BC5_RG_UNORM;
    SDL_GPU_TEXTUREFORMAT_BC7_RGBA_UNORM        :: BC7_RGBA_UNORM;
    SDL_GPU_TEXTUREFORMAT_BC6H_RGB_FLOAT        :: BC6H_RGB_FLOAT;
    SDL_GPU_TEXTUREFORMAT_BC6H_RGB_UFLOAT       :: BC6H_RGB_UFLOAT;
    SDL_GPU_TEXTUREFORMAT_R8_SNORM              :: R8_SNORM;
    SDL_GPU_TEXTUREFORMAT_R8G8_SNORM            :: R8G8_SNORM;
    SDL_GPU_TEXTUREFORMAT_R8G8B8A8_SNORM        :: R8G8B8A8_SNORM;
    SDL_GPU_TEXTUREFORMAT_R16_SNORM             :: R16_SNORM;
    SDL_GPU_TEXTUREFORMAT_R16G16_SNORM          :: R16G16_SNORM;
    SDL_GPU_TEXTUREFORMAT_R16G16B16A16_SNORM    :: R16G16B16A16_SNORM;
    SDL_GPU_TEXTUREFORMAT_R16_FLOAT             :: R16_FLOAT;
    SDL_GPU_TEXTUREFORMAT_R16G16_FLOAT          :: R16G16_FLOAT;
    SDL_GPU_TEXTUREFORMAT_R16G16B16A16_FLOAT    :: R16G16B16A16_FLOAT;
    SDL_GPU_TEXTUREFORMAT_R32_FLOAT             :: R32_FLOAT;
    SDL_GPU_TEXTUREFORMAT_R32G32_FLOAT          :: R32G32_FLOAT;
    SDL_GPU_TEXTUREFORMAT_R32G32B32A32_FLOAT    :: R32G32B32A32_FLOAT;
    SDL_GPU_TEXTUREFORMAT_R11G11B10_UFLOAT      :: R11G11B10_UFLOAT;
    SDL_GPU_TEXTUREFORMAT_R8_UINT               :: R8_UINT;
    SDL_GPU_TEXTUREFORMAT_R8G8_UINT             :: R8G8_UINT;
    SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UINT         :: R8G8B8A8_UINT;
    SDL_GPU_TEXTUREFORMAT_R16_UINT              :: R16_UINT;
    SDL_GPU_TEXTUREFORMAT_R16G16_UINT           :: R16G16_UINT;
    SDL_GPU_TEXTUREFORMAT_R16G16B16A16_UINT     :: R16G16B16A16_UINT;
    SDL_GPU_TEXTUREFORMAT_R32_UINT              :: R32_UINT;
    SDL_GPU_TEXTUREFORMAT_R32G32_UINT           :: R32G32_UINT;
    SDL_GPU_TEXTUREFORMAT_R32G32B32A32_UINT     :: R32G32B32A32_UINT;
    SDL_GPU_TEXTUREFORMAT_R8_INT                :: R8_INT;
    SDL_GPU_TEXTUREFORMAT_R8G8_INT              :: R8G8_INT;
    SDL_GPU_TEXTUREFORMAT_R8G8B8A8_INT          :: R8G8B8A8_INT;
    SDL_GPU_TEXTUREFORMAT_R16_INT               :: R16_INT;
    SDL_GPU_TEXTUREFORMAT_R16G16_INT            :: R16G16_INT;
    SDL_GPU_TEXTUREFORMAT_R16G16B16A16_INT      :: R16G16B16A16_INT;
    SDL_GPU_TEXTUREFORMAT_R32_INT               :: R32_INT;
    SDL_GPU_TEXTUREFORMAT_R32G32_INT            :: R32G32_INT;
    SDL_GPU_TEXTUREFORMAT_R32G32B32A32_INT      :: R32G32B32A32_INT;
    SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UNORM_SRGB   :: R8G8B8A8_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_B8G8R8A8_UNORM_SRGB   :: B8G8R8A8_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_BC1_RGBA_UNORM_SRGB   :: BC1_RGBA_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_BC2_RGBA_UNORM_SRGB   :: BC2_RGBA_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_BC3_RGBA_UNORM_SRGB   :: BC3_RGBA_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_BC7_RGBA_UNORM_SRGB   :: BC7_RGBA_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_D16_UNORM             :: D16_UNORM;
    SDL_GPU_TEXTUREFORMAT_D24_UNORM             :: D24_UNORM;
    SDL_GPU_TEXTUREFORMAT_D32_FLOAT             :: D32_FLOAT;
    SDL_GPU_TEXTUREFORMAT_D24_UNORM_S8_UINT     :: D24_UNORM_S8_UINT;
    SDL_GPU_TEXTUREFORMAT_D32_FLOAT_S8_UINT     :: D32_FLOAT_S8_UINT;
    SDL_GPU_TEXTUREFORMAT_ASTC_4x4_UNORM        :: ASTC_4x4_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_5x4_UNORM        :: ASTC_5x4_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_5x5_UNORM        :: ASTC_5x5_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_6x5_UNORM        :: ASTC_6x5_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_6x6_UNORM        :: ASTC_6x6_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_8x5_UNORM        :: ASTC_8x5_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_8x6_UNORM        :: ASTC_8x6_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_8x8_UNORM        :: ASTC_8x8_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_10x5_UNORM       :: ASTC_10x5_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_10x6_UNORM       :: ASTC_10x6_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_10x8_UNORM       :: ASTC_10x8_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_10x10_UNORM      :: ASTC_10x10_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_12x10_UNORM      :: ASTC_12x10_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_12x12_UNORM      :: ASTC_12x12_UNORM;
    SDL_GPU_TEXTUREFORMAT_ASTC_4x4_UNORM_SRGB   :: ASTC_4x4_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_5x4_UNORM_SRGB   :: ASTC_5x4_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_5x5_UNORM_SRGB   :: ASTC_5x5_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_6x5_UNORM_SRGB   :: ASTC_6x5_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_6x6_UNORM_SRGB   :: ASTC_6x6_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_8x5_UNORM_SRGB   :: ASTC_8x5_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_8x6_UNORM_SRGB   :: ASTC_8x6_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_8x8_UNORM_SRGB   :: ASTC_8x8_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_10x5_UNORM_SRGB  :: ASTC_10x5_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_10x6_UNORM_SRGB  :: ASTC_10x6_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_10x8_UNORM_SRGB  :: ASTC_10x8_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_10x10_UNORM_SRGB :: ASTC_10x10_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_12x10_UNORM_SRGB :: ASTC_12x10_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_12x12_UNORM_SRGB :: ASTC_12x12_UNORM_SRGB;
    SDL_GPU_TEXTUREFORMAT_ASTC_4x4_FLOAT        :: ASTC_4x4_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_5x4_FLOAT        :: ASTC_5x4_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_5x5_FLOAT        :: ASTC_5x5_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_6x5_FLOAT        :: ASTC_6x5_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_6x6_FLOAT        :: ASTC_6x6_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_8x5_FLOAT        :: ASTC_8x5_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_8x6_FLOAT        :: ASTC_8x6_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_8x8_FLOAT        :: ASTC_8x8_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_10x5_FLOAT       :: ASTC_10x5_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_10x6_FLOAT       :: ASTC_10x6_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_10x8_FLOAT       :: ASTC_10x8_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_10x10_FLOAT      :: ASTC_10x10_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_12x10_FLOAT      :: ASTC_12x10_FLOAT;
    SDL_GPU_TEXTUREFORMAT_ASTC_12x12_FLOAT      :: ASTC_12x12_FLOAT;
}
SDL_GPUTextureUsageFlags :: Uint32;
SDL_GPUTextureType :: enum s32 {
    _2D        :: 0;
    _2D_ARRAY  :: 1;
    _3D        :: 2;
    CUBE       :: 3;
    CUBE_ARRAY :: 4;

    SDL_GPU_TEXTURETYPE_2D         :: _2D;
    SDL_GPU_TEXTURETYPE_2D_ARRAY   :: _2D_ARRAY;
    SDL_GPU_TEXTURETYPE_3D         :: _3D;
    SDL_GPU_TEXTURETYPE_CUBE       :: CUBE;
    SDL_GPU_TEXTURETYPE_CUBE_ARRAY :: CUBE_ARRAY;
}
SDL_GPUSampleCount :: enum s32 {
    _1 :: 0;
    _2 :: 1;
    _4 :: 2;
    _8 :: 3;

    SDL_GPU_SAMPLECOUNT_1 :: _1;
    SDL_GPU_SAMPLECOUNT_2 :: _2;
    SDL_GPU_SAMPLECOUNT_4 :: _4;
    SDL_GPU_SAMPLECOUNT_8 :: _8;
}
SDL_GPUCubeMapFace :: enum s32 {
    POSITIVEX :: 0;
    NEGATIVEX :: 1;
    POSITIVEY :: 2;
    NEGATIVEY :: 3;
    POSITIVEZ :: 4;
    NEGATIVEZ :: 5;

    SDL_GPU_CUBEMAPFACE_POSITIVEX :: POSITIVEX;
    SDL_GPU_CUBEMAPFACE_NEGATIVEX :: NEGATIVEX;
    SDL_GPU_CUBEMAPFACE_POSITIVEY :: POSITIVEY;
    SDL_GPU_CUBEMAPFACE_NEGATIVEY :: NEGATIVEY;
    SDL_GPU_CUBEMAPFACE_POSITIVEZ :: POSITIVEZ;
    SDL_GPU_CUBEMAPFACE_NEGATIVEZ :: NEGATIVEZ;
}
SDL_GPUBufferUsageFlags :: Uint32;
SDL_GPUTransferBufferUsage :: enum s32 {
    UPLOAD   :: 0;
    DOWNLOAD :: 1;

    SDL_GPU_TRANSFERBUFFERUSAGE_UPLOAD   :: UPLOAD;
    SDL_GPU_TRANSFERBUFFERUSAGE_DOWNLOAD :: DOWNLOAD;
}
SDL_GPUShaderStage :: enum s32 {
    VERTEX   :: 0;
    FRAGMENT :: 1;

    SDL_GPU_SHADERSTAGE_VERTEX   :: VERTEX;
    SDL_GPU_SHADERSTAGE_FRAGMENT :: FRAGMENT;
}
SDL_GPUShaderFormat :: Uint32;
SDL_GPUVertexElementFormat :: enum s32 {
    INVALID      :: 0;
    INT          :: 1;
    INT2         :: 2;
    INT3         :: 3;
    INT4         :: 4;
    UINT         :: 5;
    UINT2        :: 6;
    UINT3        :: 7;
    UINT4        :: 8;
    FLOAT        :: 9;
    FLOAT2       :: 10;
    FLOAT3       :: 11;
    FLOAT4       :: 12;
    BYTE2        :: 13;
    BYTE4        :: 14;
    UBYTE2       :: 15;
    UBYTE4       :: 16;
    BYTE2_NORM   :: 17;
    BYTE4_NORM   :: 18;
    UBYTE2_NORM  :: 19;
    UBYTE4_NORM  :: 20;
    SHORT2       :: 21;
    SHORT4       :: 22;
    USHORT2      :: 23;
    USHORT4      :: 24;
    SHORT2_NORM  :: 25;
    SHORT4_NORM  :: 26;
    USHORT2_NORM :: 27;
    USHORT4_NORM :: 28;
    HALF2        :: 29;
    HALF4        :: 30;

    SDL_GPU_VERTEXELEMENTFORMAT_INVALID      :: INVALID;
    SDL_GPU_VERTEXELEMENTFORMAT_INT          :: INT;
    SDL_GPU_VERTEXELEMENTFORMAT_INT2         :: INT2;
    SDL_GPU_VERTEXELEMENTFORMAT_INT3         :: INT3;
    SDL_GPU_VERTEXELEMENTFORMAT_INT4         :: INT4;
    SDL_GPU_VERTEXELEMENTFORMAT_UINT         :: UINT;
    SDL_GPU_VERTEXELEMENTFORMAT_UINT2        :: UINT2;
    SDL_GPU_VERTEXELEMENTFORMAT_UINT3        :: UINT3;
    SDL_GPU_VERTEXELEMENTFORMAT_UINT4        :: UINT4;
    SDL_GPU_VERTEXELEMENTFORMAT_FLOAT        :: FLOAT;
    SDL_GPU_VERTEXELEMENTFORMAT_FLOAT2       :: FLOAT2;
    SDL_GPU_VERTEXELEMENTFORMAT_FLOAT3       :: FLOAT3;
    SDL_GPU_VERTEXELEMENTFORMAT_FLOAT4       :: FLOAT4;
    SDL_GPU_VERTEXELEMENTFORMAT_BYTE2        :: BYTE2;
    SDL_GPU_VERTEXELEMENTFORMAT_BYTE4        :: BYTE4;
    SDL_GPU_VERTEXELEMENTFORMAT_UBYTE2       :: UBYTE2;
    SDL_GPU_VERTEXELEMENTFORMAT_UBYTE4       :: UBYTE4;
    SDL_GPU_VERTEXELEMENTFORMAT_BYTE2_NORM   :: BYTE2_NORM;
    SDL_GPU_VERTEXELEMENTFORMAT_BYTE4_NORM   :: BYTE4_NORM;
    SDL_GPU_VERTEXELEMENTFORMAT_UBYTE2_NORM  :: UBYTE2_NORM;
    SDL_GPU_VERTEXELEMENTFORMAT_UBYTE4_NORM  :: UBYTE4_NORM;
    SDL_GPU_VERTEXELEMENTFORMAT_SHORT2       :: SHORT2;
    SDL_GPU_VERTEXELEMENTFORMAT_SHORT4       :: SHORT4;
    SDL_GPU_VERTEXELEMENTFORMAT_USHORT2      :: USHORT2;
    SDL_GPU_VERTEXELEMENTFORMAT_USHORT4      :: USHORT4;
    SDL_GPU_VERTEXELEMENTFORMAT_SHORT2_NORM  :: SHORT2_NORM;
    SDL_GPU_VERTEXELEMENTFORMAT_SHORT4_NORM  :: SHORT4_NORM;
    SDL_GPU_VERTEXELEMENTFORMAT_USHORT2_NORM :: USHORT2_NORM;
    SDL_GPU_VERTEXELEMENTFORMAT_USHORT4_NORM :: USHORT4_NORM;
    SDL_GPU_VERTEXELEMENTFORMAT_HALF2        :: HALF2;
    SDL_GPU_VERTEXELEMENTFORMAT_HALF4        :: HALF4;
}
SDL_GPUVertexInputRate :: enum s32 {
    VERTEX   :: 0;
    INSTANCE :: 1;

    SDL_GPU_VERTEXINPUTRATE_VERTEX   :: VERTEX;
    SDL_GPU_VERTEXINPUTRATE_INSTANCE :: INSTANCE;
}
SDL_GPUFillMode :: enum s32 {
    FILL :: 0;
    LINE :: 1;

    SDL_GPU_FILLMODE_FILL :: FILL;
    SDL_GPU_FILLMODE_LINE :: LINE;
}
SDL_GPUCullMode :: enum s32 {
    NONE  :: 0;
    FRONT :: 1;
    BACK  :: 2;

    SDL_GPU_CULLMODE_NONE  :: NONE;
    SDL_GPU_CULLMODE_FRONT :: FRONT;
    SDL_GPU_CULLMODE_BACK  :: BACK;
}
SDL_GPUFrontFace :: enum s32 {
    COUNTER_CLOCKWISE :: 0;
    CLOCKWISE         :: 1;

    SDL_GPU_FRONTFACE_COUNTER_CLOCKWISE :: COUNTER_CLOCKWISE;
    SDL_GPU_FRONTFACE_CLOCKWISE         :: CLOCKWISE;
}
SDL_GPUCompareOp :: enum s32 {
    INVALID          :: 0;
    NEVER            :: 1;
    LESS             :: 2;
    EQUAL            :: 3;
    LESS_OR_EQUAL    :: 4;
    GREATER          :: 5;
    NOT_EQUAL        :: 6;
    GREATER_OR_EQUAL :: 7;
    ALWAYS           :: 8;

    SDL_GPU_COMPAREOP_INVALID          :: INVALID;
    SDL_GPU_COMPAREOP_NEVER            :: NEVER;
    SDL_GPU_COMPAREOP_LESS             :: LESS;
    SDL_GPU_COMPAREOP_EQUAL            :: EQUAL;
    SDL_GPU_COMPAREOP_LESS_OR_EQUAL    :: LESS_OR_EQUAL;
    SDL_GPU_COMPAREOP_GREATER          :: GREATER;
    SDL_GPU_COMPAREOP_NOT_EQUAL        :: NOT_EQUAL;
    SDL_GPU_COMPAREOP_GREATER_OR_EQUAL :: GREATER_OR_EQUAL;
    SDL_GPU_COMPAREOP_ALWAYS           :: ALWAYS;
}
SDL_GPUStencilOp :: enum s32 {
    INVALID             :: 0;
    KEEP                :: 1;
    ZERO                :: 2;
    REPLACE             :: 3;
    INCREMENT_AND_CLAMP :: 4;
    DECREMENT_AND_CLAMP :: 5;
    INVERT              :: 6;
    INCREMENT_AND_WRAP  :: 7;
    DECREMENT_AND_WRAP  :: 8;

    SDL_GPU_STENCILOP_INVALID             :: INVALID;
    SDL_GPU_STENCILOP_KEEP                :: KEEP;
    SDL_GPU_STENCILOP_ZERO                :: ZERO;
    SDL_GPU_STENCILOP_REPLACE             :: REPLACE;
    SDL_GPU_STENCILOP_INCREMENT_AND_CLAMP :: INCREMENT_AND_CLAMP;
    SDL_GPU_STENCILOP_DECREMENT_AND_CLAMP :: DECREMENT_AND_CLAMP;
    SDL_GPU_STENCILOP_INVERT              :: INVERT;
    SDL_GPU_STENCILOP_INCREMENT_AND_WRAP  :: INCREMENT_AND_WRAP;
    SDL_GPU_STENCILOP_DECREMENT_AND_WRAP  :: DECREMENT_AND_WRAP;
}
SDL_GPUBlendOp :: enum s32 {
    INVALID          :: 0;
    ADD              :: 1;
    SUBTRACT         :: 2;
    REVERSE_SUBTRACT :: 3;
    MIN              :: 4;
    MAX              :: 5;

    SDL_GPU_BLENDOP_INVALID          :: INVALID;
    SDL_GPU_BLENDOP_ADD              :: ADD;
    SDL_GPU_BLENDOP_SUBTRACT         :: SUBTRACT;
    SDL_GPU_BLENDOP_REVERSE_SUBTRACT :: REVERSE_SUBTRACT;
    SDL_GPU_BLENDOP_MIN              :: MIN;
    SDL_GPU_BLENDOP_MAX              :: MAX;
}
SDL_GPUBlendFactor :: enum s32 {
    INVALID                  :: 0;
    ZERO                     :: 1;
    ONE                      :: 2;
    SRC_COLOR                :: 3;
    ONE_MINUS_SRC_COLOR      :: 4;
    DST_COLOR                :: 5;
    ONE_MINUS_DST_COLOR      :: 6;
    SRC_ALPHA                :: 7;
    ONE_MINUS_SRC_ALPHA      :: 8;
    DST_ALPHA                :: 9;
    ONE_MINUS_DST_ALPHA      :: 10;
    CONSTANT_COLOR           :: 11;
    ONE_MINUS_CONSTANT_COLOR :: 12;
    SRC_ALPHA_SATURATE       :: 13;

    SDL_GPU_BLENDFACTOR_INVALID                  :: INVALID;
    SDL_GPU_BLENDFACTOR_ZERO                     :: ZERO;
    SDL_GPU_BLENDFACTOR_ONE                      :: ONE;
    SDL_GPU_BLENDFACTOR_SRC_COLOR                :: SRC_COLOR;
    SDL_GPU_BLENDFACTOR_ONE_MINUS_SRC_COLOR      :: ONE_MINUS_SRC_COLOR;
    SDL_GPU_BLENDFACTOR_DST_COLOR                :: DST_COLOR;
    SDL_GPU_BLENDFACTOR_ONE_MINUS_DST_COLOR      :: ONE_MINUS_DST_COLOR;
    SDL_GPU_BLENDFACTOR_SRC_ALPHA                :: SRC_ALPHA;
    SDL_GPU_BLENDFACTOR_ONE_MINUS_SRC_ALPHA      :: ONE_MINUS_SRC_ALPHA;
    SDL_GPU_BLENDFACTOR_DST_ALPHA                :: DST_ALPHA;
    SDL_GPU_BLENDFACTOR_ONE_MINUS_DST_ALPHA      :: ONE_MINUS_DST_ALPHA;
    SDL_GPU_BLENDFACTOR_CONSTANT_COLOR           :: CONSTANT_COLOR;
    SDL_GPU_BLENDFACTOR_ONE_MINUS_CONSTANT_COLOR :: ONE_MINUS_CONSTANT_COLOR;
    SDL_GPU_BLENDFACTOR_SRC_ALPHA_SATURATE       :: SRC_ALPHA_SATURATE;
}
SDL_GPUColorComponentFlags :: Uint8;
SDL_GPUFilter :: enum s32 {
    NEAREST :: 0;
    LINEAR  :: 1;

    SDL_GPU_FILTER_NEAREST :: NEAREST;
    SDL_GPU_FILTER_LINEAR  :: LINEAR;
}
SDL_GPUSamplerMipmapMode :: enum s32 {
    NEAREST :: 0;
    LINEAR  :: 1;

    SDL_GPU_SAMPLERMIPMAPMODE_NEAREST :: NEAREST;
    SDL_GPU_SAMPLERMIPMAPMODE_LINEAR  :: LINEAR;
}
SDL_GPUSamplerAddressMode :: enum s32 {
    REPEAT          :: 0;
    MIRRORED_REPEAT :: 1;
    CLAMP_TO_EDGE   :: 2;

    SDL_GPU_SAMPLERADDRESSMODE_REPEAT          :: REPEAT;
    SDL_GPU_SAMPLERADDRESSMODE_MIRRORED_REPEAT :: MIRRORED_REPEAT;
    SDL_GPU_SAMPLERADDRESSMODE_CLAMP_TO_EDGE   :: CLAMP_TO_EDGE;
}
SDL_GPUPresentMode :: enum s32 {
    VSYNC     :: 0;
    IMMEDIATE :: 1;
    MAILBOX   :: 2;

    SDL_GPU_PRESENTMODE_VSYNC     :: VSYNC;
    SDL_GPU_PRESENTMODE_IMMEDIATE :: IMMEDIATE;
    SDL_GPU_PRESENTMODE_MAILBOX   :: MAILBOX;
}
SDL_GPUSwapchainComposition :: enum s32 {
    SDR                 :: 0;
    SDR_LINEAR          :: 1;
    HDR_EXTENDED_LINEAR :: 2;
    HDR10_ST2048        :: 3;

    SDL_GPU_SWAPCHAINCOMPOSITION_SDR                 :: SDR;
    SDL_GPU_SWAPCHAINCOMPOSITION_SDR_LINEAR          :: SDR_LINEAR;
    SDL_GPU_SWAPCHAINCOMPOSITION_HDR_EXTENDED_LINEAR :: HDR_EXTENDED_LINEAR;
    SDL_GPU_SWAPCHAINCOMPOSITION_HDR10_ST2048        :: HDR10_ST2048;
}
SDL_GPUViewport :: struct {
    x:         float;
    y:         float;
    w:         float;
    h:         float;
    min_depth: float;
    max_depth: float;
}
SDL_GPUTextureTransferInfo :: struct {
    transfer_buffer: *SDL_GPUTransferBuffer;
    offset:          Uint32;
    pixels_per_row:  Uint32;
    rows_per_layer:  Uint32;
}
SDL_GPUTransferBufferLocation :: struct {
    transfer_buffer: *SDL_GPUTransferBuffer;
    offset:          Uint32;
}
SDL_GPUTextureLocation :: struct {
    texture:   *SDL_GPUTexture;
    mip_level: Uint32;
    layer:     Uint32;
    x:         Uint32;
    y:         Uint32;
    z:         Uint32;
}
SDL_GPUTextureRegion :: struct {
    texture:   *SDL_GPUTexture;
    mip_level: Uint32;
    layer:     Uint32;
    x:         Uint32;
    y:         Uint32;
    z:         Uint32;
    w:         Uint32;
    h:         Uint32;
    d:         Uint32;
}
SDL_GPUBlitRegion :: struct {
    texture:              *SDL_GPUTexture;
    mip_level:            Uint32;
    layer_or_depth_plane: Uint32;
    x:                    Uint32;
    y:                    Uint32;
    w:                    Uint32;
    h:                    Uint32;
}
SDL_GPUBufferLocation :: struct {
    buffer: *SDL_GPUBuffer;
    offset: Uint32;
}
SDL_GPUBufferRegion :: struct {
    buffer: *SDL_GPUBuffer;
    offset: Uint32;
    size:   Uint32;
}
SDL_GPUIndirectDrawCommand :: struct {
    num_vertices:   Uint32;
    num_instances:  Uint32;
    first_vertex:   Uint32;
    first_instance: Uint32;
}
SDL_GPUIndexedIndirectDrawCommand :: struct {
    num_indices:    Uint32;
    num_instances:  Uint32;
    first_index:    Uint32;
    vertex_offset:  Sint32;
    first_instance: Uint32;
}
SDL_GPUIndirectDispatchCommand :: struct {
    groupcount_x: Uint32;
    groupcount_y: Uint32;
    groupcount_z: Uint32;
}
SDL_GPUSamplerCreateInfo :: struct {
    min_filter:        SDL_GPUFilter;
    mag_filter:        SDL_GPUFilter;
    mipmap_mode:       SDL_GPUSamplerMipmapMode;
    address_mode_u:    SDL_GPUSamplerAddressMode;
    address_mode_v:    SDL_GPUSamplerAddressMode;
    address_mode_w:    SDL_GPUSamplerAddressMode;
    mip_lod_bias:      float;
    max_anisotropy:    float;
    compare_op:        SDL_GPUCompareOp;
    min_lod:           float;
    max_lod:           float;
    enable_anisotropy: bool;
    enable_compare:    bool;
    padding1:          Uint8;
    padding2:          Uint8;
    props:             SDL_PropertiesID;
}
SDL_GPUVertexBufferDescription :: struct {
    slot:               Uint32;
    pitch:              Uint32;
    input_rate:         SDL_GPUVertexInputRate;
    instance_step_rate: Uint32;
}
SDL_GPUVertexAttribute :: struct {
    location:    Uint32;
    buffer_slot: Uint32;
    format:      SDL_GPUVertexElementFormat;
    offset:      Uint32;
}
SDL_GPUVertexInputState :: struct {
    vertex_buffer_descriptions: *SDL_GPUVertexBufferDescription;
    num_vertex_buffers:         Uint32;
    vertex_attributes:          *SDL_GPUVertexAttribute;
    num_vertex_attributes:      Uint32;
}
SDL_GPUStencilOpState :: struct {
    fail_op:       SDL_GPUStencilOp;
    pass_op:       SDL_GPUStencilOp;
    depth_fail_op: SDL_GPUStencilOp;
    compare_op:    SDL_GPUCompareOp;
}
SDL_GPUColorTargetBlendState :: struct {
    src_color_blendfactor:   SDL_GPUBlendFactor;
    dst_color_blendfactor:   SDL_GPUBlendFactor;
    color_blend_op:          SDL_GPUBlendOp;
    src_alpha_blendfactor:   SDL_GPUBlendFactor;
    dst_alpha_blendfactor:   SDL_GPUBlendFactor;
    alpha_blend_op:          SDL_GPUBlendOp;
    color_write_mask:        SDL_GPUColorComponentFlags;
    enable_blend:            bool;
    enable_color_write_mask: bool;
    padding1:                Uint8;
    padding2:                Uint8;
}
SDL_GPUShaderCreateInfo :: struct {
    code_size:            u64;
    code:                 *Uint8;
    entrypoint:           *u8;
    format:               SDL_GPUShaderFormat;
    stage:                SDL_GPUShaderStage;
    num_samplers:         Uint32;
    num_storage_textures: Uint32;
    num_storage_buffers:  Uint32;
    num_uniform_buffers:  Uint32;
    props:                SDL_PropertiesID;
}
SDL_GPUTextureCreateInfo :: struct {
    type:                 SDL_GPUTextureType;
    format:               SDL_GPUTextureFormat;
    usage:                SDL_GPUTextureUsageFlags;
    width:                Uint32;
    height:               Uint32;
    layer_count_or_depth: Uint32;
    num_levels:           Uint32;
    sample_count:         SDL_GPUSampleCount;
    props:                SDL_PropertiesID;
}
SDL_GPUBufferCreateInfo :: struct {
    usage: SDL_GPUBufferUsageFlags;
    size:  Uint32;
    props: SDL_PropertiesID;
}
SDL_GPUTransferBufferCreateInfo :: struct {
    usage: SDL_GPUTransferBufferUsage;
    size:  Uint32;
    props: SDL_PropertiesID;
}
SDL_GPURasterizerState :: struct {
    fill_mode:                  SDL_GPUFillMode;
    cull_mode:                  SDL_GPUCullMode;
    front_face:                 SDL_GPUFrontFace;
    depth_bias_constant_factor: float;
    depth_bias_clamp:           float;
    depth_bias_slope_factor:    float;
    enable_depth_bias:          bool;
    enable_depth_clip:          bool;
    padding1:                   Uint8;
    padding2:                   Uint8;
}
SDL_GPUMultisampleState :: struct {
    sample_count: SDL_GPUSampleCount;
    sample_mask:  Uint32;
    enable_mask:  bool;
    padding1:     Uint8;
    padding2:     Uint8;
    padding3:     Uint8;
}
SDL_GPUDepthStencilState :: struct {
    compare_op:          SDL_GPUCompareOp;
    back_stencil_state:  SDL_GPUStencilOpState;
    front_stencil_state: SDL_GPUStencilOpState;
    compare_mask:        Uint8;
    write_mask:          Uint8;
    enable_depth_test:   bool;
    enable_depth_write:  bool;
    enable_stencil_test: bool;
    padding1:            Uint8;
    padding2:            Uint8;
    padding3:            Uint8;
}
SDL_GPUColorTargetDescription :: struct {
    format:      SDL_GPUTextureFormat;
    blend_state: SDL_GPUColorTargetBlendState;
}
SDL_GPUGraphicsPipelineTargetInfo :: struct {
    color_target_descriptions: *SDL_GPUColorTargetDescription;
    num_color_targets:         Uint32;
    depth_stencil_format:      SDL_GPUTextureFormat;
    has_depth_stencil_target:  bool;
    padding1:                  Uint8;
    padding2:                  Uint8;
    padding3:                  Uint8;
}
SDL_GPUGraphicsPipelineCreateInfo :: struct {
    vertex_shader:       *SDL_GPUShader;
    fragment_shader:     *SDL_GPUShader;
    vertex_input_state:  SDL_GPUVertexInputState;
    primitive_type:      SDL_GPUPrimitiveType;
    rasterizer_state:    SDL_GPURasterizerState;
    multisample_state:   SDL_GPUMultisampleState;
    depth_stencil_state: SDL_GPUDepthStencilState;
    target_info:         SDL_GPUGraphicsPipelineTargetInfo;
    props:               SDL_PropertiesID;
}
SDL_GPUComputePipelineCreateInfo :: struct {
    code_size:                      u64;
    code:                           *Uint8;
    entrypoint:                     *u8;
    format:                         SDL_GPUShaderFormat;
    num_samplers:                   Uint32;
    num_readonly_storage_textures:  Uint32;
    num_readonly_storage_buffers:   Uint32;
    num_readwrite_storage_textures: Uint32;
    num_readwrite_storage_buffers:  Uint32;
    num_uniform_buffers:            Uint32;
    threadcount_x:                  Uint32;
    threadcount_y:                  Uint32;
    threadcount_z:                  Uint32;
    props:                          SDL_PropertiesID;
}
SDL_GPUColorTargetInfo :: struct {
    texture:               *SDL_GPUTexture;
    mip_level:             Uint32;
    layer_or_depth_plane:  Uint32;
    clear_color:           SDL_FColor;
    load_op:               SDL_GPULoadOp;
    store_op:              SDL_GPUStoreOp;
    resolve_texture:       *SDL_GPUTexture;
    resolve_mip_level:     Uint32;
    resolve_layer:         Uint32;
    cycle:                 bool;
    cycle_resolve_texture: bool;
    padding1:              Uint8;
    padding2:              Uint8;
}
SDL_GPUDepthStencilTargetInfo :: struct {
    texture:          *SDL_GPUTexture;
    clear_depth:      float;
    load_op:          SDL_GPULoadOp;
    store_op:         SDL_GPUStoreOp;
    stencil_load_op:  SDL_GPULoadOp;
    stencil_store_op: SDL_GPUStoreOp;
    cycle:            bool;
    clear_stencil:    Uint8;
    padding1:         Uint8;
    padding2:         Uint8;
}
SDL_GPUBlitInfo :: struct {
    source:      SDL_GPUBlitRegion;
    destination: SDL_GPUBlitRegion;
    load_op:     SDL_GPULoadOp;
    clear_color: SDL_FColor;
    flip_mode:   SDL_FlipMode;
    filter:      SDL_GPUFilter;
    cycle:       bool;
    padding1:    Uint8;
    padding2:    Uint8;
    padding3:    Uint8;
}
SDL_GPUBufferBinding :: struct {
    buffer: *SDL_GPUBuffer;
    offset: Uint32;
}
SDL_GPUTextureSamplerBinding :: struct {
    texture: *SDL_GPUTexture;
    sampler: *SDL_GPUSampler;
}
SDL_GPUStorageBufferReadWriteBinding :: struct {
    buffer:   *SDL_GPUBuffer;
    cycle:    bool;
    padding1: Uint8;
    padding2: Uint8;
    padding3: Uint8;
}
SDL_GPUStorageTextureReadWriteBinding :: struct {
    texture:   *SDL_GPUTexture;
    mip_level: Uint32;
    layer:     Uint32;
    cycle:     bool;
    padding1:  Uint8;
    padding2:  Uint8;
    padding3:  Uint8;
}
SDL_GPUSupportsShaderFormats :: (format_flags: SDL_GPUShaderFormat, name: *u8) -> bool #foreign sdl3;
SDL_GPUSupportsProperties :: (props: SDL_PropertiesID) -> bool #foreign sdl3;
SDL_CreateGPUDevice :: (format_flags: SDL_GPUShaderFormat, debug_mode: bool, name: *u8) -> *SDL_GPUDevice #foreign sdl3;
SDL_CreateGPUDeviceWithProperties :: (props: SDL_PropertiesID) -> *SDL_GPUDevice #foreign sdl3;
SDL_DestroyGPUDevice :: (device: *SDL_GPUDevice) -> void #foreign sdl3;
SDL_GetNumGPUDrivers :: () -> s32 #foreign sdl3;
SDL_GetGPUDriver :: (index: s32) -> *u8 #foreign sdl3;
SDL_GetGPUDeviceDriver :: (device: *SDL_GPUDevice) -> *u8 #foreign sdl3;
SDL_GetGPUShaderFormats :: (device: *SDL_GPUDevice) -> SDL_GPUShaderFormat #foreign sdl3;
SDL_CreateGPUComputePipeline :: (device: *SDL_GPUDevice, createinfo: *SDL_GPUComputePipelineCreateInfo) -> *SDL_GPUComputePipeline #foreign sdl3;
SDL_CreateGPUGraphicsPipeline :: (device: *SDL_GPUDevice, createinfo: *SDL_GPUGraphicsPipelineCreateInfo) -> *SDL_GPUGraphicsPipeline #foreign sdl3;
SDL_CreateGPUSampler :: (device: *SDL_GPUDevice, createinfo: *SDL_GPUSamplerCreateInfo) -> *SDL_GPUSampler #foreign sdl3;
SDL_CreateGPUShader :: (device: *SDL_GPUDevice, createinfo: *SDL_GPUShaderCreateInfo) -> *SDL_GPUShader #foreign sdl3;
SDL_CreateGPUTexture :: (device: *SDL_GPUDevice, createinfo: *SDL_GPUTextureCreateInfo) -> *SDL_GPUTexture #foreign sdl3;
SDL_CreateGPUBuffer :: (device: *SDL_GPUDevice, createinfo: *SDL_GPUBufferCreateInfo) -> *SDL_GPUBuffer #foreign sdl3;
SDL_CreateGPUTransferBuffer :: (device: *SDL_GPUDevice, createinfo: *SDL_GPUTransferBufferCreateInfo) -> *SDL_GPUTransferBuffer #foreign sdl3;
SDL_SetGPUBufferName :: (device: *SDL_GPUDevice, buffer: *SDL_GPUBuffer, text: *u8) -> void #foreign sdl3;
SDL_SetGPUTextureName :: (device: *SDL_GPUDevice, texture: *SDL_GPUTexture, text: *u8) -> void #foreign sdl3;
SDL_InsertGPUDebugLabel :: (command_buffer: *SDL_GPUCommandBuffer, text: *u8) -> void #foreign sdl3;
SDL_PushGPUDebugGroup :: (command_buffer: *SDL_GPUCommandBuffer, name: *u8) -> void #foreign sdl3;
SDL_PopGPUDebugGroup :: (command_buffer: *SDL_GPUCommandBuffer) -> void #foreign sdl3;
SDL_ReleaseGPUTexture :: (device: *SDL_GPUDevice, texture: *SDL_GPUTexture) -> void #foreign sdl3;
SDL_ReleaseGPUSampler :: (device: *SDL_GPUDevice, sampler: *SDL_GPUSampler) -> void #foreign sdl3;
SDL_ReleaseGPUBuffer :: (device: *SDL_GPUDevice, buffer: *SDL_GPUBuffer) -> void #foreign sdl3;
SDL_ReleaseGPUTransferBuffer :: (device: *SDL_GPUDevice, transfer_buffer: *SDL_GPUTransferBuffer) -> void #foreign sdl3;
SDL_ReleaseGPUComputePipeline :: (device: *SDL_GPUDevice, compute_pipeline: *SDL_GPUComputePipeline) -> void #foreign sdl3;
SDL_ReleaseGPUShader :: (device: *SDL_GPUDevice, shader: *SDL_GPUShader) -> void #foreign sdl3;
SDL_ReleaseGPUGraphicsPipeline :: (device: *SDL_GPUDevice, graphics_pipeline: *SDL_GPUGraphicsPipeline) -> void #foreign sdl3;
SDL_AcquireGPUCommandBuffer :: (device: *SDL_GPUDevice) -> *SDL_GPUCommandBuffer #foreign sdl3;
SDL_PushGPUVertexUniformData :: (command_buffer: *SDL_GPUCommandBuffer, slot_index: Uint32, data: *void, length: Uint32) -> void #foreign sdl3;
SDL_PushGPUFragmentUniformData :: (command_buffer: *SDL_GPUCommandBuffer, slot_index: Uint32, data: *void, length: Uint32) -> void #foreign sdl3;
SDL_PushGPUComputeUniformData :: (command_buffer: *SDL_GPUCommandBuffer, slot_index: Uint32, data: *void, length: Uint32) -> void #foreign sdl3;
SDL_BeginGPURenderPass :: (command_buffer: *SDL_GPUCommandBuffer, color_target_infos: *SDL_GPUColorTargetInfo, num_color_targets: Uint32, depth_stencil_target_info: *SDL_GPUDepthStencilTargetInfo) -> *SDL_GPURenderPass #foreign sdl3;
SDL_BindGPUGraphicsPipeline :: (render_pass: *SDL_GPURenderPass, graphics_pipeline: *SDL_GPUGraphicsPipeline) -> void #foreign sdl3;
SDL_SetGPUViewport :: (render_pass: *SDL_GPURenderPass, viewport: *SDL_GPUViewport) -> void #foreign sdl3;
SDL_SetGPUScissor :: (render_pass: *SDL_GPURenderPass, scissor: *SDL_Rect) -> void #foreign sdl3;
SDL_SetGPUBlendConstants :: (render_pass: *SDL_GPURenderPass, blend_constants: SDL_FColor) -> void #foreign sdl3;
SDL_SetGPUStencilReference :: (render_pass: *SDL_GPURenderPass, reference: Uint8) -> void #foreign sdl3;
SDL_BindGPUVertexBuffers :: (render_pass: *SDL_GPURenderPass, first_slot: Uint32, bindings: *SDL_GPUBufferBinding, num_bindings: Uint32) -> void #foreign sdl3;
SDL_BindGPUIndexBuffer :: (render_pass: *SDL_GPURenderPass, binding: *SDL_GPUBufferBinding, index_element_size: SDL_GPUIndexElementSize) -> void #foreign sdl3;
SDL_BindGPUVertexSamplers :: (render_pass: *SDL_GPURenderPass, first_slot: Uint32, texture_sampler_bindings: *SDL_GPUTextureSamplerBinding, num_bindings: Uint32) -> void #foreign sdl3;
SDL_BindGPUVertexStorageTextures :: (render_pass: *SDL_GPURenderPass, first_slot: Uint32, storage_textures: **SDL_GPUTexture, num_bindings: Uint32) -> void #foreign sdl3;
SDL_BindGPUVertexStorageBuffers :: (render_pass: *SDL_GPURenderPass, first_slot: Uint32, storage_buffers: **SDL_GPUBuffer, num_bindings: Uint32) -> void #foreign sdl3;
SDL_BindGPUFragmentSamplers :: (render_pass: *SDL_GPURenderPass, first_slot: Uint32, texture_sampler_bindings: *SDL_GPUTextureSamplerBinding, num_bindings: Uint32) -> void #foreign sdl3;
SDL_BindGPUFragmentStorageTextures :: (render_pass: *SDL_GPURenderPass, first_slot: Uint32, storage_textures: **SDL_GPUTexture, num_bindings: Uint32) -> void #foreign sdl3;
SDL_BindGPUFragmentStorageBuffers :: (render_pass: *SDL_GPURenderPass, first_slot: Uint32, storage_buffers: **SDL_GPUBuffer, num_bindings: Uint32) -> void #foreign sdl3;
SDL_DrawGPUIndexedPrimitives :: (render_pass: *SDL_GPURenderPass, num_indices: Uint32, num_instances: Uint32, first_index: Uint32, vertex_offset: Sint32, first_instance: Uint32) -> void #foreign sdl3;
SDL_DrawGPUPrimitives :: (render_pass: *SDL_GPURenderPass, num_vertices: Uint32, num_instances: Uint32, first_vertex: Uint32, first_instance: Uint32) -> void #foreign sdl3;
SDL_DrawGPUPrimitivesIndirect :: (render_pass: *SDL_GPURenderPass, buffer: *SDL_GPUBuffer, offset: Uint32, draw_count: Uint32) -> void #foreign sdl3;
SDL_DrawGPUIndexedPrimitivesIndirect :: (render_pass: *SDL_GPURenderPass, buffer: *SDL_GPUBuffer, offset: Uint32, draw_count: Uint32) -> void #foreign sdl3;
SDL_EndGPURenderPass :: (render_pass: *SDL_GPURenderPass) -> void #foreign sdl3;
SDL_BeginGPUComputePass :: (command_buffer: *SDL_GPUCommandBuffer, storage_texture_bindings: *SDL_GPUStorageTextureReadWriteBinding, num_storage_texture_bindings: Uint32, storage_buffer_bindings: *SDL_GPUStorageBufferReadWriteBinding, num_storage_buffer_bindings: Uint32) -> *SDL_GPUComputePass #foreign sdl3;
SDL_BindGPUComputePipeline :: (compute_pass: *SDL_GPUComputePass, compute_pipeline: *SDL_GPUComputePipeline) -> void #foreign sdl3;
SDL_BindGPUComputeSamplers :: (compute_pass: *SDL_GPUComputePass, first_slot: Uint32, texture_sampler_bindings: *SDL_GPUTextureSamplerBinding, num_bindings: Uint32) -> void #foreign sdl3;
SDL_BindGPUComputeStorageTextures :: (compute_pass: *SDL_GPUComputePass, first_slot: Uint32, storage_textures: **SDL_GPUTexture, num_bindings: Uint32) -> void #foreign sdl3;
SDL_BindGPUComputeStorageBuffers :: (compute_pass: *SDL_GPUComputePass, first_slot: Uint32, storage_buffers: **SDL_GPUBuffer, num_bindings: Uint32) -> void #foreign sdl3;
SDL_DispatchGPUCompute :: (compute_pass: *SDL_GPUComputePass, groupcount_x: Uint32, groupcount_y: Uint32, groupcount_z: Uint32) -> void #foreign sdl3;
SDL_DispatchGPUComputeIndirect :: (compute_pass: *SDL_GPUComputePass, buffer: *SDL_GPUBuffer, offset: Uint32) -> void #foreign sdl3;
SDL_EndGPUComputePass :: (compute_pass: *SDL_GPUComputePass) -> void #foreign sdl3;
SDL_MapGPUTransferBuffer :: (device: *SDL_GPUDevice, transfer_buffer: *SDL_GPUTransferBuffer, cycle: bool) -> *void #foreign sdl3;
SDL_UnmapGPUTransferBuffer :: (device: *SDL_GPUDevice, transfer_buffer: *SDL_GPUTransferBuffer) -> void #foreign sdl3;
SDL_BeginGPUCopyPass :: (command_buffer: *SDL_GPUCommandBuffer) -> *SDL_GPUCopyPass #foreign sdl3;
SDL_UploadToGPUTexture :: (copy_pass: *SDL_GPUCopyPass, source: *SDL_GPUTextureTransferInfo, destination: *SDL_GPUTextureRegion, cycle: bool) -> void #foreign sdl3;
SDL_UploadToGPUBuffer :: (copy_pass: *SDL_GPUCopyPass, source: *SDL_GPUTransferBufferLocation, destination: *SDL_GPUBufferRegion, cycle: bool) -> void #foreign sdl3;
SDL_CopyGPUTextureToTexture :: (copy_pass: *SDL_GPUCopyPass, source: *SDL_GPUTextureLocation, destination: *SDL_GPUTextureLocation, w: Uint32, h: Uint32, d: Uint32, cycle: bool) -> void #foreign sdl3;
SDL_CopyGPUBufferToBuffer :: (copy_pass: *SDL_GPUCopyPass, source: *SDL_GPUBufferLocation, destination: *SDL_GPUBufferLocation, size: Uint32, cycle: bool) -> void #foreign sdl3;
SDL_DownloadFromGPUTexture :: (copy_pass: *SDL_GPUCopyPass, source: *SDL_GPUTextureRegion, destination: *SDL_GPUTextureTransferInfo) -> void #foreign sdl3;
SDL_DownloadFromGPUBuffer :: (copy_pass: *SDL_GPUCopyPass, source: *SDL_GPUBufferRegion, destination: *SDL_GPUTransferBufferLocation) -> void #foreign sdl3;
SDL_EndGPUCopyPass :: (copy_pass: *SDL_GPUCopyPass) -> void #foreign sdl3;
SDL_GenerateMipmapsForGPUTexture :: (command_buffer: *SDL_GPUCommandBuffer, texture: *SDL_GPUTexture) -> void #foreign sdl3;
SDL_BlitGPUTexture :: (command_buffer: *SDL_GPUCommandBuffer, info: *SDL_GPUBlitInfo) -> void #foreign sdl3;
SDL_WindowSupportsGPUSwapchainComposition :: (device: *SDL_GPUDevice, window: *SDL_Window, swapchain_composition: SDL_GPUSwapchainComposition) -> bool #foreign sdl3;
SDL_WindowSupportsGPUPresentMode :: (device: *SDL_GPUDevice, window: *SDL_Window, present_mode: SDL_GPUPresentMode) -> bool #foreign sdl3;
SDL_ClaimWindowForGPUDevice :: (device: *SDL_GPUDevice, window: *SDL_Window) -> bool #foreign sdl3;
SDL_ReleaseWindowFromGPUDevice :: (device: *SDL_GPUDevice, window: *SDL_Window) -> void #foreign sdl3;
SDL_SetGPUSwapchainParameters :: (device: *SDL_GPUDevice, window: *SDL_Window, swapchain_composition: SDL_GPUSwapchainComposition, present_mode: SDL_GPUPresentMode) -> bool #foreign sdl3;
SDL_GetGPUSwapchainTextureFormat :: (device: *SDL_GPUDevice, window: *SDL_Window) -> SDL_GPUTextureFormat #foreign sdl3;
SDL_AcquireGPUSwapchainTexture :: (command_buffer: *SDL_GPUCommandBuffer, window: *SDL_Window, swapchain_texture: **SDL_GPUTexture, swapchain_texture_width: *Uint32, swapchain_texture_height: *Uint32) -> bool #foreign sdl3;
SDL_SubmitGPUCommandBuffer :: (command_buffer: *SDL_GPUCommandBuffer) -> bool #foreign sdl3;
SDL_SubmitGPUCommandBufferAndAcquireFence :: (command_buffer: *SDL_GPUCommandBuffer) -> *SDL_GPUFence #foreign sdl3;
SDL_CancelGPUCommandBuffer :: (command_buffer: *SDL_GPUCommandBuffer) -> bool #foreign sdl3;
SDL_WaitForGPUIdle :: (device: *SDL_GPUDevice) -> bool #foreign sdl3;
SDL_WaitForGPUFences :: (device: *SDL_GPUDevice, wait_all: bool, fences: **SDL_GPUFence, num_fences: Uint32) -> bool #foreign sdl3;
SDL_QueryGPUFence :: (device: *SDL_GPUDevice, fence: *SDL_GPUFence) -> bool #foreign sdl3;
SDL_ReleaseGPUFence :: (device: *SDL_GPUDevice, fence: *SDL_GPUFence) -> void #foreign sdl3;
SDL_GPUTextureFormatTexelBlockSize :: (format: SDL_GPUTextureFormat) -> Uint32 #foreign sdl3;
SDL_GPUTextureSupportsFormat :: (device: *SDL_GPUDevice, format: SDL_GPUTextureFormat, type: SDL_GPUTextureType, usage: SDL_GPUTextureUsageFlags) -> bool #foreign sdl3;
SDL_GPUTextureSupportsSampleCount :: (device: *SDL_GPUDevice, format: SDL_GPUTextureFormat, sample_count: SDL_GPUSampleCount) -> bool #foreign sdl3;
SDL_CalculateGPUTextureFormatSize :: (format: SDL_GPUTextureFormat, width: Uint32, height: Uint32, depth_or_layer_count: Uint32) -> Uint32 #foreign sdl3;
SDL_hid_device :: struct {}
SDL_hid_bus_type :: enum s32 {
    UNKNOWN   :: 0;
    USB       :: 1;
    BLUETOOTH :: 2;
    I2C       :: 3;
    SPI       :: 4;

    SDL_HID_API_BUS_UNKNOWN   :: UNKNOWN;
    SDL_HID_API_BUS_USB       :: USB;
    SDL_HID_API_BUS_BLUETOOTH :: BLUETOOTH;
    SDL_HID_API_BUS_I2C       :: I2C;
    SDL_HID_API_BUS_SPI       :: SPI;
}
SDL_hid_device_info :: struct {
    path:                *u8;
    vendor_id:           u16;
    product_id:          u16;
    serial_number:       *u16;
    release_number:      u16;
    manufacturer_string: *u16;
    product_string:      *u16;
    usage_page:          u16;
    usage:               u16;
    interface_number:    s32;
    interface_class:     s32;
    interface_subclass:  s32;
    interface_protocol:  s32;
    bus_type:            SDL_hid_bus_type;
    next:                *SDL_hid_device_info;
}
SDL_hid_init :: () -> s32 #foreign sdl3;
SDL_hid_exit :: () -> s32 #foreign sdl3;
SDL_hid_device_change_count :: () -> Uint32 #foreign sdl3;
SDL_hid_enumerate :: (vendor_id: u16, product_id: u16) -> *SDL_hid_device_info #foreign sdl3;
SDL_hid_free_enumeration :: (devs: *SDL_hid_device_info) -> void #foreign sdl3;
SDL_hid_open :: (vendor_id: u16, product_id: u16, serial_number: *u16) -> *SDL_hid_device #foreign sdl3;
SDL_hid_open_path :: (path: *u8) -> *SDL_hid_device #foreign sdl3;
SDL_hid_write :: (dev: *SDL_hid_device, data: *u8, length: u64) -> s32 #foreign sdl3;
SDL_hid_read_timeout :: (dev: *SDL_hid_device, data: *u8, length: u64, milliseconds: s32) -> s32 #foreign sdl3;
SDL_hid_read :: (dev: *SDL_hid_device, data: *u8, length: u64) -> s32 #foreign sdl3;
SDL_hid_set_nonblocking :: (dev: *SDL_hid_device, nonblock: s32) -> s32 #foreign sdl3;
SDL_hid_send_feature_report :: (dev: *SDL_hid_device, data: *u8, length: u64) -> s32 #foreign sdl3;
SDL_hid_get_feature_report :: (dev: *SDL_hid_device, data: *u8, length: u64) -> s32 #foreign sdl3;
SDL_hid_get_input_report :: (dev: *SDL_hid_device, data: *u8, length: u64) -> s32 #foreign sdl3;
SDL_hid_close :: (dev: *SDL_hid_device) -> s32 #foreign sdl3;
SDL_hid_get_manufacturer_string :: (dev: *SDL_hid_device, _string: *u16, maxlen: u64) -> s32 #foreign sdl3;
SDL_hid_get_product_string :: (dev: *SDL_hid_device, _string: *u16, maxlen: u64) -> s32 #foreign sdl3;
SDL_hid_get_serial_number_string :: (dev: *SDL_hid_device, _string: *u16, maxlen: u64) -> s32 #foreign sdl3;
SDL_hid_get_indexed_string :: (dev: *SDL_hid_device, string_index: s32, _string: *u16, maxlen: u64) -> s32 #foreign sdl3;
SDL_hid_get_device_info :: (dev: *SDL_hid_device) -> *SDL_hid_device_info #foreign sdl3;
SDL_hid_get_report_descriptor :: (dev: *SDL_hid_device, buf: *u8, buf_size: u64) -> s32 #foreign sdl3;
SDL_hid_ble_scan :: (active: bool) -> void #foreign sdl3;
SDL_InitFlags :: Uint32;
SDL_AppResult :: enum s32 {
    CONTINUE :: 0;
    SUCCESS  :: 1;
    FAILURE  :: 2;

    SDL_APP_CONTINUE :: CONTINUE;
    SDL_APP_SUCCESS  :: SUCCESS;
    SDL_APP_FAILURE  :: FAILURE;
}
SDL_AppInit_func :: #type (appstate: **void, argc: s32, argv: **u8) -> SDL_AppResult #c_call;
SDL_AppIterate_func :: #type (appstate: *void) -> SDL_AppResult #c_call;
SDL_AppEvent_func :: #type (appstate: *void, event: *SDL_Event) -> SDL_AppResult #c_call;
SDL_AppQuit_func :: #type (appstate: *void, result: SDL_AppResult) -> void #c_call;
SDL_Init :: (flags: SDL_InitFlags) -> bool #foreign sdl3;
SDL_InitSubSystem :: (flags: SDL_InitFlags) -> bool #foreign sdl3;
SDL_QuitSubSystem :: (flags: SDL_InitFlags) -> void #foreign sdl3;
SDL_WasInit :: (flags: SDL_InitFlags) -> SDL_InitFlags #foreign sdl3;
SDL_Quit :: () -> void #foreign sdl3;
SDL_SetAppMetadata :: (appname: *u8, appversion: *u8, appidentifier: *u8) -> bool #foreign sdl3;
SDL_SetAppMetadataProperty :: (name: *u8, value: *u8) -> bool #foreign sdl3;
SDL_GetAppMetadataProperty :: (name: *u8) -> *u8 #foreign sdl3;
SDL_SharedObject :: struct {}
SDL_LoadObject :: (sofile: *u8) -> *SDL_SharedObject #foreign sdl3;
SDL_LoadFunction :: (handle: *SDL_SharedObject, name: *u8) -> SDL_FunctionPointer #foreign sdl3;
SDL_UnloadObject :: (handle: *SDL_SharedObject) -> void #foreign sdl3;
SDL_Locale :: struct {
    language: *u8;
    country:  *u8;
}
SDL_GetPreferredLocales :: (count: *s32) -> **SDL_Locale #foreign sdl3;
SDL_LogCategory :: enum s32 {
    APPLICATION :: 0;
    ERROR       :: 1;
    ASSERT      :: 2;
    SYSTEM      :: 3;
    AUDIO       :: 4;
    VIDEO       :: 5;
    RENDER      :: 6;
    INPUT       :: 7;
    TEST        :: 8;
    GPU         :: 9;
    RESERVED2   :: 10;
    RESERVED3   :: 11;
    RESERVED4   :: 12;
    RESERVED5   :: 13;
    RESERVED6   :: 14;
    RESERVED7   :: 15;
    RESERVED8   :: 16;
    RESERVED9   :: 17;
    RESERVED10  :: 18;
    CUSTOM      :: 19;

    SDL_LOG_CATEGORY_APPLICATION :: APPLICATION;
    SDL_LOG_CATEGORY_ERROR       :: ERROR;
    SDL_LOG_CATEGORY_ASSERT      :: ASSERT;
    SDL_LOG_CATEGORY_SYSTEM      :: SYSTEM;
    SDL_LOG_CATEGORY_AUDIO       :: AUDIO;
    SDL_LOG_CATEGORY_VIDEO       :: VIDEO;
    SDL_LOG_CATEGORY_RENDER      :: RENDER;
    SDL_LOG_CATEGORY_INPUT       :: INPUT;
    SDL_LOG_CATEGORY_TEST        :: TEST;
    SDL_LOG_CATEGORY_GPU         :: GPU;
    SDL_LOG_CATEGORY_RESERVED2   :: RESERVED2;
    SDL_LOG_CATEGORY_RESERVED3   :: RESERVED3;
    SDL_LOG_CATEGORY_RESERVED4   :: RESERVED4;
    SDL_LOG_CATEGORY_RESERVED5   :: RESERVED5;
    SDL_LOG_CATEGORY_RESERVED6   :: RESERVED6;
    SDL_LOG_CATEGORY_RESERVED7   :: RESERVED7;
    SDL_LOG_CATEGORY_RESERVED8   :: RESERVED8;
    SDL_LOG_CATEGORY_RESERVED9   :: RESERVED9;
    SDL_LOG_CATEGORY_RESERVED10  :: RESERVED10;
    SDL_LOG_CATEGORY_CUSTOM      :: CUSTOM;
}
SDL_LogPriority :: enum s32 {
    INVALID  :: 0;
    TRACE    :: 1;
    VERBOSE  :: 2;
    DEBUG    :: 3;
    INFO     :: 4;
    WARN     :: 5;
    ERROR    :: 6;
    CRITICAL :: 7;
    COUNT    :: 8;

    SDL_LOG_PRIORITY_INVALID  :: INVALID;
    SDL_LOG_PRIORITY_TRACE    :: TRACE;
    SDL_LOG_PRIORITY_VERBOSE  :: VERBOSE;
    SDL_LOG_PRIORITY_DEBUG    :: DEBUG;
    SDL_LOG_PRIORITY_INFO     :: INFO;
    SDL_LOG_PRIORITY_WARN     :: WARN;
    SDL_LOG_PRIORITY_ERROR    :: ERROR;
    SDL_LOG_PRIORITY_CRITICAL :: CRITICAL;
    SDL_LOG_PRIORITY_COUNT    :: COUNT;
}
SDL_SetLogPriorities :: (priority: SDL_LogPriority) -> void #foreign sdl3;
SDL_SetLogPriority :: (category: s32, priority: SDL_LogPriority) -> void #foreign sdl3;
SDL_GetLogPriority :: (category: s32) -> SDL_LogPriority #foreign sdl3;
SDL_ResetLogPriorities :: () -> void #foreign sdl3;
SDL_SetLogPriorityPrefix :: (priority: SDL_LogPriority, prefix: *u8) -> bool #foreign sdl3;
SDL_Log_CFormat :: (fmt: *u8, __args: ..Any) -> void #foreign sdl3 "SDL_Log";
SDL_Log :: (fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    SDL_Log_CFormat("%s", formatted_text.data);
} @PrintLike
SDL_LogTrace_CFormat :: (category: s32, fmt: *u8, __args: ..Any) -> void #foreign sdl3 "SDL_LogTrace";
SDL_LogTrace :: (category: s32, fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    SDL_LogTrace_CFormat(category, "%s", formatted_text.data);
} @PrintLike
SDL_LogVerbose_CFormat :: (category: s32, fmt: *u8, __args: ..Any) -> void #foreign sdl3 "SDL_LogVerbose";
SDL_LogVerbose :: (category: s32, fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    SDL_LogVerbose_CFormat(category, "%s", formatted_text.data);
} @PrintLike
SDL_LogDebug_CFormat :: (category: s32, fmt: *u8, __args: ..Any) -> void #foreign sdl3 "SDL_LogDebug";
SDL_LogDebug :: (category: s32, fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    SDL_LogDebug_CFormat(category, "%s", formatted_text.data);
} @PrintLike
SDL_LogInfo_CFormat :: (category: s32, fmt: *u8, __args: ..Any) -> void #foreign sdl3 "SDL_LogInfo";
SDL_LogInfo :: (category: s32, fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    SDL_LogInfo_CFormat(category, "%s", formatted_text.data);
} @PrintLike
SDL_LogWarn_CFormat :: (category: s32, fmt: *u8, __args: ..Any) -> void #foreign sdl3 "SDL_LogWarn";
SDL_LogWarn :: (category: s32, fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    SDL_LogWarn_CFormat(category, "%s", formatted_text.data);
} @PrintLike
SDL_LogError_CFormat :: (category: s32, fmt: *u8, __args: ..Any) -> void #foreign sdl3 "SDL_LogError";
SDL_LogError :: (category: s32, fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    SDL_LogError_CFormat(category, "%s", formatted_text.data);
} @PrintLike
SDL_LogCritical_CFormat :: (category: s32, fmt: *u8, __args: ..Any) -> void #foreign sdl3 "SDL_LogCritical";
SDL_LogCritical :: (category: s32, fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    SDL_LogCritical_CFormat(category, "%s", formatted_text.data);
} @PrintLike
SDL_LogMessage_CFormat :: (category: s32, priority: SDL_LogPriority, fmt: *u8, __args: ..Any) -> void #foreign sdl3 "SDL_LogMessage";
SDL_LogMessage :: (category: s32, priority: SDL_LogPriority, fmt: string, __args: ..Any) {
    push_allocator(temp);
    formatted_text_builder: String_Builder;
    print_to_builder(*formatted_text_builder, fmt, ..__args);
    append(*formatted_text_builder, "\0");
    formatted_text := builder_to_string(*formatted_text_builder);
    SDL_LogMessage_CFormat(category, priority, "%s", formatted_text.data);
} @PrintLike
SDL_LogOutputFunction :: #type (userdata: *void, category: s32, priority: SDL_LogPriority, message: *u8) -> void #c_call;
SDL_GetDefaultLogOutputFunction :: () -> SDL_LogOutputFunction #foreign sdl3;
SDL_GetLogOutputFunction :: (callback: *SDL_LogOutputFunction, userdata: **void) -> void #foreign sdl3;
SDL_SetLogOutputFunction :: (callback: SDL_LogOutputFunction, userdata: *void) -> void #foreign sdl3;
SDL_main_func :: #type (argc: s32, argv: **u8) -> s32 #c_call;
SDL_SetMainReady :: () -> void #foreign sdl3;
SDL_RunApp :: (argc: s32, argv: **u8, mainFunction: SDL_main_func, reserved: *void) -> s32 #foreign sdl3;
SDL_EnterAppMainCallbacks :: (argc: s32, argv: **u8, appinit: SDL_AppInit_func, appiter: SDL_AppIterate_func, appevent: SDL_AppEvent_func, appquit: SDL_AppQuit_func) -> s32 #foreign sdl3;
SDL_RegisterApp :: (name: *u8, style: Uint32, hInst: *void) -> bool #foreign sdl3;
SDL_UnregisterApp :: () -> void #foreign sdl3;
SDL_MessageBoxFlags :: Uint32;
SDL_MessageBoxButtonFlags :: Uint32;
SDL_MessageBoxButtonData :: struct {
    flags:    SDL_MessageBoxButtonFlags;
    buttonID: s32;
    text:     *u8;
}
SDL_MessageBoxColor :: struct {
    r: Uint8;
    g: Uint8;
    b: Uint8;
}
SDL_MessageBoxColorType :: enum s32 {
    BACKGROUND        :: 0;
    TEXT              :: 1;
    BUTTON_BORDER     :: 2;
    BUTTON_BACKGROUND :: 3;
    BUTTON_SELECTED   :: 4;
    COUNT             :: 5;

    SDL_MESSAGEBOX_COLOR_BACKGROUND        :: BACKGROUND;
    SDL_MESSAGEBOX_COLOR_TEXT              :: TEXT;
    SDL_MESSAGEBOX_COLOR_BUTTON_BORDER     :: BUTTON_BORDER;
    SDL_MESSAGEBOX_COLOR_BUTTON_BACKGROUND :: BUTTON_BACKGROUND;
    SDL_MESSAGEBOX_COLOR_BUTTON_SELECTED   :: BUTTON_SELECTED;
    SDL_MESSAGEBOX_COLOR_COUNT             :: COUNT;
}
SDL_MessageBoxColorScheme :: struct {
    colors: [5] SDL_MessageBoxColor;
}
SDL_MessageBoxData :: struct {
    flags:       SDL_MessageBoxFlags;
    window:      *SDL_Window;
    title:       *u8;
    message:     *u8;
    numbuttons:  s32;
    buttons:     *SDL_MessageBoxButtonData;
    colorScheme: *SDL_MessageBoxColorScheme;
}
SDL_ShowMessageBox :: (messageboxdata: *SDL_MessageBoxData, buttonid: *s32) -> bool #foreign sdl3;
SDL_ShowSimpleMessageBox :: (flags: SDL_MessageBoxFlags, title: *u8, message: *u8, window: *SDL_Window) -> bool #foreign sdl3;
SDL_MetalView :: *void;
SDL_Metal_CreateView :: (window: *SDL_Window) -> SDL_MetalView #foreign sdl3;
SDL_Metal_DestroyView :: (view: SDL_MetalView) -> void #foreign sdl3;
SDL_Metal_GetLayer :: (view: SDL_MetalView) -> *void #foreign sdl3;
SDL_OpenURL :: (url: *u8) -> bool #foreign sdl3;
SDL_GetPlatform :: () -> *u8 #foreign sdl3;
SDL_Process :: struct {}
SDL_CreateProcess :: (args: **u8, pipe_stdio: bool) -> *SDL_Process #foreign sdl3;
SDL_ProcessIO :: enum s32 {
    INHERITED :: 0;
    NULL      :: 1;
    APP       :: 2;
    REDIRECT  :: 3;

    SDL_PROCESS_STDIO_INHERITED :: INHERITED;
    SDL_PROCESS_STDIO_NULL      :: NULL;
    SDL_PROCESS_STDIO_APP       :: APP;
    SDL_PROCESS_STDIO_REDIRECT  :: REDIRECT;
}
SDL_CreateProcessWithProperties :: (props: SDL_PropertiesID) -> *SDL_Process #foreign sdl3;
SDL_GetProcessProperties :: (process: *SDL_Process) -> SDL_PropertiesID #foreign sdl3;
SDL_ReadProcess :: (process: *SDL_Process, datasize: *u64, exitcode: *s32) -> *void #foreign sdl3;
SDL_GetProcessInput :: (process: *SDL_Process) -> *SDL_IOStream #foreign sdl3;
SDL_GetProcessOutput :: (process: *SDL_Process) -> *SDL_IOStream #foreign sdl3;
SDL_KillProcess :: (process: *SDL_Process, force: bool) -> bool #foreign sdl3;
SDL_WaitProcess :: (process: *SDL_Process, block: bool, exitcode: *s32) -> bool #foreign sdl3;
SDL_DestroyProcess :: (process: *SDL_Process) -> void #foreign sdl3;
SDL_Vertex :: struct {
    position:  SDL_FPoint;
    color:     SDL_FColor;
    tex_coord: SDL_FPoint;
}
SDL_TextureAccess :: enum s32 {
    STATIC    :: 0;
    STREAMING :: 1;
    TARGET    :: 2;

    SDL_TEXTUREACCESS_STATIC    :: STATIC;
    SDL_TEXTUREACCESS_STREAMING :: STREAMING;
    SDL_TEXTUREACCESS_TARGET    :: TARGET;
}
SDL_RendererLogicalPresentation :: enum s32 {
    DISABLED      :: 0;
    STRETCH       :: 1;
    LETTERBOX     :: 2;
    OVERSCAN      :: 3;
    INTEGER_SCALE :: 4;

    SDL_LOGICAL_PRESENTATION_DISABLED      :: DISABLED;
    SDL_LOGICAL_PRESENTATION_STRETCH       :: STRETCH;
    SDL_LOGICAL_PRESENTATION_LETTERBOX     :: LETTERBOX;
    SDL_LOGICAL_PRESENTATION_OVERSCAN      :: OVERSCAN;
    SDL_LOGICAL_PRESENTATION_INTEGER_SCALE :: INTEGER_SCALE;
}
SDL_Renderer :: struct {}
SDL_Texture :: struct {
    format:   SDL_PixelFormat;
    w:        s32;
    h:        s32;
    refcount: s32;
}
SDL_GetNumRenderDrivers :: () -> s32 #foreign sdl3;
SDL_GetRenderDriver :: (index: s32) -> *u8 #foreign sdl3;
SDL_CreateWindowAndRenderer :: (title: *u8, width: s32, height: s32, window_flags: SDL_WindowFlags, window: **SDL_Window, renderer: **SDL_Renderer) -> bool #foreign sdl3;
SDL_CreateRenderer :: (window: *SDL_Window, name: *u8) -> *SDL_Renderer #foreign sdl3;
SDL_CreateRendererWithProperties :: (props: SDL_PropertiesID) -> *SDL_Renderer #foreign sdl3;
SDL_CreateSoftwareRenderer :: (surface: *SDL_Surface) -> *SDL_Renderer #foreign sdl3;
SDL_GetRenderer :: (window: *SDL_Window) -> *SDL_Renderer #foreign sdl3;
SDL_GetRenderWindow :: (renderer: *SDL_Renderer) -> *SDL_Window #foreign sdl3;
SDL_GetRendererName :: (renderer: *SDL_Renderer) -> *u8 #foreign sdl3;
SDL_GetRendererProperties :: (renderer: *SDL_Renderer) -> SDL_PropertiesID #foreign sdl3;
SDL_GetRenderOutputSize :: (renderer: *SDL_Renderer, w: *s32, h: *s32) -> bool #foreign sdl3;
SDL_GetCurrentRenderOutputSize :: (renderer: *SDL_Renderer, w: *s32, h: *s32) -> bool #foreign sdl3;
SDL_CreateTexture :: (renderer: *SDL_Renderer, format: SDL_PixelFormat, access: SDL_TextureAccess, w: s32, h: s32) -> *SDL_Texture #foreign sdl3;
SDL_CreateTextureFromSurface :: (renderer: *SDL_Renderer, surface: *SDL_Surface) -> *SDL_Texture #foreign sdl3;
SDL_CreateTextureWithProperties :: (renderer: *SDL_Renderer, props: SDL_PropertiesID) -> *SDL_Texture #foreign sdl3;
SDL_GetTextureProperties :: (texture: *SDL_Texture) -> SDL_PropertiesID #foreign sdl3;
SDL_GetRendererFromTexture :: (texture: *SDL_Texture) -> *SDL_Renderer #foreign sdl3;
SDL_GetTextureSize :: (texture: *SDL_Texture, w: *float, h: *float) -> bool #foreign sdl3;
SDL_SetTextureColorMod :: (texture: *SDL_Texture, r: Uint8, g: Uint8, b: Uint8) -> bool #foreign sdl3;
SDL_SetTextureColorModFloat :: (texture: *SDL_Texture, r: float, g: float, b: float) -> bool #foreign sdl3;
SDL_GetTextureColorMod :: (texture: *SDL_Texture, r: *Uint8, g: *Uint8, b: *Uint8) -> bool #foreign sdl3;
SDL_GetTextureColorModFloat :: (texture: *SDL_Texture, r: *float, g: *float, b: *float) -> bool #foreign sdl3;
SDL_SetTextureAlphaMod :: (texture: *SDL_Texture, alpha: Uint8) -> bool #foreign sdl3;
SDL_SetTextureAlphaModFloat :: (texture: *SDL_Texture, alpha: float) -> bool #foreign sdl3;
SDL_GetTextureAlphaMod :: (texture: *SDL_Texture, alpha: *Uint8) -> bool #foreign sdl3;
SDL_GetTextureAlphaModFloat :: (texture: *SDL_Texture, alpha: *float) -> bool #foreign sdl3;
SDL_SetTextureBlendMode :: (texture: *SDL_Texture, blendMode: SDL_BlendMode) -> bool #foreign sdl3;
SDL_GetTextureBlendMode :: (texture: *SDL_Texture, blendMode: *SDL_BlendMode) -> bool #foreign sdl3;
SDL_SetTextureScaleMode :: (texture: *SDL_Texture, scaleMode: SDL_ScaleMode) -> bool #foreign sdl3;
SDL_GetTextureScaleMode :: (texture: *SDL_Texture, scaleMode: *SDL_ScaleMode) -> bool #foreign sdl3;
SDL_UpdateTexture :: (texture: *SDL_Texture, rect: *SDL_Rect, pixels: *void, pitch: s32) -> bool #foreign sdl3;
SDL_UpdateYUVTexture :: (texture: *SDL_Texture, rect: *SDL_Rect, Yplane: *Uint8, Ypitch: s32, Uplane: *Uint8, Upitch: s32, Vplane: *Uint8, Vpitch: s32) -> bool #foreign sdl3;
SDL_UpdateNVTexture :: (texture: *SDL_Texture, rect: *SDL_Rect, Yplane: *Uint8, Ypitch: s32, UVplane: *Uint8, UVpitch: s32) -> bool #foreign sdl3;
SDL_LockTexture :: (texture: *SDL_Texture, rect: *SDL_Rect, pixels: **void, pitch: *s32) -> bool #foreign sdl3;
SDL_LockTextureToSurface :: (texture: *SDL_Texture, rect: *SDL_Rect, surface: **SDL_Surface) -> bool #foreign sdl3;
SDL_UnlockTexture :: (texture: *SDL_Texture) -> void #foreign sdl3;
SDL_SetRenderTarget :: (renderer: *SDL_Renderer, texture: *SDL_Texture) -> bool #foreign sdl3;
SDL_GetRenderTarget :: (renderer: *SDL_Renderer) -> *SDL_Texture #foreign sdl3;
SDL_SetRenderLogicalPresentation :: (renderer: *SDL_Renderer, w: s32, h: s32, mode: SDL_RendererLogicalPresentation) -> bool #foreign sdl3;
SDL_GetRenderLogicalPresentation :: (renderer: *SDL_Renderer, w: *s32, h: *s32, mode: *SDL_RendererLogicalPresentation) -> bool #foreign sdl3;
SDL_GetRenderLogicalPresentationRect :: (renderer: *SDL_Renderer, rect: *SDL_FRect) -> bool #foreign sdl3;
SDL_RenderCoordinatesFromWindow :: (renderer: *SDL_Renderer, window_x: float, window_y: float, x: *float, y: *float) -> bool #foreign sdl3;
SDL_RenderCoordinatesToWindow :: (renderer: *SDL_Renderer, x: float, y: float, window_x: *float, window_y: *float) -> bool #foreign sdl3;
SDL_ConvertEventToRenderCoordinates :: (renderer: *SDL_Renderer, event: *SDL_Event) -> bool #foreign sdl3;
SDL_SetRenderViewport :: (renderer: *SDL_Renderer, rect: *SDL_Rect) -> bool #foreign sdl3;
SDL_GetRenderViewport :: (renderer: *SDL_Renderer, rect: *SDL_Rect) -> bool #foreign sdl3;
SDL_RenderViewportSet :: (renderer: *SDL_Renderer) -> bool #foreign sdl3;
SDL_GetRenderSafeArea :: (renderer: *SDL_Renderer, rect: *SDL_Rect) -> bool #foreign sdl3;
SDL_SetRenderClipRect :: (renderer: *SDL_Renderer, rect: *SDL_Rect) -> bool #foreign sdl3;
SDL_GetRenderClipRect :: (renderer: *SDL_Renderer, rect: *SDL_Rect) -> bool #foreign sdl3;
SDL_RenderClipEnabled :: (renderer: *SDL_Renderer) -> bool #foreign sdl3;
SDL_SetRenderScale :: (renderer: *SDL_Renderer, scaleX: float, scaleY: float) -> bool #foreign sdl3;
SDL_GetRenderScale :: (renderer: *SDL_Renderer, scaleX: *float, scaleY: *float) -> bool #foreign sdl3;
SDL_SetRenderDrawColor :: (renderer: *SDL_Renderer, r: Uint8, g: Uint8, b: Uint8, a: Uint8) -> bool #foreign sdl3;
SDL_SetRenderDrawColorFloat :: (renderer: *SDL_Renderer, r: float, g: float, b: float, a: float) -> bool #foreign sdl3;
SDL_GetRenderDrawColor :: (renderer: *SDL_Renderer, r: *Uint8, g: *Uint8, b: *Uint8, a: *Uint8) -> bool #foreign sdl3;
SDL_GetRenderDrawColorFloat :: (renderer: *SDL_Renderer, r: *float, g: *float, b: *float, a: *float) -> bool #foreign sdl3;
SDL_SetRenderColorScale :: (renderer: *SDL_Renderer, scale: float) -> bool #foreign sdl3;
SDL_GetRenderColorScale :: (renderer: *SDL_Renderer, scale: *float) -> bool #foreign sdl3;
SDL_SetRenderDrawBlendMode :: (renderer: *SDL_Renderer, blendMode: SDL_BlendMode) -> bool #foreign sdl3;
SDL_GetRenderDrawBlendMode :: (renderer: *SDL_Renderer, blendMode: *SDL_BlendMode) -> bool #foreign sdl3;
SDL_RenderClear :: (renderer: *SDL_Renderer) -> bool #foreign sdl3;
SDL_RenderPoint :: (renderer: *SDL_Renderer, x: float, y: float) -> bool #foreign sdl3;
SDL_RenderPoints :: (renderer: *SDL_Renderer, points: *SDL_FPoint, count: s32) -> bool #foreign sdl3;
SDL_RenderLine :: (renderer: *SDL_Renderer, x1: float, y1: float, x2: float, y2: float) -> bool #foreign sdl3;
SDL_RenderLines :: (renderer: *SDL_Renderer, points: *SDL_FPoint, count: s32) -> bool #foreign sdl3;
SDL_RenderRect :: (renderer: *SDL_Renderer, rect: *SDL_FRect) -> bool #foreign sdl3;
SDL_RenderRects :: (renderer: *SDL_Renderer, rects: *SDL_FRect, count: s32) -> bool #foreign sdl3;
SDL_RenderFillRect :: (renderer: *SDL_Renderer, rect: *SDL_FRect) -> bool #foreign sdl3;
SDL_RenderFillRects :: (renderer: *SDL_Renderer, rects: *SDL_FRect, count: s32) -> bool #foreign sdl3;
SDL_RenderTexture :: (renderer: *SDL_Renderer, texture: *SDL_Texture, srcrect: *SDL_FRect, dstrect: *SDL_FRect) -> bool #foreign sdl3;
SDL_RenderTextureRotated :: (renderer: *SDL_Renderer, texture: *SDL_Texture, srcrect: *SDL_FRect, dstrect: *SDL_FRect, angle: float64, center: *SDL_FPoint, flip: SDL_FlipMode) -> bool #foreign sdl3;
SDL_RenderTextureTiled :: (renderer: *SDL_Renderer, texture: *SDL_Texture, srcrect: *SDL_FRect, scale: float, dstrect: *SDL_FRect) -> bool #foreign sdl3;
SDL_RenderTexture9Grid :: (renderer: *SDL_Renderer, texture: *SDL_Texture, srcrect: *SDL_FRect, left_width: float, right_width: float, top_height: float, bottom_height: float, scale: float, dstrect: *SDL_FRect) -> bool #foreign sdl3;
SDL_RenderGeometry :: (renderer: *SDL_Renderer, texture: *SDL_Texture, vertices: *SDL_Vertex, num_vertices: s32, indices: *s32, num_indices: s32) -> bool #foreign sdl3;
SDL_RenderGeometryRaw :: (renderer: *SDL_Renderer, texture: *SDL_Texture, xy: *float, xy_stride: s32, color: *SDL_FColor, color_stride: s32, uv: *float, uv_stride: s32, num_vertices: s32, indices: *void, num_indices: s32, size_indices: s32) -> bool #foreign sdl3;
SDL_RenderReadPixels :: (renderer: *SDL_Renderer, rect: *SDL_Rect) -> *SDL_Surface #foreign sdl3;
SDL_RenderPresent :: (renderer: *SDL_Renderer) -> bool #foreign sdl3;
SDL_DestroyTexture :: (texture: *SDL_Texture) -> void #foreign sdl3;
SDL_DestroyRenderer :: (renderer: *SDL_Renderer) -> void #foreign sdl3;
SDL_FlushRenderer :: (renderer: *SDL_Renderer) -> bool #foreign sdl3;
SDL_GetRenderMetalLayer :: (renderer: *SDL_Renderer) -> *void #foreign sdl3;
SDL_GetRenderMetalCommandEncoder :: (renderer: *SDL_Renderer) -> *void #foreign sdl3;
SDL_AddVulkanRenderSemaphores :: (renderer: *SDL_Renderer, wait_stage_mask: Uint32, wait_semaphore: Sint64, signal_semaphore: Sint64) -> bool #foreign sdl3;
SDL_SetRenderVSync :: (renderer: *SDL_Renderer, vsync: s32) -> bool #foreign sdl3;
SDL_GetRenderVSync :: (renderer: *SDL_Renderer, vsync: *s32) -> bool #foreign sdl3;
SDL_RenderDebugText :: (renderer: *SDL_Renderer, x: float, y: float, str: *u8) -> bool #foreign sdl3;
SDL_StorageInterface :: struct {
    version:         Uint32;
    close:           #type (userdata: *void) -> bool #c_call;
    ready:           #type (userdata: *void) -> bool #c_call;
    enumerate:       #type (userdata: *void, path: *u8, callback: SDL_EnumerateDirectoryCallback, callback_userdata: *void) -> bool #c_call;
    info:            #type (userdata: *void, path: *u8, info: *SDL_PathInfo) -> bool #c_call;
    read_file:       #type (userdata: *void, path: *u8, destination: *void, length: Uint64) -> bool #c_call;
    write_file:      #type (userdata: *void, path: *u8, source: *void, length: Uint64) -> bool #c_call;
    mkdir:           #type (userdata: *void, path: *u8) -> bool #c_call;
    _remove:         #type (userdata: *void, path: *u8) -> bool #c_call;
    rename:          #type (userdata: *void, oldpath: *u8, newpath: *u8) -> bool #c_call;
    copy:            #type (userdata: *void, oldpath: *u8, newpath: *u8) -> bool #c_call;
    space_remaining: #type (userdata: *void) -> Uint64 #c_call;
}
SDL_Storage :: struct {}
SDL_OpenTitleStorage :: (override: *u8, props: SDL_PropertiesID) -> *SDL_Storage #foreign sdl3;
SDL_OpenUserStorage :: (org: *u8, app: *u8, props: SDL_PropertiesID) -> *SDL_Storage #foreign sdl3;
SDL_OpenFileStorage :: (path: *u8) -> *SDL_Storage #foreign sdl3;
SDL_OpenStorage :: (iface: *SDL_StorageInterface, userdata: *void) -> *SDL_Storage #foreign sdl3;
SDL_CloseStorage :: (storage: *SDL_Storage) -> bool #foreign sdl3;
SDL_StorageReady :: (storage: *SDL_Storage) -> bool #foreign sdl3;
SDL_GetStorageFileSize :: (storage: *SDL_Storage, path: *u8, length: *Uint64) -> bool #foreign sdl3;
SDL_ReadStorageFile :: (storage: *SDL_Storage, path: *u8, destination: *void, length: Uint64) -> bool #foreign sdl3;
SDL_WriteStorageFile :: (storage: *SDL_Storage, path: *u8, source: *void, length: Uint64) -> bool #foreign sdl3;
SDL_CreateStorageDirectory :: (storage: *SDL_Storage, path: *u8) -> bool #foreign sdl3;
SDL_EnumerateStorageDirectory :: (storage: *SDL_Storage, path: *u8, callback: SDL_EnumerateDirectoryCallback, userdata: *void) -> bool #foreign sdl3;
SDL_RemoveStoragePath :: (storage: *SDL_Storage, path: *u8) -> bool #foreign sdl3;
SDL_RenameStoragePath :: (storage: *SDL_Storage, oldpath: *u8, newpath: *u8) -> bool #foreign sdl3;
SDL_CopyStorageFile :: (storage: *SDL_Storage, oldpath: *u8, newpath: *u8) -> bool #foreign sdl3;
SDL_GetStoragePathInfo :: (storage: *SDL_Storage, path: *u8, info: *SDL_PathInfo) -> bool #foreign sdl3;
SDL_GetStorageSpaceRemaining :: (storage: *SDL_Storage) -> Uint64 #foreign sdl3;
SDL_GlobStorageDirectory :: (storage: *SDL_Storage, path: *u8, pattern: *u8, flags: SDL_GlobFlags, count: *s32) -> **u8 #foreign sdl3;
tagMSG :: struct {}
MSG :: tagMSG;
SDL_WindowsMessageHook :: #type (userdata: *void, msg: *MSG) -> bool #c_call;
SDL_SetWindowsMessageHook :: (callback: SDL_WindowsMessageHook, userdata: *void) -> void #foreign sdl3;
SDL_GetDirect3D9AdapterIndex :: (displayID: SDL_DisplayID) -> s32 #foreign sdl3;
SDL_GetDXGIOutputInfo :: (displayID: SDL_DisplayID, adapterIndex: *s32, outputIndex: *s32) -> bool #foreign sdl3;
_XEvent :: union {}
XEvent :: _XEvent;
SDL_X11EventHook :: #type (userdata: *void, xevent: *XEvent) -> bool #c_call;
SDL_SetX11EventHook :: (callback: SDL_X11EventHook, userdata: *void) -> void #foreign sdl3;
SDL_IsTablet :: () -> bool #foreign sdl3;
SDL_IsTV :: () -> bool #foreign sdl3;
SDL_Sandbox :: enum s32 {
    NONE              :: 0;
    UNKNOWN_CONTAINER :: 1;
    FLATPAK           :: 2;
    SNAP              :: 3;
    MACOS             :: 4;

    SDL_SANDBOX_NONE              :: NONE;
    SDL_SANDBOX_UNKNOWN_CONTAINER :: UNKNOWN_CONTAINER;
    SDL_SANDBOX_FLATPAK           :: FLATPAK;
    SDL_SANDBOX_SNAP              :: SNAP;
    SDL_SANDBOX_MACOS             :: MACOS;
}
SDL_GetSandbox :: () -> SDL_Sandbox #foreign sdl3;
SDL_OnApplicationWillTerminate :: () -> void #foreign sdl3;
SDL_OnApplicationDidReceiveMemoryWarning :: () -> void #foreign sdl3;
SDL_OnApplicationWillEnterBackground :: () -> void #foreign sdl3;
SDL_OnApplicationDidEnterBackground :: () -> void #foreign sdl3;
SDL_OnApplicationWillEnterForeground :: () -> void #foreign sdl3;
SDL_OnApplicationDidEnterForeground :: () -> void #foreign sdl3;
SDL_DateTime :: struct {
    year:        s32;
    month:       s32;
    day:         s32;
    hour:        s32;
    minute:      s32;
    second:      s32;
    nanosecond:  s32;
    day_of_week: s32;
    utc_offset:  s32;
}
SDL_DateFormat :: enum s32 {
    YYYYMMDD :: 0;
    DDMMYYYY :: 1;
    MMDDYYYY :: 2;

    SDL_DATE_FORMAT_YYYYMMDD :: YYYYMMDD;
    SDL_DATE_FORMAT_DDMMYYYY :: DDMMYYYY;
    SDL_DATE_FORMAT_MMDDYYYY :: MMDDYYYY;
}
SDL_TimeFormat :: enum s32 {
    _24HR :: 0;
    _12HR :: 1;

    SDL_TIME_FORMAT_24HR :: _24HR;
    SDL_TIME_FORMAT_12HR :: _12HR;
}
SDL_GetDateTimeLocalePreferences :: (dateFormat: *SDL_DateFormat, timeFormat: *SDL_TimeFormat) -> bool #foreign sdl3;
SDL_GetCurrentTime :: (ticks: *SDL_Time) -> bool #foreign sdl3;
SDL_TimeToDateTime :: (ticks: SDL_Time, dt: *SDL_DateTime, localTime: bool) -> bool #foreign sdl3;
SDL_DateTimeToTime :: (dt: *SDL_DateTime, ticks: *SDL_Time) -> bool #foreign sdl3;
SDL_TimeToWindows :: (ticks: SDL_Time, dwLowDateTime: *Uint32, dwHighDateTime: *Uint32) -> void #foreign sdl3;
SDL_TimeFromWindows :: (dwLowDateTime: Uint32, dwHighDateTime: Uint32) -> SDL_Time #foreign sdl3;
SDL_GetDaysInMonth :: (year: s32, month: s32) -> s32 #foreign sdl3;
SDL_GetDayOfYear :: (year: s32, month: s32, day: s32) -> s32 #foreign sdl3;
SDL_GetDayOfWeek :: (year: s32, month: s32, day: s32) -> s32 #foreign sdl3;
SDL_GetTicks :: () -> Uint64 #foreign sdl3;
SDL_GetTicksNS :: () -> Uint64 #foreign sdl3;
SDL_GetPerformanceCounter :: () -> Uint64 #foreign sdl3;
SDL_GetPerformanceFrequency :: () -> Uint64 #foreign sdl3;
SDL_Delay :: (ms: Uint32) -> void #foreign sdl3;
SDL_DelayNS :: (ns: Uint64) -> void #foreign sdl3;
SDL_DelayPrecise :: (ns: Uint64) -> void #foreign sdl3;
SDL_TimerID :: Uint32;
SDL_TimerCallback :: #type (userdata: *void, timerID: SDL_TimerID, interval: Uint32) -> Uint32 #c_call;
SDL_AddTimer :: (interval: Uint32, callback: SDL_TimerCallback, userdata: *void) -> SDL_TimerID #foreign sdl3;
SDL_NSTimerCallback :: #type (userdata: *void, timerID: SDL_TimerID, interval: Uint64) -> Uint64 #c_call;
SDL_AddTimerNS :: (interval: Uint64, callback: SDL_NSTimerCallback, userdata: *void) -> SDL_TimerID #foreign sdl3;
SDL_RemoveTimer :: (id: SDL_TimerID) -> bool #foreign sdl3;
SDL_GetVersion :: () -> s32 #foreign sdl3;
SDL_GetRevision :: () -> *u8 #foreign sdl3;
VkInstance_T :: struct {}
VkInstance :: *VkInstance_T;
VkPhysicalDevice_T :: struct {}
VkPhysicalDevice :: *VkPhysicalDevice_T;
VkSurfaceKHR_T :: struct {}
VkSurfaceKHR :: *VkSurfaceKHR_T;
VkAllocationCallbacks :: struct {}
SDL_Vulkan_LoadLibrary :: (path: *u8) -> bool #foreign sdl3;
SDL_Vulkan_GetVkGetInstanceProcAddr :: () -> SDL_FunctionPointer #foreign sdl3;
SDL_Vulkan_UnloadLibrary :: () -> void #foreign sdl3;
SDL_Vulkan_GetInstanceExtensions :: (count: *Uint32) -> **u8 #foreign sdl3;
SDL_Vulkan_CreateSurface :: (window: *SDL_Window, instance: VkInstance, allocator: *VkAllocationCallbacks, surface: *VkSurfaceKHR) -> bool #foreign sdl3;
SDL_Vulkan_DestroySurface :: (instance: VkInstance, surface: VkSurfaceKHR, allocator: *VkAllocationCallbacks) -> void #foreign sdl3;
SDL_Vulkan_GetPresentationSupport :: (instance: VkInstance, physicalDevice: VkPhysicalDevice, queueFamilyIndex: Uint32) -> bool #foreign sdl3;

#scope_file

#import "Basic"; // For push_context

#scope_file

#if OS == .WINDOWS {
    sdl3 :: #library "lib/x64/sdl3";
} else #if OS == .LINUX {
    sdl3 :: #library "sdl3";
} else {
    #assert(false);
}
