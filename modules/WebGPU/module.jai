//
// This file was auto-generated using the following command:
//
// jai generate.jai
//



WGPU_ARRAY_LAYER_COUNT_UNDEFINED :: 0xffffffff;
WGPU_COPY_STRIDE_UNDEFINED :: 0xffffffff;
WGPU_LIMIT_U32_UNDEFINED :: 0xffffffff;
WGPU_LIMIT_U64_UNDEFINED :: 0xffffffffffffffff;
WGPU_MIP_LEVEL_COUNT_UNDEFINED :: 0xffffffff;

WGPU_WHOLE_SIZE :: 0xffffffffffffffff;

Flags :: u32;

AdapterImpl :: struct {}
Adapter :: *AdapterImpl;
BindGroupImpl :: struct {}
BindGroup :: *BindGroupImpl;
BindGroupLayoutImpl :: struct {}
BindGroupLayout :: *BindGroupLayoutImpl;
BufferImpl :: struct {}
Buffer :: *BufferImpl;
CommandBufferImpl :: struct {}
CommandBuffer :: *CommandBufferImpl;
CommandEncoderImpl :: struct {}
CommandEncoder :: *CommandEncoderImpl;
ComputePassEncoderImpl :: struct {}
ComputePassEncoder :: *ComputePassEncoderImpl;
ComputePipelineImpl :: struct {}
ComputePipeline :: *ComputePipelineImpl;
DeviceImpl :: struct {}
Device :: *DeviceImpl;
InstanceImpl :: struct {}
Instance :: *InstanceImpl;
PipelineLayoutImpl :: struct {}
PipelineLayout :: *PipelineLayoutImpl;
QuerySetImpl :: struct {}
QuerySet :: *QuerySetImpl;
QueueImpl :: struct {}
Queue :: *QueueImpl;
RenderBundleImpl :: struct {}
RenderBundle :: *RenderBundleImpl;
RenderBundleEncoderImpl :: struct {}
RenderBundleEncoder :: *RenderBundleEncoderImpl;
RenderPassEncoderImpl :: struct {}
RenderPassEncoder :: *RenderPassEncoderImpl;
RenderPipelineImpl :: struct {}
RenderPipeline :: *RenderPipelineImpl;
SamplerImpl :: struct {}
Sampler :: *SamplerImpl;
ShaderModuleImpl :: struct {}
ShaderModule :: *ShaderModuleImpl;
SurfaceImpl :: struct {}
Surface :: *SurfaceImpl;
SwapChainImpl :: struct {}
SwapChain :: *SwapChainImpl;
TextureImpl :: struct {}
Texture :: *TextureImpl;
TextureViewImpl :: struct {}
TextureView :: *TextureViewImpl;

AdapterType :: enum u32 {
    DiscreteGPU   :: 0;
    IntegratedGPU :: 1;
    CPU           :: 2;
    Unknown       :: 3;
    Force32       :: 2147483647;

    WGPUAdapterType_DiscreteGPU   :: DiscreteGPU;
    WGPUAdapterType_IntegratedGPU :: IntegratedGPU;
    WGPUAdapterType_CPU           :: CPU;
    WGPUAdapterType_Unknown       :: Unknown;
    WGPUAdapterType_Force32       :: Force32;
}

AddressMode :: enum u32 {
    Repeat       :: 0;
    MirrorRepeat :: 1;
    ClampToEdge  :: 2;
    Force32      :: 2147483647;

    WGPUAddressMode_Repeat       :: Repeat;
    WGPUAddressMode_MirrorRepeat :: MirrorRepeat;
    WGPUAddressMode_ClampToEdge  :: ClampToEdge;
    WGPUAddressMode_Force32      :: Force32;
}

BackendType :: enum u32 {
    Undefined :: 0;
    Null      :: 1;
    WebGPU    :: 2;
    D3D11     :: 3;
    D3D12     :: 4;
    Metal     :: 5;
    Vulkan    :: 6;
    OpenGL    :: 7;
    OpenGLES  :: 8;
    Force32   :: 2147483647;

    WGPUBackendType_Undefined :: Undefined;
    WGPUBackendType_Null      :: Null;
    WGPUBackendType_WebGPU    :: WebGPU;
    WGPUBackendType_D3D11     :: D3D11;
    WGPUBackendType_D3D12     :: D3D12;
    WGPUBackendType_Metal     :: Metal;
    WGPUBackendType_Vulkan    :: Vulkan;
    WGPUBackendType_OpenGL    :: OpenGL;
    WGPUBackendType_OpenGLES  :: OpenGLES;
    WGPUBackendType_Force32   :: Force32;
}

BlendFactor :: enum u32 {
    Zero              :: 0;
    One               :: 1;
    Src               :: 2;
    OneMinusSrc       :: 3;
    SrcAlpha          :: 4;
    OneMinusSrcAlpha  :: 5;
    Dst               :: 6;
    OneMinusDst       :: 7;
    DstAlpha          :: 8;
    OneMinusDstAlpha  :: 9;
    SrcAlphaSaturated :: 10;
    Constant          :: 11;
    OneMinusConstant  :: 12;
    Force32           :: 2147483647;

    WGPUBlendFactor_Zero              :: Zero;
    WGPUBlendFactor_One               :: One;
    WGPUBlendFactor_Src               :: Src;
    WGPUBlendFactor_OneMinusSrc       :: OneMinusSrc;
    WGPUBlendFactor_SrcAlpha          :: SrcAlpha;
    WGPUBlendFactor_OneMinusSrcAlpha  :: OneMinusSrcAlpha;
    WGPUBlendFactor_Dst               :: Dst;
    WGPUBlendFactor_OneMinusDst       :: OneMinusDst;
    WGPUBlendFactor_DstAlpha          :: DstAlpha;
    WGPUBlendFactor_OneMinusDstAlpha  :: OneMinusDstAlpha;
    WGPUBlendFactor_SrcAlphaSaturated :: SrcAlphaSaturated;
    WGPUBlendFactor_Constant          :: Constant;
    WGPUBlendFactor_OneMinusConstant  :: OneMinusConstant;
    WGPUBlendFactor_Force32           :: Force32;
}

BlendOperation :: enum u32 {
    Add             :: 0;
    Subtract        :: 1;
    ReverseSubtract :: 2;
    Min             :: 3;
    Max             :: 4;
    Force32         :: 2147483647;

    WGPUBlendOperation_Add             :: Add;
    WGPUBlendOperation_Subtract        :: Subtract;
    WGPUBlendOperation_ReverseSubtract :: ReverseSubtract;
    WGPUBlendOperation_Min             :: Min;
    WGPUBlendOperation_Max             :: Max;
    WGPUBlendOperation_Force32         :: Force32;
}

BufferBindingType :: enum u32 {
    Undefined       :: 0;
    Uniform         :: 1;
    Storage         :: 2;
    ReadOnlyStorage :: 3;
    Force32         :: 2147483647;

    WGPUBufferBindingType_Undefined       :: Undefined;
    WGPUBufferBindingType_Uniform         :: Uniform;
    WGPUBufferBindingType_Storage         :: Storage;
    WGPUBufferBindingType_ReadOnlyStorage :: ReadOnlyStorage;
    WGPUBufferBindingType_Force32         :: Force32;
}

BufferMapAsyncStatus :: enum u32 {
    Success                 :: 0;
    ValidationError         :: 1;
    Unknown                 :: 2;
    DeviceLost              :: 3;
    DestroyedBeforeCallback :: 4;
    UnmappedBeforeCallback  :: 5;
    MappingAlreadyPending   :: 6;
    OffsetOutOfRange        :: 7;
    SizeOutOfRange          :: 8;
    Force32                 :: 2147483647;

    WGPUBufferMapAsyncStatus_Success                 :: Success;
    WGPUBufferMapAsyncStatus_ValidationError         :: ValidationError;
    WGPUBufferMapAsyncStatus_Unknown                 :: Unknown;
    WGPUBufferMapAsyncStatus_DeviceLost              :: DeviceLost;
    WGPUBufferMapAsyncStatus_DestroyedBeforeCallback :: DestroyedBeforeCallback;
    WGPUBufferMapAsyncStatus_UnmappedBeforeCallback  :: UnmappedBeforeCallback;
    WGPUBufferMapAsyncStatus_MappingAlreadyPending   :: MappingAlreadyPending;
    WGPUBufferMapAsyncStatus_OffsetOutOfRange        :: OffsetOutOfRange;
    WGPUBufferMapAsyncStatus_SizeOutOfRange          :: SizeOutOfRange;
    WGPUBufferMapAsyncStatus_Force32                 :: Force32;
}

BufferMapState :: enum u32 {
    Unmapped :: 0;
    Pending  :: 1;
    Mapped   :: 2;
    Force32  :: 2147483647;

    WGPUBufferMapState_Unmapped :: Unmapped;
    WGPUBufferMapState_Pending  :: Pending;
    WGPUBufferMapState_Mapped   :: Mapped;
    WGPUBufferMapState_Force32  :: Force32;
}

CompareFunction :: enum u32 {
    Undefined    :: 0;
    Never        :: 1;
    Less         :: 2;
    LessEqual    :: 3;
    Greater      :: 4;
    GreaterEqual :: 5;
    Equal        :: 6;
    NotEqual     :: 7;
    Always       :: 8;
    Force32      :: 2147483647;

    WGPUCompareFunction_Undefined    :: Undefined;
    WGPUCompareFunction_Never        :: Never;
    WGPUCompareFunction_Less         :: Less;
    WGPUCompareFunction_LessEqual    :: LessEqual;
    WGPUCompareFunction_Greater      :: Greater;
    WGPUCompareFunction_GreaterEqual :: GreaterEqual;
    WGPUCompareFunction_Equal        :: Equal;
    WGPUCompareFunction_NotEqual     :: NotEqual;
    WGPUCompareFunction_Always       :: Always;
    WGPUCompareFunction_Force32      :: Force32;
}

CompilationInfoRequestStatus :: enum u32 {
    Success    :: 0;
    Error      :: 1;
    DeviceLost :: 2;
    Unknown    :: 3;
    Force32    :: 2147483647;

    WGPUCompilationInfoRequestStatus_Success    :: Success;
    WGPUCompilationInfoRequestStatus_Error      :: Error;
    WGPUCompilationInfoRequestStatus_DeviceLost :: DeviceLost;
    WGPUCompilationInfoRequestStatus_Unknown    :: Unknown;
    WGPUCompilationInfoRequestStatus_Force32    :: Force32;
}

CompilationMessageType :: enum u32 {
    Error   :: 0;
    Warning :: 1;
    Info    :: 2;
    Force32 :: 2147483647;

    WGPUCompilationMessageType_Error   :: Error;
    WGPUCompilationMessageType_Warning :: Warning;
    WGPUCompilationMessageType_Info    :: Info;
    WGPUCompilationMessageType_Force32 :: Force32;
}

ComputePassTimestampLocation :: enum u32 {
    Beginning :: 0;
    End       :: 1;
    Force32   :: 2147483647;

    WGPUComputePassTimestampLocation_Beginning :: Beginning;
    WGPUComputePassTimestampLocation_End       :: End;
    WGPUComputePassTimestampLocation_Force32   :: Force32;
}

CreatePipelineAsyncStatus :: enum u32 {
    Success         :: 0;
    ValidationError :: 1;
    InternalError   :: 2;
    DeviceLost      :: 3;
    DeviceDestroyed :: 4;
    Unknown         :: 5;
    Force32         :: 2147483647;

    WGPUCreatePipelineAsyncStatus_Success         :: Success;
    WGPUCreatePipelineAsyncStatus_ValidationError :: ValidationError;
    WGPUCreatePipelineAsyncStatus_InternalError   :: InternalError;
    WGPUCreatePipelineAsyncStatus_DeviceLost      :: DeviceLost;
    WGPUCreatePipelineAsyncStatus_DeviceDestroyed :: DeviceDestroyed;
    WGPUCreatePipelineAsyncStatus_Unknown         :: Unknown;
    WGPUCreatePipelineAsyncStatus_Force32         :: Force32;
}

CullMode :: enum u32 {
    None    :: 0;
    Front   :: 1;
    Back    :: 2;
    Force32 :: 2147483647;

    WGPUCullMode_None    :: None;
    WGPUCullMode_Front   :: Front;
    WGPUCullMode_Back    :: Back;
    WGPUCullMode_Force32 :: Force32;
}

DeviceLostReason :: enum u32 {
    Undefined :: 0;
    Destroyed :: 1;
    Force32   :: 2147483647;

    WGPUDeviceLostReason_Undefined :: Undefined;
    WGPUDeviceLostReason_Destroyed :: Destroyed;
    WGPUDeviceLostReason_Force32   :: Force32;
}

ErrorFilter :: enum u32 {
    Validation  :: 0;
    OutOfMemory :: 1;
    Internal    :: 2;
    Force32     :: 2147483647;

    WGPUErrorFilter_Validation  :: Validation;
    WGPUErrorFilter_OutOfMemory :: OutOfMemory;
    WGPUErrorFilter_Internal    :: Internal;
    WGPUErrorFilter_Force32     :: Force32;
}

ErrorType :: enum u32 {
    NoError     :: 0;
    Validation  :: 1;
    OutOfMemory :: 2;
    Internal    :: 3;
    Unknown     :: 4;
    DeviceLost  :: 5;
    Force32     :: 2147483647;

    WGPUErrorType_NoError     :: NoError;
    WGPUErrorType_Validation  :: Validation;
    WGPUErrorType_OutOfMemory :: OutOfMemory;
    WGPUErrorType_Internal    :: Internal;
    WGPUErrorType_Unknown     :: Unknown;
    WGPUErrorType_DeviceLost  :: DeviceLost;
    WGPUErrorType_Force32     :: Force32;
}

FeatureName :: enum u32 {
    Undefined               :: 0;
    DepthClipControl        :: 1;
    Depth32FloatStencil8    :: 2;
    TimestampQuery          :: 3;
    PipelineStatisticsQuery :: 4;
    TextureCompressionBC    :: 5;
    TextureCompressionETC2  :: 6;
    TextureCompressionASTC  :: 7;
    IndirectFirstInstance   :: 8;
    ShaderF16               :: 9;
    RG11B10UfloatRenderable :: 10;
    BGRA8UnormStorage       :: 11;
    Float32Filterable       :: 12;

    // Native Features
    PushConstants                        :: 1610612737;
    TextureAdapterSpecificFormatFeatures :: 1610612738;
    MultiDrawIndirect                    :: 1610612739;
    MultiDrawIndirectCount               :: 1610612740;
    VertexWritableStorage                :: 1610612741;
    Force32                              :: 2147483647;

    WGPUFeatureName_Undefined               :: Undefined;
    WGPUFeatureName_DepthClipControl        :: DepthClipControl;
    WGPUFeatureName_Depth32FloatStencil8    :: Depth32FloatStencil8;
    WGPUFeatureName_TimestampQuery          :: TimestampQuery;
    WGPUFeatureName_PipelineStatisticsQuery :: PipelineStatisticsQuery;
    WGPUFeatureName_TextureCompressionBC    :: TextureCompressionBC;
    WGPUFeatureName_TextureCompressionETC2  :: TextureCompressionETC2;
    WGPUFeatureName_TextureCompressionASTC  :: TextureCompressionASTC;
    WGPUFeatureName_IndirectFirstInstance   :: IndirectFirstInstance;
    WGPUFeatureName_ShaderF16               :: ShaderF16;
    WGPUFeatureName_RG11B10UfloatRenderable :: RG11B10UfloatRenderable;
    WGPUFeatureName_BGRA8UnormStorage       :: BGRA8UnormStorage;
    WGPUFeatureName_Float32Filterable       :: Float32Filterable;
    WGPUFeatureName_Force32                 :: Force32;

    WGPUNativeFeature_PushConstants                        :: PushConstants;
    WGPUNativeFeature_TextureAdapterSpecificFormatFeatures :: TextureAdapterSpecificFormatFeatures;
    WGPUNativeFeature_MultiDrawIndirect                    :: MultiDrawIndirect;
    WGPUNativeFeature_MultiDrawIndirectCount               :: MultiDrawIndirectCount;
    WGPUNativeFeature_VertexWritableStorage                :: VertexWritableStorage;
    WGPUNativeFeature_Force32                              :: Force32;
}

FilterMode :: enum u32 {
    Nearest :: 0;
    Linear  :: 1;
    Force32 :: 2147483647;

    WGPUFilterMode_Nearest :: Nearest;
    WGPUFilterMode_Linear  :: Linear;
    WGPUFilterMode_Force32 :: Force32;
}

FrontFace :: enum u32 {
    CCW     :: 0;
    CW      :: 1;
    Force32 :: 2147483647;

    WGPUFrontFace_CCW     :: CCW;
    WGPUFrontFace_CW      :: CW;
    WGPUFrontFace_Force32 :: Force32;
}

IndexFormat :: enum u32 {
    Undefined :: 0;
    Uint16    :: 1;
    Uint32    :: 2;
    Force32   :: 2147483647;

    WGPUIndexFormat_Undefined :: Undefined;
    WGPUIndexFormat_Uint16    :: Uint16;
    WGPUIndexFormat_Uint32    :: Uint32;
    WGPUIndexFormat_Force32   :: Force32;
}

LoadOp :: enum u32 {
    Undefined :: 0;
    Clear     :: 1;
    Load      :: 2;
    Force32   :: 2147483647;

    WGPULoadOp_Undefined :: Undefined;
    WGPULoadOp_Clear     :: Clear;
    WGPULoadOp_Load      :: Load;
    WGPULoadOp_Force32   :: Force32;
}

MipmapFilterMode :: enum u32 {
    Nearest :: 0;
    Linear  :: 1;
    Force32 :: 2147483647;

    WGPUMipmapFilterMode_Nearest :: Nearest;
    WGPUMipmapFilterMode_Linear  :: Linear;
    WGPUMipmapFilterMode_Force32 :: Force32;
}

PipelineStatisticName :: enum u32 {
    VertexShaderInvocations   :: 0;
    ClipperInvocations        :: 1;
    ClipperPrimitivesOut      :: 2;
    FragmentShaderInvocations :: 3;
    ComputeShaderInvocations  :: 4;
    Force32                   :: 2147483647;

    WGPUPipelineStatisticName_VertexShaderInvocations   :: VertexShaderInvocations;
    WGPUPipelineStatisticName_ClipperInvocations        :: ClipperInvocations;
    WGPUPipelineStatisticName_ClipperPrimitivesOut      :: ClipperPrimitivesOut;
    WGPUPipelineStatisticName_FragmentShaderInvocations :: FragmentShaderInvocations;
    WGPUPipelineStatisticName_ComputeShaderInvocations  :: ComputeShaderInvocations;
    WGPUPipelineStatisticName_Force32                   :: Force32;
}

PowerPreference :: enum u32 {
    Undefined       :: 0;
    LowPower        :: 1;
    HighPerformance :: 2;
    Force32         :: 2147483647;

    WGPUPowerPreference_Undefined       :: Undefined;
    WGPUPowerPreference_LowPower        :: LowPower;
    WGPUPowerPreference_HighPerformance :: HighPerformance;
    WGPUPowerPreference_Force32         :: Force32;
}

PresentMode :: enum u32 {
    Immediate :: 0;
    Mailbox   :: 1;
    Fifo      :: 2;
    Force32   :: 2147483647;

    WGPUPresentMode_Immediate :: Immediate;
    WGPUPresentMode_Mailbox   :: Mailbox;
    WGPUPresentMode_Fifo      :: Fifo;
    WGPUPresentMode_Force32   :: Force32;
}

PrimitiveTopology :: enum u32 {
    PointList     :: 0;
    LineList      :: 1;
    LineStrip     :: 2;
    TriangleList  :: 3;
    TriangleStrip :: 4;
    Force32       :: 2147483647;

    WGPUPrimitiveTopology_PointList     :: PointList;
    WGPUPrimitiveTopology_LineList      :: LineList;
    WGPUPrimitiveTopology_LineStrip     :: LineStrip;
    WGPUPrimitiveTopology_TriangleList  :: TriangleList;
    WGPUPrimitiveTopology_TriangleStrip :: TriangleStrip;
    WGPUPrimitiveTopology_Force32       :: Force32;
}

QueryType :: enum u32 {
    Occlusion          :: 0;
    PipelineStatistics :: 1;
    Timestamp          :: 2;
    Force32            :: 2147483647;

    WGPUQueryType_Occlusion          :: Occlusion;
    WGPUQueryType_PipelineStatistics :: PipelineStatistics;
    WGPUQueryType_Timestamp          :: Timestamp;
    WGPUQueryType_Force32            :: Force32;
}

QueueWorkDoneStatus :: enum u32 {
    Success    :: 0;
    Error      :: 1;
    Unknown    :: 2;
    DeviceLost :: 3;
    Force32    :: 2147483647;

    WGPUQueueWorkDoneStatus_Success    :: Success;
    WGPUQueueWorkDoneStatus_Error      :: Error;
    WGPUQueueWorkDoneStatus_Unknown    :: Unknown;
    WGPUQueueWorkDoneStatus_DeviceLost :: DeviceLost;
    WGPUQueueWorkDoneStatus_Force32    :: Force32;
}

RenderPassTimestampLocation :: enum u32 {
    Beginning :: 0;
    End       :: 1;
    Force32   :: 2147483647;

    WGPURenderPassTimestampLocation_Beginning :: Beginning;
    WGPURenderPassTimestampLocation_End       :: End;
    WGPURenderPassTimestampLocation_Force32   :: Force32;
}

RequestAdapterStatus :: enum u32 {
    Success     :: 0;
    Unavailable :: 1;
    Error       :: 2;
    Unknown     :: 3;
    Force32     :: 2147483647;

    WGPURequestAdapterStatus_Success     :: Success;
    WGPURequestAdapterStatus_Unavailable :: Unavailable;
    WGPURequestAdapterStatus_Error       :: Error;
    WGPURequestAdapterStatus_Unknown     :: Unknown;
    WGPURequestAdapterStatus_Force32     :: Force32;
}

RequestDeviceStatus :: enum u32 {
    Success :: 0;
    Error   :: 1;
    Unknown :: 2;
    Force32 :: 2147483647;

    WGPURequestDeviceStatus_Success :: Success;
    WGPURequestDeviceStatus_Error   :: Error;
    WGPURequestDeviceStatus_Unknown :: Unknown;
    WGPURequestDeviceStatus_Force32 :: Force32;
}

SType :: enum u32 {
    Invalid                                  :: 0;
    SurfaceDescriptorFromMetalLayer          :: 1;
    SurfaceDescriptorFromWindowsHWND         :: 2;
    SurfaceDescriptorFromXlibWindow          :: 3;
    SurfaceDescriptorFromCanvasHTMLSelector  :: 4;
    ShaderModuleSPIRVDescriptor              :: 5;
    ShaderModuleWGSLDescriptor               :: 6;
    PrimitiveDepthClipControl                :: 7;
    SurfaceDescriptorFromWaylandSurface      :: 8;
    SurfaceDescriptorFromAndroidNativeWindow :: 9;
    SurfaceDescriptorFromXcbWindow           :: 10;
    RenderPassDescriptorMaxDrawCount         :: 15;

    DeviceExtras               :: 1610612737;
    AdapterExtras              :: 1610612738;
    RequiredLimitsExtras       :: 1610612739;
    PipelineLayoutExtras       :: 1610612740;
    ShaderModuleGLSLDescriptor :: 1610612741;
    SupportedLimitsExtras      :: 1610612739;
    InstanceExtras             :: 1610612742;
    SwapChainDescriptorExtras  :: 1610612743;
    Force32                          :: 2147483647;

    WGPUSType_Invalid                                  :: Invalid;
    WGPUSType_SurfaceDescriptorFromMetalLayer          :: SurfaceDescriptorFromMetalLayer;
    WGPUSType_SurfaceDescriptorFromWindowsHWND         :: SurfaceDescriptorFromWindowsHWND;
    WGPUSType_SurfaceDescriptorFromXlibWindow          :: SurfaceDescriptorFromXlibWindow;
    WGPUSType_SurfaceDescriptorFromCanvasHTMLSelector  :: SurfaceDescriptorFromCanvasHTMLSelector;
    WGPUSType_ShaderModuleSPIRVDescriptor              :: ShaderModuleSPIRVDescriptor;
    WGPUSType_ShaderModuleWGSLDescriptor               :: ShaderModuleWGSLDescriptor;
    WGPUSType_PrimitiveDepthClipControl                :: PrimitiveDepthClipControl;
    WGPUSType_SurfaceDescriptorFromWaylandSurface      :: SurfaceDescriptorFromWaylandSurface;
    WGPUSType_SurfaceDescriptorFromAndroidNativeWindow :: SurfaceDescriptorFromAndroidNativeWindow;
    WGPUSType_SurfaceDescriptorFromXcbWindow           :: SurfaceDescriptorFromXcbWindow;
    WGPUSType_RenderPassDescriptorMaxDrawCount         :: RenderPassDescriptorMaxDrawCount;
    WGPUSType_Force32                                  :: Force32;

    WGPUSType_DeviceExtras               :: DeviceExtras;
    WGPUSType_AdapterExtras              :: AdapterExtras;
    WGPUSType_RequiredLimitsExtras       :: RequiredLimitsExtras;
    WGPUSType_PipelineLayoutExtras       :: PipelineLayoutExtras;
    WGPUSType_ShaderModuleGLSLDescriptor :: ShaderModuleGLSLDescriptor;
    WGPUSType_SupportedLimitsExtras      :: SupportedLimitsExtras;
    WGPUSType_InstanceExtras             :: InstanceExtras;
    WGPUSType_SwapChainDescriptorExtras  :: SwapChainDescriptorExtras;
    WGPUNativeSType_Force32              :: Force32;
}

SamplerBindingType :: enum u32 {
    Undefined    :: 0;
    Filtering    :: 1;
    NonFiltering :: 2;
    Comparison   :: 3;
    Force32      :: 2147483647;

    WGPUSamplerBindingType_Undefined    :: Undefined;
    WGPUSamplerBindingType_Filtering    :: Filtering;
    WGPUSamplerBindingType_NonFiltering :: NonFiltering;
    WGPUSamplerBindingType_Comparison   :: Comparison;
    WGPUSamplerBindingType_Force32      :: Force32;
}

StencilOperation :: enum u32 {
    Keep           :: 0;
    Zero           :: 1;
    Replace        :: 2;
    Invert         :: 3;
    IncrementClamp :: 4;
    DecrementClamp :: 5;
    IncrementWrap  :: 6;
    DecrementWrap  :: 7;
    Force32        :: 2147483647;

    WGPUStencilOperation_Keep           :: Keep;
    WGPUStencilOperation_Zero           :: Zero;
    WGPUStencilOperation_Replace        :: Replace;
    WGPUStencilOperation_Invert         :: Invert;
    WGPUStencilOperation_IncrementClamp :: IncrementClamp;
    WGPUStencilOperation_DecrementClamp :: DecrementClamp;
    WGPUStencilOperation_IncrementWrap  :: IncrementWrap;
    WGPUStencilOperation_DecrementWrap  :: DecrementWrap;
    WGPUStencilOperation_Force32        :: Force32;
}

StorageTextureAccess :: enum u32 {
    Undefined :: 0;
    WriteOnly :: 1;
    Force32   :: 2147483647;

    WGPUStorageTextureAccess_Undefined :: Undefined;
    WGPUStorageTextureAccess_WriteOnly :: WriteOnly;
    WGPUStorageTextureAccess_Force32   :: Force32;
}

StoreOp :: enum u32 {
    Undefined :: 0;
    Store     :: 1;
    Discard   :: 2;
    Force32   :: 2147483647;

    WGPUStoreOp_Undefined :: Undefined;
    WGPUStoreOp_Store     :: Store;
    WGPUStoreOp_Discard   :: Discard;
    WGPUStoreOp_Force32   :: Force32;
}

TextureAspect :: enum u32 {
    All         :: 0;
    StencilOnly :: 1;
    DepthOnly   :: 2;
    Force32     :: 2147483647;

    WGPUTextureAspect_All         :: All;
    WGPUTextureAspect_StencilOnly :: StencilOnly;
    WGPUTextureAspect_DepthOnly   :: DepthOnly;
    WGPUTextureAspect_Force32     :: Force32;
}

TextureDimension :: enum u32 {
    _1D     :: 0;
    _2D     :: 1;
    _3D     :: 2;
    Force32 :: 2147483647;

    WGPUTextureDimension_1D      :: _1D;
    WGPUTextureDimension_2D      :: _2D;
    WGPUTextureDimension_3D      :: _3D;
    WGPUTextureDimension_Force32 :: Force32;
}

TextureFormat :: enum u32 {
    Undefined            :: 0;
    R8Unorm              :: 1;
    R8Snorm              :: 2;
    R8Uint               :: 3;
    R8Sint               :: 4;
    R16Uint              :: 5;
    R16Sint              :: 6;
    R16Float             :: 7;
    RG8Unorm             :: 8;
    RG8Snorm             :: 9;
    RG8Uint              :: 10;
    RG8Sint              :: 11;
    R32Float             :: 12;
    R32Uint              :: 13;
    R32Sint              :: 14;
    RG16Uint             :: 15;
    RG16Sint             :: 16;
    RG16Float            :: 17;
    RGBA8Unorm           :: 18;
    RGBA8UnormSrgb       :: 19;
    RGBA8Snorm           :: 20;
    RGBA8Uint            :: 21;
    RGBA8Sint            :: 22;
    BGRA8Unorm           :: 23;
    BGRA8UnormSrgb       :: 24;
    RGB10A2Unorm         :: 25;
    RG11B10Ufloat        :: 26;
    RGB9E5Ufloat         :: 27;
    RG32Float            :: 28;
    RG32Uint             :: 29;
    RG32Sint             :: 30;
    RGBA16Uint           :: 31;
    RGBA16Sint           :: 32;
    RGBA16Float          :: 33;
    RGBA32Float          :: 34;
    RGBA32Uint           :: 35;
    RGBA32Sint           :: 36;
    Stencil8             :: 37;
    Depth16Unorm         :: 38;
    Depth24Plus          :: 39;
    Depth24PlusStencil8  :: 40;
    Depth32Float         :: 41;
    Depth32FloatStencil8 :: 42;
    BC1RGBAUnorm         :: 43;
    BC1RGBAUnormSrgb     :: 44;
    BC2RGBAUnorm         :: 45;
    BC2RGBAUnormSrgb     :: 46;
    BC3RGBAUnorm         :: 47;
    BC3RGBAUnormSrgb     :: 48;
    BC4RUnorm            :: 49;
    BC4RSnorm            :: 50;
    BC5RGUnorm           :: 51;
    BC5RGSnorm           :: 52;
    BC6HRGBUfloat        :: 53;
    BC6HRGBFloat         :: 54;
    BC7RGBAUnorm         :: 55;
    BC7RGBAUnormSrgb     :: 56;
    ETC2RGB8Unorm        :: 57;
    ETC2RGB8UnormSrgb    :: 58;
    ETC2RGB8A1Unorm      :: 59;
    ETC2RGB8A1UnormSrgb  :: 60;
    ETC2RGBA8Unorm       :: 61;
    ETC2RGBA8UnormSrgb   :: 62;
    EACR11Unorm          :: 63;
    EACR11Snorm          :: 64;
    EACRG11Unorm         :: 65;
    EACRG11Snorm         :: 66;
    ASTC4x4Unorm         :: 67;
    ASTC4x4UnormSrgb     :: 68;
    ASTC5x4Unorm         :: 69;
    ASTC5x4UnormSrgb     :: 70;
    ASTC5x5Unorm         :: 71;
    ASTC5x5UnormSrgb     :: 72;
    ASTC6x5Unorm         :: 73;
    ASTC6x5UnormSrgb     :: 74;
    ASTC6x6Unorm         :: 75;
    ASTC6x6UnormSrgb     :: 76;
    ASTC8x5Unorm         :: 77;
    ASTC8x5UnormSrgb     :: 78;
    ASTC8x6Unorm         :: 79;
    ASTC8x6UnormSrgb     :: 80;
    ASTC8x8Unorm         :: 81;
    ASTC8x8UnormSrgb     :: 82;
    ASTC10x5Unorm        :: 83;
    ASTC10x5UnormSrgb    :: 84;
    ASTC10x6Unorm        :: 85;
    ASTC10x6UnormSrgb    :: 86;
    ASTC10x8Unorm        :: 87;
    ASTC10x8UnormSrgb    :: 88;
    ASTC10x10Unorm       :: 89;
    ASTC10x10UnormSrgb   :: 90;
    ASTC12x10Unorm       :: 91;
    ASTC12x10UnormSrgb   :: 92;
    ASTC12x12Unorm       :: 93;
    ASTC12x12UnormSrgb   :: 94;
    Force32              :: 2147483647;

    WGPUTextureFormat_Undefined            :: Undefined;
    WGPUTextureFormat_R8Unorm              :: R8Unorm;
    WGPUTextureFormat_R8Snorm              :: R8Snorm;
    WGPUTextureFormat_R8Uint               :: R8Uint;
    WGPUTextureFormat_R8Sint               :: R8Sint;
    WGPUTextureFormat_R16Uint              :: R16Uint;
    WGPUTextureFormat_R16Sint              :: R16Sint;
    WGPUTextureFormat_R16Float             :: R16Float;
    WGPUTextureFormat_RG8Unorm             :: RG8Unorm;
    WGPUTextureFormat_RG8Snorm             :: RG8Snorm;
    WGPUTextureFormat_RG8Uint              :: RG8Uint;
    WGPUTextureFormat_RG8Sint              :: RG8Sint;
    WGPUTextureFormat_R32Float             :: R32Float;
    WGPUTextureFormat_R32Uint              :: R32Uint;
    WGPUTextureFormat_R32Sint              :: R32Sint;
    WGPUTextureFormat_RG16Uint             :: RG16Uint;
    WGPUTextureFormat_RG16Sint             :: RG16Sint;
    WGPUTextureFormat_RG16Float            :: RG16Float;
    WGPUTextureFormat_RGBA8Unorm           :: RGBA8Unorm;
    WGPUTextureFormat_RGBA8UnormSrgb       :: RGBA8UnormSrgb;
    WGPUTextureFormat_RGBA8Snorm           :: RGBA8Snorm;
    WGPUTextureFormat_RGBA8Uint            :: RGBA8Uint;
    WGPUTextureFormat_RGBA8Sint            :: RGBA8Sint;
    WGPUTextureFormat_BGRA8Unorm           :: BGRA8Unorm;
    WGPUTextureFormat_BGRA8UnormSrgb       :: BGRA8UnormSrgb;
    WGPUTextureFormat_RGB10A2Unorm         :: RGB10A2Unorm;
    WGPUTextureFormat_RG11B10Ufloat        :: RG11B10Ufloat;
    WGPUTextureFormat_RGB9E5Ufloat         :: RGB9E5Ufloat;
    WGPUTextureFormat_RG32Float            :: RG32Float;
    WGPUTextureFormat_RG32Uint             :: RG32Uint;
    WGPUTextureFormat_RG32Sint             :: RG32Sint;
    WGPUTextureFormat_RGBA16Uint           :: RGBA16Uint;
    WGPUTextureFormat_RGBA16Sint           :: RGBA16Sint;
    WGPUTextureFormat_RGBA16Float          :: RGBA16Float;
    WGPUTextureFormat_RGBA32Float          :: RGBA32Float;
    WGPUTextureFormat_RGBA32Uint           :: RGBA32Uint;
    WGPUTextureFormat_RGBA32Sint           :: RGBA32Sint;
    WGPUTextureFormat_Stencil8             :: Stencil8;
    WGPUTextureFormat_Depth16Unorm         :: Depth16Unorm;
    WGPUTextureFormat_Depth24Plus          :: Depth24Plus;
    WGPUTextureFormat_Depth24PlusStencil8  :: Depth24PlusStencil8;
    WGPUTextureFormat_Depth32Float         :: Depth32Float;
    WGPUTextureFormat_Depth32FloatStencil8 :: Depth32FloatStencil8;
    WGPUTextureFormat_BC1RGBAUnorm         :: BC1RGBAUnorm;
    WGPUTextureFormat_BC1RGBAUnormSrgb     :: BC1RGBAUnormSrgb;
    WGPUTextureFormat_BC2RGBAUnorm         :: BC2RGBAUnorm;
    WGPUTextureFormat_BC2RGBAUnormSrgb     :: BC2RGBAUnormSrgb;
    WGPUTextureFormat_BC3RGBAUnorm         :: BC3RGBAUnorm;
    WGPUTextureFormat_BC3RGBAUnormSrgb     :: BC3RGBAUnormSrgb;
    WGPUTextureFormat_BC4RUnorm            :: BC4RUnorm;
    WGPUTextureFormat_BC4RSnorm            :: BC4RSnorm;
    WGPUTextureFormat_BC5RGUnorm           :: BC5RGUnorm;
    WGPUTextureFormat_BC5RGSnorm           :: BC5RGSnorm;
    WGPUTextureFormat_BC6HRGBUfloat        :: BC6HRGBUfloat;
    WGPUTextureFormat_BC6HRGBFloat         :: BC6HRGBFloat;
    WGPUTextureFormat_BC7RGBAUnorm         :: BC7RGBAUnorm;
    WGPUTextureFormat_BC7RGBAUnormSrgb     :: BC7RGBAUnormSrgb;
    WGPUTextureFormat_ETC2RGB8Unorm        :: ETC2RGB8Unorm;
    WGPUTextureFormat_ETC2RGB8UnormSrgb    :: ETC2RGB8UnormSrgb;
    WGPUTextureFormat_ETC2RGB8A1Unorm      :: ETC2RGB8A1Unorm;
    WGPUTextureFormat_ETC2RGB8A1UnormSrgb  :: ETC2RGB8A1UnormSrgb;
    WGPUTextureFormat_ETC2RGBA8Unorm       :: ETC2RGBA8Unorm;
    WGPUTextureFormat_ETC2RGBA8UnormSrgb   :: ETC2RGBA8UnormSrgb;
    WGPUTextureFormat_EACR11Unorm          :: EACR11Unorm;
    WGPUTextureFormat_EACR11Snorm          :: EACR11Snorm;
    WGPUTextureFormat_EACRG11Unorm         :: EACRG11Unorm;
    WGPUTextureFormat_EACRG11Snorm         :: EACRG11Snorm;
    WGPUTextureFormat_ASTC4x4Unorm         :: ASTC4x4Unorm;
    WGPUTextureFormat_ASTC4x4UnormSrgb     :: ASTC4x4UnormSrgb;
    WGPUTextureFormat_ASTC5x4Unorm         :: ASTC5x4Unorm;
    WGPUTextureFormat_ASTC5x4UnormSrgb     :: ASTC5x4UnormSrgb;
    WGPUTextureFormat_ASTC5x5Unorm         :: ASTC5x5Unorm;
    WGPUTextureFormat_ASTC5x5UnormSrgb     :: ASTC5x5UnormSrgb;
    WGPUTextureFormat_ASTC6x5Unorm         :: ASTC6x5Unorm;
    WGPUTextureFormat_ASTC6x5UnormSrgb     :: ASTC6x5UnormSrgb;
    WGPUTextureFormat_ASTC6x6Unorm         :: ASTC6x6Unorm;
    WGPUTextureFormat_ASTC6x6UnormSrgb     :: ASTC6x6UnormSrgb;
    WGPUTextureFormat_ASTC8x5Unorm         :: ASTC8x5Unorm;
    WGPUTextureFormat_ASTC8x5UnormSrgb     :: ASTC8x5UnormSrgb;
    WGPUTextureFormat_ASTC8x6Unorm         :: ASTC8x6Unorm;
    WGPUTextureFormat_ASTC8x6UnormSrgb     :: ASTC8x6UnormSrgb;
    WGPUTextureFormat_ASTC8x8Unorm         :: ASTC8x8Unorm;
    WGPUTextureFormat_ASTC8x8UnormSrgb     :: ASTC8x8UnormSrgb;
    WGPUTextureFormat_ASTC10x5Unorm        :: ASTC10x5Unorm;
    WGPUTextureFormat_ASTC10x5UnormSrgb    :: ASTC10x5UnormSrgb;
    WGPUTextureFormat_ASTC10x6Unorm        :: ASTC10x6Unorm;
    WGPUTextureFormat_ASTC10x6UnormSrgb    :: ASTC10x6UnormSrgb;
    WGPUTextureFormat_ASTC10x8Unorm        :: ASTC10x8Unorm;
    WGPUTextureFormat_ASTC10x8UnormSrgb    :: ASTC10x8UnormSrgb;
    WGPUTextureFormat_ASTC10x10Unorm       :: ASTC10x10Unorm;
    WGPUTextureFormat_ASTC10x10UnormSrgb   :: ASTC10x10UnormSrgb;
    WGPUTextureFormat_ASTC12x10Unorm       :: ASTC12x10Unorm;
    WGPUTextureFormat_ASTC12x10UnormSrgb   :: ASTC12x10UnormSrgb;
    WGPUTextureFormat_ASTC12x12Unorm       :: ASTC12x12Unorm;
    WGPUTextureFormat_ASTC12x12UnormSrgb   :: ASTC12x12UnormSrgb;
    WGPUTextureFormat_Force32              :: Force32;
}

TextureSampleType :: enum u32 {
    Undefined         :: 0;
    Float             :: 1;
    UnfilterableFloat :: 2;
    Depth             :: 3;
    Sint              :: 4;
    Uint              :: 5;
    Force32           :: 2147483647;

    WGPUTextureSampleType_Undefined         :: Undefined;
    WGPUTextureSampleType_Float             :: Float;
    WGPUTextureSampleType_UnfilterableFloat :: UnfilterableFloat;
    WGPUTextureSampleType_Depth             :: Depth;
    WGPUTextureSampleType_Sint              :: Sint;
    WGPUTextureSampleType_Uint              :: Uint;
    WGPUTextureSampleType_Force32           :: Force32;
}

TextureViewDimension :: enum u32 {
    Undefined :: 0;
    _1D       :: 1;
    _2D       :: 2;
    _2DArray  :: 3;
    Cube      :: 4;
    CubeArray :: 5;
    _3D       :: 6;
    Force32   :: 2147483647;

    WGPUTextureViewDimension_Undefined :: Undefined;
    WGPUTextureViewDimension_1D        :: _1D;
    WGPUTextureViewDimension_2D        :: _2D;
    WGPUTextureViewDimension_2DArray   :: _2DArray;
    WGPUTextureViewDimension_Cube      :: Cube;
    WGPUTextureViewDimension_CubeArray :: CubeArray;
    WGPUTextureViewDimension_3D        :: _3D;
    WGPUTextureViewDimension_Force32   :: Force32;
}

VertexFormat :: enum u32 {
    Undefined :: 0;
    Uint8x2   :: 1;
    Uint8x4   :: 2;
    Sint8x2   :: 3;
    Sint8x4   :: 4;
    Unorm8x2  :: 5;
    Unorm8x4  :: 6;
    Snorm8x2  :: 7;
    Snorm8x4  :: 8;
    Uint16x2  :: 9;
    Uint16x4  :: 10;
    Sint16x2  :: 11;
    Sint16x4  :: 12;
    Unorm16x2 :: 13;
    Unorm16x4 :: 14;
    Snorm16x2 :: 15;
    Snorm16x4 :: 16;
    Float16x2 :: 17;
    Float16x4 :: 18;
    Float32   :: 19;
    Float32x2 :: 20;
    Float32x3 :: 21;
    Float32x4 :: 22;
    Uint32    :: 23;
    Uint32x2  :: 24;
    Uint32x3  :: 25;
    Uint32x4  :: 26;
    Sint32    :: 27;
    Sint32x2  :: 28;
    Sint32x3  :: 29;
    Sint32x4  :: 30;
    Force32   :: 2147483647;

    WGPUVertexFormat_Undefined :: Undefined;
    WGPUVertexFormat_Uint8x2   :: Uint8x2;
    WGPUVertexFormat_Uint8x4   :: Uint8x4;
    WGPUVertexFormat_Sint8x2   :: Sint8x2;
    WGPUVertexFormat_Sint8x4   :: Sint8x4;
    WGPUVertexFormat_Unorm8x2  :: Unorm8x2;
    WGPUVertexFormat_Unorm8x4  :: Unorm8x4;
    WGPUVertexFormat_Snorm8x2  :: Snorm8x2;
    WGPUVertexFormat_Snorm8x4  :: Snorm8x4;
    WGPUVertexFormat_Uint16x2  :: Uint16x2;
    WGPUVertexFormat_Uint16x4  :: Uint16x4;
    WGPUVertexFormat_Sint16x2  :: Sint16x2;
    WGPUVertexFormat_Sint16x4  :: Sint16x4;
    WGPUVertexFormat_Unorm16x2 :: Unorm16x2;
    WGPUVertexFormat_Unorm16x4 :: Unorm16x4;
    WGPUVertexFormat_Snorm16x2 :: Snorm16x2;
    WGPUVertexFormat_Snorm16x4 :: Snorm16x4;
    WGPUVertexFormat_Float16x2 :: Float16x2;
    WGPUVertexFormat_Float16x4 :: Float16x4;
    WGPUVertexFormat_Float32   :: Float32;
    WGPUVertexFormat_Float32x2 :: Float32x2;
    WGPUVertexFormat_Float32x3 :: Float32x3;
    WGPUVertexFormat_Float32x4 :: Float32x4;
    WGPUVertexFormat_Uint32    :: Uint32;
    WGPUVertexFormat_Uint32x2  :: Uint32x2;
    WGPUVertexFormat_Uint32x3  :: Uint32x3;
    WGPUVertexFormat_Uint32x4  :: Uint32x4;
    WGPUVertexFormat_Sint32    :: Sint32;
    WGPUVertexFormat_Sint32x2  :: Sint32x2;
    WGPUVertexFormat_Sint32x3  :: Sint32x3;
    WGPUVertexFormat_Sint32x4  :: Sint32x4;
    WGPUVertexFormat_Force32   :: Force32;
}

VertexStepMode :: enum u32 {
    Vertex              :: 0;
    Instance            :: 1;
    VertexBufferNotUsed :: 2;
    Force32             :: 2147483647;

    WGPUVertexStepMode_Vertex              :: Vertex;
    WGPUVertexStepMode_Instance            :: Instance;
    WGPUVertexStepMode_VertexBufferNotUsed :: VertexBufferNotUsed;
    WGPUVertexStepMode_Force32             :: Force32;
}

BufferUsage :: enum_flags u32 {
    None         :: 0;
    MapRead      :: 1;
    MapWrite     :: 2;
    CopySrc      :: 4;
    CopyDst      :: 8;
    Index        :: 16;
    Vertex       :: 32;
    Uniform      :: 64;
    Storage      :: 128;
    Indirect     :: 256;
    QueryResolve :: 512;
    Force32      :: 2147483647;

    WGPUBufferUsage_None         :: None;
    WGPUBufferUsage_MapRead      :: MapRead;
    WGPUBufferUsage_MapWrite     :: MapWrite;
    WGPUBufferUsage_CopySrc      :: CopySrc;
    WGPUBufferUsage_CopyDst      :: CopyDst;
    WGPUBufferUsage_Index        :: Index;
    WGPUBufferUsage_Vertex       :: Vertex;
    WGPUBufferUsage_Uniform      :: Uniform;
    WGPUBufferUsage_Storage      :: Storage;
    WGPUBufferUsage_Indirect     :: Indirect;
    WGPUBufferUsage_QueryResolve :: QueryResolve;
    WGPUBufferUsage_Force32      :: Force32;
}

BufferUsageFlags :: BufferUsage;

ColorWriteMask :: enum u32 {
    None    :: 0;
    Red     :: 1;
    Green   :: 2;
    Blue    :: 4;
    Alpha   :: 8;
    All     :: 15;
    Force32 :: 2147483647;

    WGPUColorWriteMask_None    :: None;
    WGPUColorWriteMask_Red     :: Red;
    WGPUColorWriteMask_Green   :: Green;
    WGPUColorWriteMask_Blue    :: Blue;
    WGPUColorWriteMask_Alpha   :: Alpha;
    WGPUColorWriteMask_All     :: All;
    WGPUColorWriteMask_Force32 :: Force32;
}

ColorWriteMaskFlags :: Flags;

MapMode :: enum u32 {
    None    :: 0;
    Read    :: 1;
    Write   :: 2;
    Force32 :: 2147483647;

    WGPUMapMode_None    :: None;
    WGPUMapMode_Read    :: Read;
    WGPUMapMode_Write   :: Write;
    WGPUMapMode_Force32 :: Force32;
}

MapModeFlags :: Flags;

ShaderStage :: enum_flags u32 {
    None     :: 0;
    Vertex   :: 1;
    Fragment :: 2;
    Compute  :: 4;
    Force32  :: 2147483647;

    WGPUShaderStage_None     :: None;
    WGPUShaderStage_Vertex   :: Vertex;
    WGPUShaderStage_Fragment :: Fragment;
    WGPUShaderStage_Compute  :: Compute;
    WGPUShaderStage_Force32  :: Force32;
}

ShaderStageFlags :: ShaderStage;

TextureUsage :: enum u32 {
    None             :: 0;
    CopySrc          :: 1;
    CopyDst          :: 2;
    TextureBinding   :: 4;
    StorageBinding   :: 8;
    RenderAttachment :: 16;
    Force32          :: 2147483647;

    WGPUTextureUsage_None             :: None;
    WGPUTextureUsage_CopySrc          :: CopySrc;
    WGPUTextureUsage_CopyDst          :: CopyDst;
    WGPUTextureUsage_TextureBinding   :: TextureBinding;
    WGPUTextureUsage_StorageBinding   :: StorageBinding;
    WGPUTextureUsage_RenderAttachment :: RenderAttachment;
    WGPUTextureUsage_Force32          :: Force32;
}

TextureUsageFlags :: Flags;

BufferMapCallback :: #type (status: BufferMapAsyncStatus, userdata: *void) -> void #c_call;
CompilationInfoCallback :: #type (status: CompilationInfoRequestStatus, compilationInfo: *CompilationInfo, userdata: *void) -> void #c_call;
CreateComputePipelineAsyncCallback :: #type (status: CreatePipelineAsyncStatus, pipeline: ComputePipeline, message: *u8, userdata: *void) -> void #c_call;
CreateRenderPipelineAsyncCallback :: #type (status: CreatePipelineAsyncStatus, pipeline: RenderPipeline, message: *u8, userdata: *void) -> void #c_call;
DeviceLostCallback :: #type (reason: DeviceLostReason, message: *u8, userdata: *void) -> void #c_call;
ErrorCallback :: #type (type: ErrorType, message: *u8, userdata: *void) -> void #c_call;
Proc :: #type () -> void #c_call;
QueueWorkDoneCallback :: #type (status: QueueWorkDoneStatus, userdata: *void) -> void #c_call;
RequestAdapterCallback :: #type (status: RequestAdapterStatus, adapter: Adapter, message: *u8, userdata: *void) -> void #c_call;
RequestDeviceCallback :: #type (status: RequestDeviceStatus, device: Device, message: *u8, userdata: *void) -> void #c_call;

ChainedStruct :: struct {
    next:  *ChainedStruct;
    sType: SType;
}

ChainedStructOut :: struct {
    next:  *ChainedStructOut;
    sType: SType;
}

// Structure forward declarations
AdapterProperties :: struct {
    nextInChain:       *ChainedStructOut;
    vendorID:          u32;
    vendorName:        *u8;
    architecture:      *u8;
    deviceID:          u32;
    name:              *u8;
    driverDescription: *u8;
    adapterType:       AdapterType;
    backendType:       BackendType;
}

BindGroupEntry :: struct {
    nextInChain: *ChainedStruct;
    binding:     u32;
    buffer:      Buffer;
    offset:      u64;
    size:        u64;
    sampler:     Sampler;
    textureView: TextureView;
}

BlendComponent :: struct {
    operation: BlendOperation;
    srcFactor: BlendFactor;
    dstFactor: BlendFactor;
}

BufferBindingLayout :: struct {
    nextInChain:      *ChainedStruct;
    type:             BufferBindingType;
    hasDynamicOffset: bool;
    minBindingSize:   u64;
}

BufferDescriptor :: struct {
    nextInChain:      *ChainedStruct;
    label:            *u8;
    usage:            BufferUsageFlags;
    size:             u64;
    mappedAtCreation: bool;
}

Color :: struct {
    r: float64;
    g: float64;
    b: float64;
    a: float64;
}

CommandBufferDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label:       *u8;
}

CommandEncoderDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label:       *u8;
}

CompilationMessage :: struct {
    nextInChain:  *ChainedStruct;
    message:      *u8;
    type:         CompilationMessageType;
    lineNum:      u64;
    linePos:      u64;
    offset:       u64;
    length:       u64;
    utf16LinePos: u64;
    utf16Offset:  u64;
    utf16Length:  u64;
}

ComputePassTimestampWrite :: struct {
    querySet:   QuerySet;
    queryIndex: u32;
    location:   ComputePassTimestampLocation;
}

ConstantEntry :: struct {
    nextInChain: *ChainedStruct;
    key:         *u8;
    value:       float64;
}

Extent3D :: struct {
    width:              u32;
    height:             u32;
    depthOrArrayLayers: u32;
}

InstanceDescriptor :: struct {
    nextInChain: *ChainedStruct;
}

Limits :: struct {
    maxTextureDimension1D:                     u32;
    maxTextureDimension2D:                     u32;
    maxTextureDimension3D:                     u32;
    maxTextureArrayLayers:                     u32;
    maxBindGroups:                             u32;
    maxBindingsPerBindGroup:                   u32;
    maxDynamicUniformBuffersPerPipelineLayout: u32;
    maxDynamicStorageBuffersPerPipelineLayout: u32;
    maxSampledTexturesPerShaderStage:          u32;
    maxSamplersPerShaderStage:                 u32;
    maxStorageBuffersPerShaderStage:           u32;
    maxStorageTexturesPerShaderStage:          u32;
    maxUniformBuffersPerShaderStage:           u32;
    maxUniformBufferBindingSize:               u64;
    maxStorageBufferBindingSize:               u64;
    minUniformBufferOffsetAlignment:           u32;
    minStorageBufferOffsetAlignment:           u32;
    maxVertexBuffers:                          u32;
    maxBufferSize:                             u64;
    maxVertexAttributes:                       u32;
    maxVertexBufferArrayStride:                u32;
    maxInterStageShaderComponents:             u32;
    maxInterStageShaderVariables:              u32;
    maxColorAttachments:                       u32;
    maxColorAttachmentBytesPerSample:          u32;
    maxComputeWorkgroupStorageSize:            u32;
    maxComputeInvocationsPerWorkgroup:         u32;
    maxComputeWorkgroupSizeX:                  u32;
    maxComputeWorkgroupSizeY:                  u32;
    maxComputeWorkgroupSizeZ:                  u32;
    maxComputeWorkgroupsPerDimension:          u32;
}

MultisampleState :: struct {
    nextInChain:            *ChainedStruct;
    count:                  u32;
    mask:                   u32;
    alphaToCoverageEnabled: bool;
}

Origin3D :: struct {
    x: u32;
    y: u32;
    z: u32;
}

PipelineLayoutDescriptor :: struct {
    nextInChain:          *ChainedStruct;
    label:                *u8;
    bindGroupLayoutCount: u64;
    bindGroupLayouts:     *BindGroupLayout;
}

// Can be chained in WGPUPrimitiveState
PrimitiveDepthClipControl :: struct {
    chain:          ChainedStruct;
    unclippedDepth: bool;
}

PrimitiveState :: struct {
    nextInChain:      *ChainedStruct;
    topology:         PrimitiveTopology;
    stripIndexFormat: IndexFormat;
    frontFace:        FrontFace;
    cullMode:         CullMode;
}

QuerySetDescriptor :: struct {
    nextInChain:             *ChainedStruct;
    label:                   *u8;
    type:                    QueryType;
    count:                   u32;
    pipelineStatistics:      *PipelineStatisticName;
    pipelineStatisticsCount: u64;
}

QueueDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label:       *u8;
}

RenderBundleDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label:       *u8;
}

RenderBundleEncoderDescriptor :: struct {
    nextInChain:        *ChainedStruct;
    label:              *u8;
    colorFormatsCount:  u64;
    colorFormats:       *TextureFormat;
    depthStencilFormat: TextureFormat;
    sampleCount:        u32;
    depthReadOnly:      bool;
    stencilReadOnly:    bool;
}

RenderPassDepthStencilAttachment :: struct {
    view:              TextureView;
    depthLoadOp:       LoadOp;
    depthStoreOp:      StoreOp;
    depthClearValue:   float;
    depthReadOnly:     bool;
    stencilLoadOp:     LoadOp;
    stencilStoreOp:    StoreOp;
    stencilClearValue: u32;
    stencilReadOnly:   bool;
}

// Can be chained in WGPURenderPassDescriptor
RenderPassDescriptorMaxDrawCount :: struct {
    chain:        ChainedStruct;
    maxDrawCount: u64;
}

RenderPassTimestampWrite :: struct {
    querySet:   QuerySet;
    queryIndex: u32;
    location:   RenderPassTimestampLocation;
}

RequestAdapterOptions :: struct {
    nextInChain:          *ChainedStruct;
    compatibleSurface:    Surface;
    powerPreference:      PowerPreference;
    backendType:          BackendType;
    forceFallbackAdapter: bool;
}

SamplerBindingLayout :: struct {
    nextInChain: *ChainedStruct;
    type:        SamplerBindingType;
}

SamplerDescriptor :: struct {
    nextInChain:   *ChainedStruct;
    label:         *u8;
    addressModeU:  AddressMode;
    addressModeV:  AddressMode;
    addressModeW:  AddressMode;
    magFilter:     FilterMode;
    minFilter:     FilterMode;
    mipmapFilter:  MipmapFilterMode;
    lodMinClamp:   float;
    lodMaxClamp:   float;
    compare:       CompareFunction;
    maxAnisotropy: u16;
}

ShaderModuleCompilationHint :: struct {
    nextInChain: *ChainedStruct;
    entryPoint:  *u8;
    layout:      PipelineLayout;
}

// Can be chained in WGPUShaderModuleDescriptor
ShaderModuleSPIRVDescriptor :: struct {
    chain:    ChainedStruct = .{
        sType = .ShaderModuleSPIRVDescriptor,   
    };
    codeSize: u32;
    code:     *u32;
}

// Can be chained in WGPUShaderModuleDescriptor
ShaderModuleWGSLDescriptor :: struct {
    chain: ChainedStruct = .{
        sType = SType.ShaderModuleWGSLDescriptor,
    };
    code:  *u8;
}

StencilFaceState :: struct {
    compare:     CompareFunction = .Always;
    failOp:      StencilOperation = .Keep;
    depthFailOp: StencilOperation = .Keep;
    passOp:      StencilOperation = .Keep;
}

StorageTextureBindingLayout :: struct {
    nextInChain:   *ChainedStruct;
    access:        StorageTextureAccess;
    format:        TextureFormat;
    viewDimension: TextureViewDimension;
}

SurfaceDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label:       *u8;
}

// Can be chained in WGPUSurfaceDescriptor
SurfaceDescriptorFromAndroidNativeWindow :: struct {
    chain:  ChainedStruct = .{
        sType = .SurfaceDescriptorFromAndroidNativeWindow,
    };
    window: *void;
}

// Can be chained in WGPUSurfaceDescriptor
SurfaceDescriptorFromCanvasHTMLSelector :: struct {
    chain:    ChainedStruct = .{
        sType = .SurfaceDescriptorFromCanvasHTMLSelector,
    };
    selector: *u8;
}

// Can be chained in WGPUSurfaceDescriptor
SurfaceDescriptorFromMetalLayer :: struct {
    chain: ChainedStruct = .{
        sType = .SurfaceDescriptorFromMetalLayer,
    };
    layer: *void;
}

// Can be chained in WGPUSurfaceDescriptor
SurfaceDescriptorFromWaylandSurface :: struct {
    chain:   ChainedStruct = .{
        sType = .SurfaceDescriptorFromWaylandSurface,
    };
    display: *void;
    surface: *void;
}

// Can be chained in WGPUSurfaceDescriptor
SurfaceDescriptorFromWindowsHWND :: struct {
    chain:     ChainedStruct = .{
        sType = .SurfaceDescriptorFromWindowsHWND,
    };
    hinstance: *void;
    hwnd:      *void;
}

// Can be chained in WGPUSurfaceDescriptor
SurfaceDescriptorFromXcbWindow :: struct {
    chain:      ChainedStruct = .{
        sType = .SurfaceDescriptorFromXcbWindow,
    };
    connection: *void;
    window:     u32;
}

// Can be chained in WGPUSurfaceDescriptor
SurfaceDescriptorFromXlibWindow :: struct {
    chain:   ChainedStruct = .{
        sType = .SurfaceDescriptorFromXlibWindow,
    };
    display: *void;
    window:  u32;
}

SwapChainDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label:       *u8;
    usage:       TextureUsageFlags;
    format:      TextureFormat;
    width:       u32;
    height:      u32;
    presentMode: PresentMode;
}

TextureBindingLayout :: struct {
    nextInChain:   *ChainedStruct;
    sampleType:    TextureSampleType;
    viewDimension: TextureViewDimension;
    multisampled:  bool;
}

TextureDataLayout :: struct {
    nextInChain:  *ChainedStruct;
    offset:       u64;
    bytesPerRow:  u32;
    rowsPerImage: u32;
}

TextureViewDescriptor :: struct {
    nextInChain:     *ChainedStruct;
    label:           *u8;
    format:          TextureFormat;
    dimension:       TextureViewDimension;
    baseMipLevel:    u32;
    mipLevelCount:   u32;
    baseArrayLayer:  u32;
    arrayLayerCount: u32;
    aspect:          TextureAspect;
}

VertexAttribute :: struct {
    format:         VertexFormat;
    offset:         u64;
    shaderLocation: u32;
}

BindGroupDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label:       *u8;
    layout:      BindGroupLayout;
    entryCount:  u64;
    entries:     *BindGroupEntry;
}

BindGroupLayoutEntry :: struct {
    nextInChain:    *ChainedStruct;
    binding:        u32;
    visibility:     ShaderStageFlags;
    buffer:         BufferBindingLayout;
    sampler:        SamplerBindingLayout;
    texture:        TextureBindingLayout;
    storageTexture: StorageTextureBindingLayout;
}

BlendState :: struct {
    color: BlendComponent;
    alpha: BlendComponent;
}

CompilationInfo :: struct {
    nextInChain:  *ChainedStruct;
    messageCount: u64;
    messages:     *CompilationMessage;
}

ComputePassDescriptor :: struct {
    nextInChain:         *ChainedStruct;
    label:               *u8;
    timestampWriteCount: u64;
    timestampWrites:     *ComputePassTimestampWrite;
}

DepthStencilState :: struct {
    nextInChain:         *ChainedStruct;
    format:              TextureFormat;
    depthWriteEnabled:   bool;
    depthCompare:        CompareFunction;
    stencilFront:        StencilFaceState;
    stencilBack:         StencilFaceState;
    stencilReadMask:     u32;
    stencilWriteMask:    u32;
    depthBias:           s32;
    depthBiasSlopeScale: float;
    depthBiasClamp:      float;
}

ImageCopyBuffer :: struct {
    nextInChain: *ChainedStruct;
    layout:      TextureDataLayout;
    buffer:      Buffer;
}

ImageCopyTexture :: struct {
    nextInChain: *ChainedStruct;
    texture:     Texture;
    mipLevel:    u32;
    origin:      Origin3D;
    aspect:      TextureAspect;
}

ProgrammableStageDescriptor :: struct {
    nextInChain:   *ChainedStruct;
    module:        ShaderModule;
    entryPoint:    *u8;
    constantCount: u64;
    constants:     *ConstantEntry;
}

RenderPassColorAttachment :: struct {
    view:          TextureView;
    resolveTarget: TextureView;
    loadOp:        LoadOp;
    storeOp:       StoreOp;
    clearValue:    Color;
}

RequiredLimits :: struct {
    nextInChain: *ChainedStruct;
    limits:      Limits;
}

ShaderModuleDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label:       *u8;
    hintCount:   u64;
    hints:       *ShaderModuleCompilationHint;
}

SupportedLimits :: struct {
    nextInChain: *ChainedStructOut;
    limits:      Limits;
}

TextureDescriptor :: struct {
    nextInChain:     *ChainedStruct;
    label:           *u8;
    usage:           TextureUsageFlags;
    dimension:       TextureDimension;
    size:            Extent3D;
    format:          TextureFormat;
    mipLevelCount:   u32;
    sampleCount:     u32;
    viewFormatCount: u64;
    viewFormats:     *TextureFormat;
}

VertexBufferLayout :: struct {
    arrayStride:    u64;
    stepMode:       VertexStepMode;
    attributeCount: u64;
    attributes:     *VertexAttribute;
}

BindGroupLayoutDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label:       *u8;
    entryCount:  u64;
    entries:     *BindGroupLayoutEntry;
}

ColorTargetState :: struct {
    nextInChain: *ChainedStruct;
    format:      TextureFormat;
    blend:       *BlendState;
    writeMask:   ColorWriteMaskFlags;
}

ComputePipelineDescriptor :: struct {
    nextInChain: *ChainedStruct;
    label:       *u8;
    layout:      PipelineLayout;
    compute:     ProgrammableStageDescriptor;
}

DeviceDescriptor :: struct {
    nextInChain:           *ChainedStruct;
    label:                 *u8;
    requiredFeaturesCount: u64;
    requiredFeatures:      *FeatureName;
    requiredLimits:        *RequiredLimits;
    defaultQueue:          QueueDescriptor;
    deviceLostCallback:    DeviceLostCallback;
    deviceLostUserdata:    *void;
}

RenderPassDescriptor :: struct {
    nextInChain:            *ChainedStruct;
    label:                  *u8;
    colorAttachmentCount:   u64;
    colorAttachments:       *RenderPassColorAttachment;
    depthStencilAttachment: *RenderPassDepthStencilAttachment;
    occlusionQuerySet:      QuerySet;
    timestampWriteCount:    u64;
    timestampWrites:        *RenderPassTimestampWrite;
}

VertexState :: struct {
    nextInChain:   *ChainedStruct;
    module:        ShaderModule;
    entryPoint:    *u8;
    constantCount: u64;
    constants:     *ConstantEntry;
    bufferCount:   u64;
    buffers:       *VertexBufferLayout;
}

FragmentState :: struct {
    nextInChain:   *ChainedStruct;
    module:        ShaderModule;
    entryPoint:    *u8;
    constantCount: u64;
    constants:     *ConstantEntry;
    targetCount:   u64;
    targets:       *ColorTargetState;
}

RenderPipelineDescriptor :: struct {
    nextInChain:  *ChainedStruct;
    label:        *u8;
    layout:       PipelineLayout;
    vertex:       VertexState;
    primitive:    PrimitiveState;
    depthStencil: *DepthStencilState;
    multisample:  MultisampleState;
    fragment:     *FragmentState;
}

CreateInstance :: (descriptor: *InstanceDescriptor) -> Instance #foreign wgpu_native "wgpuCreateInstance";
GetProcAddress :: (device: Device, procName: *u8) -> Proc #foreign wgpu_native "wgpuGetProcAddress";

// Methods of Adapter
AdapterEnumerateFeatures :: (adapter: Adapter, features: *FeatureName) -> u64 #foreign wgpu_native "wgpuAdapterEnumerateFeatures";
AdapterGetLimits :: (adapter: Adapter, limits: *SupportedLimits) -> bool #foreign wgpu_native "wgpuAdapterGetLimits";
AdapterGetProperties :: (adapter: Adapter, properties: *AdapterProperties) -> void #foreign wgpu_native "wgpuAdapterGetProperties";
AdapterHasFeature :: (adapter: Adapter, feature: FeatureName) -> bool #foreign wgpu_native "wgpuAdapterHasFeature";
AdapterRequestDevice :: (adapter: Adapter, descriptor: *DeviceDescriptor, callback: RequestDeviceCallback, userdata: *void) -> void #foreign wgpu_native "wgpuAdapterRequestDevice";
AdapterReference :: (adapter: Adapter) -> void #foreign wgpu_native "wgpuAdapterReference";
AdapterRelease :: (adapter: Adapter) -> void #foreign wgpu_native "wgpuAdapterRelease";

// Methods of BindGroup
BindGroupSetLabel :: (bindGroup: BindGroup, label: *u8) -> void #foreign wgpu_native "wgpuBindGroupSetLabel";
BindGroupReference :: (bindGroup: BindGroup) -> void #foreign wgpu_native "wgpuBindGroupReference";
BindGroupRelease :: (bindGroup: BindGroup) -> void #foreign wgpu_native "wgpuBindGroupRelease";

// Methods of BindGroupLayout
BindGroupLayoutSetLabel :: (bindGroupLayout: BindGroupLayout, label: *u8) -> void #foreign wgpu_native "wgpuBindGroupLayoutSetLabel";
BindGroupLayoutReference :: (bindGroupLayout: BindGroupLayout) -> void #foreign wgpu_native "wgpuBindGroupLayoutReference";
BindGroupLayoutRelease :: (bindGroupLayout: BindGroupLayout) -> void #foreign wgpu_native "wgpuBindGroupLayoutRelease";

// Methods of Buffer
BufferDestroy :: (buffer: Buffer) -> void #foreign wgpu_native "wgpuBufferDestroy";
BufferGetConstMappedRange :: (buffer: Buffer, offset: u64, size: u64) -> *void #foreign wgpu_native "wgpuBufferGetConstMappedRange";
BufferGetMapState :: (buffer: Buffer) -> BufferMapState #foreign wgpu_native "wgpuBufferGetMapState";
BufferGetMappedRange :: (buffer: Buffer, offset: u64, size: u64) -> *void #foreign wgpu_native "wgpuBufferGetMappedRange";
BufferGetSize :: (buffer: Buffer) -> u64 #foreign wgpu_native "wgpuBufferGetSize";
BufferGetUsage :: (buffer: Buffer) -> BufferUsageFlags #foreign wgpu_native "wgpuBufferGetUsage";
BufferMapAsync :: (buffer: Buffer, mode: MapModeFlags, offset: u64, size: u64, callback: BufferMapCallback, userdata: *void) -> void #foreign wgpu_native "wgpuBufferMapAsync";
BufferSetLabel :: (buffer: Buffer, label: *u8) -> void #foreign wgpu_native "wgpuBufferSetLabel";
BufferUnmap :: (buffer: Buffer) -> void #foreign wgpu_native "wgpuBufferUnmap";
BufferReference :: (buffer: Buffer) -> void #foreign wgpu_native "wgpuBufferReference";
BufferRelease :: (buffer: Buffer) -> void #foreign wgpu_native "wgpuBufferRelease";

// Methods of CommandBuffer
CommandBufferSetLabel :: (commandBuffer: CommandBuffer, label: *u8) -> void #foreign wgpu_native "wgpuCommandBufferSetLabel";
CommandBufferReference :: (commandBuffer: CommandBuffer) -> void #foreign wgpu_native "wgpuCommandBufferReference";
CommandBufferRelease :: (commandBuffer: CommandBuffer) -> void #foreign wgpu_native "wgpuCommandBufferRelease";

// Methods of CommandEncoder
CommandEncoderBeginComputePass :: (commandEncoder: CommandEncoder, descriptor: *ComputePassDescriptor) -> ComputePassEncoder #foreign wgpu_native "wgpuCommandEncoderBeginComputePass";
CommandEncoderBeginRenderPass :: (commandEncoder: CommandEncoder, descriptor: *RenderPassDescriptor) -> RenderPassEncoder #foreign wgpu_native "wgpuCommandEncoderBeginRenderPass";
CommandEncoderClearBuffer :: (commandEncoder: CommandEncoder, buffer: Buffer, offset: u64, size: u64) -> void #foreign wgpu_native "wgpuCommandEncoderClearBuffer";
CommandEncoderCopyBufferToBuffer :: (commandEncoder: CommandEncoder, source: Buffer, sourceOffset: u64, destination: Buffer, destinationOffset: u64, size: u64) -> void #foreign wgpu_native "wgpuCommandEncoderCopyBufferToBuffer";
CommandEncoderCopyBufferToTexture :: (commandEncoder: CommandEncoder, source: *ImageCopyBuffer, destination: *ImageCopyTexture, copySize: *Extent3D) -> void #foreign wgpu_native "wgpuCommandEncoderCopyBufferToTexture";
CommandEncoderCopyTextureToBuffer :: (commandEncoder: CommandEncoder, source: *ImageCopyTexture, destination: *ImageCopyBuffer, copySize: *Extent3D) -> void #foreign wgpu_native "wgpuCommandEncoderCopyTextureToBuffer";
CommandEncoderCopyTextureToTexture :: (commandEncoder: CommandEncoder, source: *ImageCopyTexture, destination: *ImageCopyTexture, copySize: *Extent3D) -> void #foreign wgpu_native "wgpuCommandEncoderCopyTextureToTexture";
CommandEncoderFinish :: (commandEncoder: CommandEncoder, descriptor: *CommandBufferDescriptor) -> CommandBuffer #foreign wgpu_native "wgpuCommandEncoderFinish";
CommandEncoderInsertDebugMarker :: (commandEncoder: CommandEncoder, markerLabel: *u8) -> void #foreign wgpu_native "wgpuCommandEncoderInsertDebugMarker";
CommandEncoderPopDebugGroup :: (commandEncoder: CommandEncoder) -> void #foreign wgpu_native "wgpuCommandEncoderPopDebugGroup";
CommandEncoderPushDebugGroup :: (commandEncoder: CommandEncoder, groupLabel: *u8) -> void #foreign wgpu_native "wgpuCommandEncoderPushDebugGroup";
CommandEncoderResolveQuerySet :: (commandEncoder: CommandEncoder, querySet: QuerySet, firstQuery: u32, queryCount: u32, destination: Buffer, destinationOffset: u64) -> void #foreign wgpu_native "wgpuCommandEncoderResolveQuerySet";
CommandEncoderSetLabel :: (commandEncoder: CommandEncoder, label: *u8) -> void #foreign wgpu_native "wgpuCommandEncoderSetLabel";
CommandEncoderWriteTimestamp :: (commandEncoder: CommandEncoder, querySet: QuerySet, queryIndex: u32) -> void #foreign wgpu_native "wgpuCommandEncoderWriteTimestamp";
CommandEncoderReference :: (commandEncoder: CommandEncoder) -> void #foreign wgpu_native "wgpuCommandEncoderReference";
CommandEncoderRelease :: (commandEncoder: CommandEncoder) -> void #foreign wgpu_native "wgpuCommandEncoderRelease";

// Methods of ComputePassEncoder
ComputePassEncoderBeginPipelineStatisticsQuery :: (computePassEncoder: ComputePassEncoder, querySet: QuerySet, queryIndex: u32) -> void #foreign wgpu_native "wgpuComputePassEncoderBeginPipelineStatisticsQuery";
ComputePassEncoderDispatchWorkgroups :: (computePassEncoder: ComputePassEncoder, workgroupCountX: u32, workgroupCountY: u32, workgroupCountZ: u32) -> void #foreign wgpu_native "wgpuComputePassEncoderDispatchWorkgroups";
ComputePassEncoderDispatchWorkgroupsIndirect :: (computePassEncoder: ComputePassEncoder, indirectBuffer: Buffer, indirectOffset: u64) -> void #foreign wgpu_native "wgpuComputePassEncoderDispatchWorkgroupsIndirect";
ComputePassEncoderEnd :: (computePassEncoder: ComputePassEncoder) -> void #foreign wgpu_native "wgpuComputePassEncoderEnd";
ComputePassEncoderEndPipelineStatisticsQuery :: (computePassEncoder: ComputePassEncoder) -> void #foreign wgpu_native "wgpuComputePassEncoderEndPipelineStatisticsQuery";
ComputePassEncoderInsertDebugMarker :: (computePassEncoder: ComputePassEncoder, markerLabel: *u8) -> void #foreign wgpu_native "wgpuComputePassEncoderInsertDebugMarker";
ComputePassEncoderPopDebugGroup :: (computePassEncoder: ComputePassEncoder) -> void #foreign wgpu_native "wgpuComputePassEncoderPopDebugGroup";
ComputePassEncoderPushDebugGroup :: (computePassEncoder: ComputePassEncoder, groupLabel: *u8) -> void #foreign wgpu_native "wgpuComputePassEncoderPushDebugGroup";
ComputePassEncoderSetBindGroup :: (computePassEncoder: ComputePassEncoder, groupIndex: u32, group: BindGroup, dynamicOffsetCount: u64, dynamicOffsets: *u32) -> void #foreign wgpu_native "wgpuComputePassEncoderSetBindGroup";
ComputePassEncoderSetLabel :: (computePassEncoder: ComputePassEncoder, label: *u8) -> void #foreign wgpu_native "wgpuComputePassEncoderSetLabel";
ComputePassEncoderSetPipeline :: (computePassEncoder: ComputePassEncoder, pipeline: ComputePipeline) -> void #foreign wgpu_native "wgpuComputePassEncoderSetPipeline";
ComputePassEncoderReference :: (computePassEncoder: ComputePassEncoder) -> void #foreign wgpu_native "wgpuComputePassEncoderReference";
ComputePassEncoderRelease :: (computePassEncoder: ComputePassEncoder) -> void #foreign wgpu_native "wgpuComputePassEncoderRelease";

// Methods of ComputePipeline
ComputePipelineGetBindGroupLayout :: (computePipeline: ComputePipeline, groupIndex: u32) -> BindGroupLayout #foreign wgpu_native "wgpuComputePipelineGetBindGroupLayout";
ComputePipelineSetLabel :: (computePipeline: ComputePipeline, label: *u8) -> void #foreign wgpu_native "wgpuComputePipelineSetLabel";
ComputePipelineReference :: (computePipeline: ComputePipeline) -> void #foreign wgpu_native "wgpuComputePipelineReference";
ComputePipelineRelease :: (computePipeline: ComputePipeline) -> void #foreign wgpu_native "wgpuComputePipelineRelease";

// Methods of Device
DeviceCreateBindGroup :: (device: Device, descriptor: *BindGroupDescriptor) -> BindGroup #foreign wgpu_native "wgpuDeviceCreateBindGroup";
DeviceCreateBindGroupLayout :: (device: Device, descriptor: *BindGroupLayoutDescriptor) -> BindGroupLayout #foreign wgpu_native "wgpuDeviceCreateBindGroupLayout";
DeviceCreateBuffer :: (device: Device, descriptor: *BufferDescriptor) -> Buffer #foreign wgpu_native "wgpuDeviceCreateBuffer";
DeviceCreateCommandEncoder :: (device: Device, descriptor: *CommandEncoderDescriptor) -> CommandEncoder #foreign wgpu_native "wgpuDeviceCreateCommandEncoder";
DeviceCreateComputePipeline :: (device: Device, descriptor: *ComputePipelineDescriptor) -> ComputePipeline #foreign wgpu_native "wgpuDeviceCreateComputePipeline";
DeviceCreateComputePipelineAsync :: (device: Device, descriptor: *ComputePipelineDescriptor, callback: CreateComputePipelineAsyncCallback, userdata: *void) -> void #foreign wgpu_native "wgpuDeviceCreateComputePipelineAsync";
DeviceCreatePipelineLayout :: (device: Device, descriptor: *PipelineLayoutDescriptor) -> PipelineLayout #foreign wgpu_native "wgpuDeviceCreatePipelineLayout";
DeviceCreateQuerySet :: (device: Device, descriptor: *QuerySetDescriptor) -> QuerySet #foreign wgpu_native "wgpuDeviceCreateQuerySet";
DeviceCreateRenderBundleEncoder :: (device: Device, descriptor: *RenderBundleEncoderDescriptor) -> RenderBundleEncoder #foreign wgpu_native "wgpuDeviceCreateRenderBundleEncoder";
DeviceCreateRenderPipeline :: (device: Device, descriptor: *RenderPipelineDescriptor) -> RenderPipeline #foreign wgpu_native "wgpuDeviceCreateRenderPipeline";
DeviceCreateRenderPipelineAsync :: (device: Device, descriptor: *RenderPipelineDescriptor, callback: CreateRenderPipelineAsyncCallback, userdata: *void) -> void #foreign wgpu_native "wgpuDeviceCreateRenderPipelineAsync";
DeviceCreateSampler :: (device: Device, descriptor: *SamplerDescriptor) -> Sampler #foreign wgpu_native "wgpuDeviceCreateSampler";
DeviceCreateShaderModule :: (device: Device, descriptor: *ShaderModuleDescriptor) -> ShaderModule #foreign wgpu_native "wgpuDeviceCreateShaderModule";
DeviceCreateSwapChain :: (device: Device, surface: Surface, descriptor: *SwapChainDescriptor) -> SwapChain #foreign wgpu_native "wgpuDeviceCreateSwapChain";
DeviceCreateTexture :: (device: Device, descriptor: *TextureDescriptor) -> Texture #foreign wgpu_native "wgpuDeviceCreateTexture";
DeviceDestroy :: (device: Device) -> void #foreign wgpu_native "wgpuDeviceDestroy";
DeviceEnumerateFeatures :: (device: Device, features: *FeatureName) -> u64 #foreign wgpu_native "wgpuDeviceEnumerateFeatures";
DeviceGetLimits :: (device: Device, limits: *SupportedLimits) -> bool #foreign wgpu_native "wgpuDeviceGetLimits";
DeviceGetQueue :: (device: Device) -> Queue #foreign wgpu_native "wgpuDeviceGetQueue";
DeviceHasFeature :: (device: Device, feature: FeatureName) -> bool #foreign wgpu_native "wgpuDeviceHasFeature";
DevicePopErrorScope :: (device: Device, callback: ErrorCallback, userdata: *void) -> void #foreign wgpu_native "wgpuDevicePopErrorScope";
DevicePushErrorScope :: (device: Device, filter: ErrorFilter) -> void #foreign wgpu_native "wgpuDevicePushErrorScope";
DeviceSetLabel :: (device: Device, label: *u8) -> void #foreign wgpu_native "wgpuDeviceSetLabel";
DeviceSetUncapturedErrorCallback :: (device: Device, callback: ErrorCallback, userdata: *void) -> void #foreign wgpu_native "wgpuDeviceSetUncapturedErrorCallback";
DeviceReference :: (device: Device) -> void #foreign wgpu_native "wgpuDeviceReference";
DeviceRelease :: (device: Device) -> void #foreign wgpu_native "wgpuDeviceRelease";

// Methods of Instance
InstanceCreateSurface :: (instance: Instance, descriptor: *SurfaceDescriptor) -> Surface #foreign wgpu_native "wgpuInstanceCreateSurface";
InstanceProcessEvents :: (instance: Instance) -> void #foreign wgpu_native "wgpuInstanceProcessEvents";
InstanceRequestAdapter :: (instance: Instance, options: *RequestAdapterOptions, callback: RequestAdapterCallback, userdata: *void) -> void #foreign wgpu_native "wgpuInstanceRequestAdapter";
InstanceReference :: (instance: Instance) -> void #foreign wgpu_native "wgpuInstanceReference";
InstanceRelease :: (instance: Instance) -> void #foreign wgpu_native "wgpuInstanceRelease";

// Methods of PipelineLayout
PipelineLayoutSetLabel :: (pipelineLayout: PipelineLayout, label: *u8) -> void #foreign wgpu_native "wgpuPipelineLayoutSetLabel";
PipelineLayoutReference :: (pipelineLayout: PipelineLayout) -> void #foreign wgpu_native "wgpuPipelineLayoutReference";
PipelineLayoutRelease :: (pipelineLayout: PipelineLayout) -> void #foreign wgpu_native "wgpuPipelineLayoutRelease";

// Methods of QuerySet
QuerySetDestroy :: (querySet: QuerySet) -> void #foreign wgpu_native "wgpuQuerySetDestroy";
QuerySetGetCount :: (querySet: QuerySet) -> u32 #foreign wgpu_native "wgpuQuerySetGetCount";
QuerySetGetType :: (querySet: QuerySet) -> QueryType #foreign wgpu_native "wgpuQuerySetGetType";
QuerySetSetLabel :: (querySet: QuerySet, label: *u8) -> void #foreign wgpu_native "wgpuQuerySetSetLabel";
QuerySetReference :: (querySet: QuerySet) -> void #foreign wgpu_native "wgpuQuerySetReference";
QuerySetRelease :: (querySet: QuerySet) -> void #foreign wgpu_native "wgpuQuerySetRelease";

// Methods of Queue
QueueOnSubmittedWorkDone :: (queue: Queue, callback: QueueWorkDoneCallback, userdata: *void) -> void #foreign wgpu_native "wgpuQueueOnSubmittedWorkDone";
QueueSetLabel :: (queue: Queue, label: *u8) -> void #foreign wgpu_native "wgpuQueueSetLabel";
QueueSubmit :: (queue: Queue, commandCount: u64, commands: *CommandBuffer) -> void #foreign wgpu_native "wgpuQueueSubmit";
QueueWriteBuffer :: (queue: Queue, buffer: Buffer, bufferOffset: u64, data: *void, size: u64) -> void #foreign wgpu_native "wgpuQueueWriteBuffer";
QueueWriteTexture :: (queue: Queue, destination: *ImageCopyTexture, data: *void, dataSize: u64, dataLayout: *TextureDataLayout, writeSize: *Extent3D) -> void #foreign wgpu_native "wgpuQueueWriteTexture";
QueueReference :: (queue: Queue) -> void #foreign wgpu_native "wgpuQueueReference";
QueueRelease :: (queue: Queue) -> void #foreign wgpu_native "wgpuQueueRelease";

// Methods of RenderBundle
RenderBundleSetLabel :: (renderBundle: RenderBundle, label: *u8) -> void #foreign wgpu_native "wgpuRenderBundleSetLabel";
RenderBundleReference :: (renderBundle: RenderBundle) -> void #foreign wgpu_native "wgpuRenderBundleReference";
RenderBundleRelease :: (renderBundle: RenderBundle) -> void #foreign wgpu_native "wgpuRenderBundleRelease";

// Methods of RenderBundleEncoder
RenderBundleEncoderDraw :: (renderBundleEncoder: RenderBundleEncoder, vertexCount: u32, instanceCount: u32, firstVertex: u32, firstInstance: u32) -> void #foreign wgpu_native "wgpuRenderBundleEncoderDraw";
RenderBundleEncoderDrawIndexed :: (renderBundleEncoder: RenderBundleEncoder, indexCount: u32, instanceCount: u32, firstIndex: u32, baseVertex: s32, firstInstance: u32) -> void #foreign wgpu_native "wgpuRenderBundleEncoderDrawIndexed";
RenderBundleEncoderDrawIndexedIndirect :: (renderBundleEncoder: RenderBundleEncoder, indirectBuffer: Buffer, indirectOffset: u64) -> void #foreign wgpu_native "wgpuRenderBundleEncoderDrawIndexedIndirect";
RenderBundleEncoderDrawIndirect :: (renderBundleEncoder: RenderBundleEncoder, indirectBuffer: Buffer, indirectOffset: u64) -> void #foreign wgpu_native "wgpuRenderBundleEncoderDrawIndirect";
RenderBundleEncoderFinish :: (renderBundleEncoder: RenderBundleEncoder, descriptor: *RenderBundleDescriptor) -> RenderBundle #foreign wgpu_native "wgpuRenderBundleEncoderFinish";
RenderBundleEncoderInsertDebugMarker :: (renderBundleEncoder: RenderBundleEncoder, markerLabel: *u8) -> void #foreign wgpu_native "wgpuRenderBundleEncoderInsertDebugMarker";
RenderBundleEncoderPopDebugGroup :: (renderBundleEncoder: RenderBundleEncoder) -> void #foreign wgpu_native "wgpuRenderBundleEncoderPopDebugGroup";
RenderBundleEncoderPushDebugGroup :: (renderBundleEncoder: RenderBundleEncoder, groupLabel: *u8) -> void #foreign wgpu_native "wgpuRenderBundleEncoderPushDebugGroup";
RenderBundleEncoderSetBindGroup :: (renderBundleEncoder: RenderBundleEncoder, groupIndex: u32, group: BindGroup, dynamicOffsetCount: u64, dynamicOffsets: *u32) -> void #foreign wgpu_native "wgpuRenderBundleEncoderSetBindGroup";
RenderBundleEncoderSetIndexBuffer :: (renderBundleEncoder: RenderBundleEncoder, buffer: Buffer, format: IndexFormat, offset: u64, size: u64) -> void #foreign wgpu_native "wgpuRenderBundleEncoderSetIndexBuffer";
RenderBundleEncoderSetLabel :: (renderBundleEncoder: RenderBundleEncoder, label: *u8) -> void #foreign wgpu_native "wgpuRenderBundleEncoderSetLabel";
RenderBundleEncoderSetPipeline :: (renderBundleEncoder: RenderBundleEncoder, pipeline: RenderPipeline) -> void #foreign wgpu_native "wgpuRenderBundleEncoderSetPipeline";
RenderBundleEncoderSetVertexBuffer :: (renderBundleEncoder: RenderBundleEncoder, slot: u32, buffer: Buffer, offset: u64, size: u64) -> void #foreign wgpu_native "wgpuRenderBundleEncoderSetVertexBuffer";
RenderBundleEncoderReference :: (renderBundleEncoder: RenderBundleEncoder) -> void #foreign wgpu_native "wgpuRenderBundleEncoderReference";
RenderBundleEncoderRelease :: (renderBundleEncoder: RenderBundleEncoder) -> void #foreign wgpu_native "wgpuRenderBundleEncoderRelease";

// Methods of RenderPassEncoder
RenderPassEncoderBeginOcclusionQuery :: (renderPassEncoder: RenderPassEncoder, queryIndex: u32) -> void #foreign wgpu_native "wgpuRenderPassEncoderBeginOcclusionQuery";
RenderPassEncoderBeginPipelineStatisticsQuery :: (renderPassEncoder: RenderPassEncoder, querySet: QuerySet, queryIndex: u32) -> void #foreign wgpu_native "wgpuRenderPassEncoderBeginPipelineStatisticsQuery";
RenderPassEncoderDraw :: (renderPassEncoder: RenderPassEncoder, vertexCount: u32, instanceCount: u32, firstVertex: u32, firstInstance: u32) -> void #foreign wgpu_native "wgpuRenderPassEncoderDraw";
RenderPassEncoderDrawIndexed :: (renderPassEncoder: RenderPassEncoder, indexCount: u32, instanceCount: u32, firstIndex: u32, baseVertex: s32, firstInstance: u32) -> void #foreign wgpu_native "wgpuRenderPassEncoderDrawIndexed";
RenderPassEncoderDrawIndexedIndirect :: (renderPassEncoder: RenderPassEncoder, indirectBuffer: Buffer, indirectOffset: u64) -> void #foreign wgpu_native "wgpuRenderPassEncoderDrawIndexedIndirect";
RenderPassEncoderDrawIndirect :: (renderPassEncoder: RenderPassEncoder, indirectBuffer: Buffer, indirectOffset: u64) -> void #foreign wgpu_native "wgpuRenderPassEncoderDrawIndirect";
RenderPassEncoderEnd :: (renderPassEncoder: RenderPassEncoder) -> void #foreign wgpu_native "wgpuRenderPassEncoderEnd";
RenderPassEncoderEndOcclusionQuery :: (renderPassEncoder: RenderPassEncoder) -> void #foreign wgpu_native "wgpuRenderPassEncoderEndOcclusionQuery";
RenderPassEncoderEndPipelineStatisticsQuery :: (renderPassEncoder: RenderPassEncoder) -> void #foreign wgpu_native "wgpuRenderPassEncoderEndPipelineStatisticsQuery";
RenderPassEncoderExecuteBundles :: (renderPassEncoder: RenderPassEncoder, bundleCount: u64, bundles: *RenderBundle) -> void #foreign wgpu_native "wgpuRenderPassEncoderExecuteBundles";
RenderPassEncoderInsertDebugMarker :: (renderPassEncoder: RenderPassEncoder, markerLabel: *u8) -> void #foreign wgpu_native "wgpuRenderPassEncoderInsertDebugMarker";
RenderPassEncoderPopDebugGroup :: (renderPassEncoder: RenderPassEncoder) -> void #foreign wgpu_native "wgpuRenderPassEncoderPopDebugGroup";
RenderPassEncoderPushDebugGroup :: (renderPassEncoder: RenderPassEncoder, groupLabel: *u8) -> void #foreign wgpu_native "wgpuRenderPassEncoderPushDebugGroup";
RenderPassEncoderSetBindGroup :: (renderPassEncoder: RenderPassEncoder, groupIndex: u32, group: BindGroup, dynamicOffsetCount: u64, dynamicOffsets: *u32) -> void #foreign wgpu_native "wgpuRenderPassEncoderSetBindGroup";
RenderPassEncoderSetBlendConstant :: (renderPassEncoder: RenderPassEncoder, color: *Color) -> void #foreign wgpu_native "wgpuRenderPassEncoderSetBlendConstant";
RenderPassEncoderSetIndexBuffer :: (renderPassEncoder: RenderPassEncoder, buffer: Buffer, format: IndexFormat, offset: u64, size: u64) -> void #foreign wgpu_native "wgpuRenderPassEncoderSetIndexBuffer";
RenderPassEncoderSetLabel :: (renderPassEncoder: RenderPassEncoder, label: *u8) -> void #foreign wgpu_native "wgpuRenderPassEncoderSetLabel";
RenderPassEncoderSetPipeline :: (renderPassEncoder: RenderPassEncoder, pipeline: RenderPipeline) -> void #foreign wgpu_native "wgpuRenderPassEncoderSetPipeline";
RenderPassEncoderSetScissorRect :: (renderPassEncoder: RenderPassEncoder, x: u32, y: u32, width: u32, height: u32) -> void #foreign wgpu_native "wgpuRenderPassEncoderSetScissorRect";
RenderPassEncoderSetStencilReference :: (renderPassEncoder: RenderPassEncoder, reference: u32) -> void #foreign wgpu_native "wgpuRenderPassEncoderSetStencilReference";
RenderPassEncoderSetVertexBuffer :: (renderPassEncoder: RenderPassEncoder, slot: u32, buffer: Buffer, offset: u64, size: u64) -> void #foreign wgpu_native "wgpuRenderPassEncoderSetVertexBuffer";
RenderPassEncoderSetViewport :: (renderPassEncoder: RenderPassEncoder, x: float, y: float, width: float, height: float, minDepth: float, maxDepth: float) -> void #foreign wgpu_native "wgpuRenderPassEncoderSetViewport";
RenderPassEncoderReference :: (renderPassEncoder: RenderPassEncoder) -> void #foreign wgpu_native "wgpuRenderPassEncoderReference";
RenderPassEncoderRelease :: (renderPassEncoder: RenderPassEncoder) -> void #foreign wgpu_native "wgpuRenderPassEncoderRelease";

// Methods of RenderPipeline
RenderPipelineGetBindGroupLayout :: (renderPipeline: RenderPipeline, groupIndex: u32) -> BindGroupLayout #foreign wgpu_native "wgpuRenderPipelineGetBindGroupLayout";
RenderPipelineSetLabel :: (renderPipeline: RenderPipeline, label: *u8) -> void #foreign wgpu_native "wgpuRenderPipelineSetLabel";
RenderPipelineReference :: (renderPipeline: RenderPipeline) -> void #foreign wgpu_native "wgpuRenderPipelineReference";
RenderPipelineRelease :: (renderPipeline: RenderPipeline) -> void #foreign wgpu_native "wgpuRenderPipelineRelease";

// Methods of Sampler
SamplerSetLabel :: (sampler: Sampler, label: *u8) -> void #foreign wgpu_native "wgpuSamplerSetLabel";
SamplerReference :: (sampler: Sampler) -> void #foreign wgpu_native "wgpuSamplerReference";
SamplerRelease :: (sampler: Sampler) -> void #foreign wgpu_native "wgpuSamplerRelease";

// Methods of ShaderModule
ShaderModuleGetCompilationInfo :: (shaderModule: ShaderModule, callback: CompilationInfoCallback, userdata: *void) -> void #foreign wgpu_native "wgpuShaderModuleGetCompilationInfo";
ShaderModuleSetLabel :: (shaderModule: ShaderModule, label: *u8) -> void #foreign wgpu_native "wgpuShaderModuleSetLabel";
ShaderModuleReference :: (shaderModule: ShaderModule) -> void #foreign wgpu_native "wgpuShaderModuleReference";
ShaderModuleRelease :: (shaderModule: ShaderModule) -> void #foreign wgpu_native "wgpuShaderModuleRelease";

// Methods of Surface
SurfaceGetPreferredFormat :: (surface: Surface, adapter: Adapter) -> TextureFormat #foreign wgpu_native "wgpuSurfaceGetPreferredFormat";
SurfaceReference :: (surface: Surface) -> void #foreign wgpu_native "wgpuSurfaceReference";
SurfaceRelease :: (surface: Surface) -> void #foreign wgpu_native "wgpuSurfaceRelease";

// Methods of SwapChain
SwapChainGetCurrentTextureView :: (swapChain: SwapChain) -> TextureView #foreign wgpu_native "wgpuSwapChainGetCurrentTextureView";
SwapChainPresent :: (swapChain: SwapChain) -> void #foreign wgpu_native "wgpuSwapChainPresent";
SwapChainReference :: (swapChain: SwapChain) -> void #foreign wgpu_native "wgpuSwapChainReference";
SwapChainRelease :: (swapChain: SwapChain) -> void #foreign wgpu_native "wgpuSwapChainRelease";

// Methods of Texture
TextureCreateView :: (texture: Texture, descriptor: *TextureViewDescriptor) -> TextureView #foreign wgpu_native "wgpuTextureCreateView";
TextureDestroy :: (texture: Texture) -> void #foreign wgpu_native "wgpuTextureDestroy";
TextureGetDepthOrArrayLayers :: (texture: Texture) -> u32 #foreign wgpu_native "wgpuTextureGetDepthOrArrayLayers";
TextureGetDimension :: (texture: Texture) -> TextureDimension #foreign wgpu_native "wgpuTextureGetDimension";
TextureGetFormat :: (texture: Texture) -> TextureFormat #foreign wgpu_native "wgpuTextureGetFormat";
TextureGetHeight :: (texture: Texture) -> u32 #foreign wgpu_native "wgpuTextureGetHeight";
TextureGetMipLevelCount :: (texture: Texture) -> u32 #foreign wgpu_native "wgpuTextureGetMipLevelCount";
TextureGetSampleCount :: (texture: Texture) -> u32 #foreign wgpu_native "wgpuTextureGetSampleCount";
TextureGetUsage :: (texture: Texture) -> TextureUsageFlags #foreign wgpu_native "wgpuTextureGetUsage";
TextureGetWidth :: (texture: Texture) -> u32 #foreign wgpu_native "wgpuTextureGetWidth";
TextureSetLabel :: (texture: Texture, label: *u8) -> void #foreign wgpu_native "wgpuTextureSetLabel";
TextureReference :: (texture: Texture) -> void #foreign wgpu_native "wgpuTextureReference";
TextureRelease :: (texture: Texture) -> void #foreign wgpu_native "wgpuTextureRelease";

// Methods of TextureView
TextureViewSetLabel :: (textureView: TextureView, label: *u8) -> void #foreign wgpu_native "wgpuTextureViewSetLabel";
TextureViewReference :: (textureView: TextureView) -> void #foreign wgpu_native "wgpuTextureViewReference";
TextureViewRelease :: (textureView: TextureView) -> void #foreign wgpu_native "wgpuTextureViewRelease";

NativeSType :: enum u32 {
    SType_DeviceExtras               :: 1610612737;
    SType_AdapterExtras              :: 1610612738;
    SType_RequiredLimitsExtras       :: 1610612739;
    SType_PipelineLayoutExtras       :: 1610612740;
    SType_ShaderModuleGLSLDescriptor :: 1610612741;
    SType_SupportedLimitsExtras      :: 1610612739;
    SType_InstanceExtras             :: 1610612742;
    SType_SwapChainDescriptorExtras  :: 1610612743;
    Force32                          :: 2147483647;

    WGPUSType_DeviceExtras               :: SType_DeviceExtras;
    WGPUSType_AdapterExtras              :: SType_AdapterExtras;
    WGPUSType_RequiredLimitsExtras       :: SType_RequiredLimitsExtras;
    WGPUSType_PipelineLayoutExtras       :: SType_PipelineLayoutExtras;
    WGPUSType_ShaderModuleGLSLDescriptor :: SType_ShaderModuleGLSLDescriptor;
    WGPUSType_SupportedLimitsExtras      :: SType_SupportedLimitsExtras;
    WGPUSType_InstanceExtras             :: SType_InstanceExtras;
    WGPUSType_SwapChainDescriptorExtras  :: SType_SwapChainDescriptorExtras;
    WGPUNativeSType_Force32              :: Force32;
}

NativeFeature :: enum u32 {
    PushConstants                        :: 1610612737;
    TextureAdapterSpecificFormatFeatures :: 1610612738;
    MultiDrawIndirect                    :: 1610612739;
    MultiDrawIndirectCount               :: 1610612740;
    VertexWritableStorage                :: 1610612741;
    Force32                              :: 2147483647;

    WGPUNativeFeature_PushConstants                        :: PushConstants;
    WGPUNativeFeature_TextureAdapterSpecificFormatFeatures :: TextureAdapterSpecificFormatFeatures;
    WGPUNativeFeature_MultiDrawIndirect                    :: MultiDrawIndirect;
    WGPUNativeFeature_MultiDrawIndirectCount               :: MultiDrawIndirectCount;
    WGPUNativeFeature_VertexWritableStorage                :: VertexWritableStorage;
    WGPUNativeFeature_Force32                              :: Force32;
}

LogLevel :: enum u32 {
    Off     :: 0;
    Error   :: 1;
    Warn    :: 2;
    Info    :: 3;
    Debug   :: 4;
    Trace   :: 5;
    Force32 :: 2147483647;

    WGPULogLevel_Off     :: Off;
    WGPULogLevel_Error   :: Error;
    WGPULogLevel_Warn    :: Warn;
    WGPULogLevel_Info    :: Info;
    WGPULogLevel_Debug   :: Debug;
    WGPULogLevel_Trace   :: Trace;
    WGPULogLevel_Force32 :: Force32;
}

InstanceBackend :: enum u32 {
    Vulkan        :: 2;
    GL            :: 32;
    Metal         :: 4;
    DX12          :: 8;
    DX11          :: 16;
    BrowserWebGPU :: 64;
    Primary       :: 78;

    Secondary     :: 48;
    None          :: 0;
    Force32       :: 2147483647;

    WGPUInstanceBackend_Vulkan        :: Vulkan;
    WGPUInstanceBackend_GL            :: GL;
    WGPUInstanceBackend_Metal         :: Metal;
    WGPUInstanceBackend_DX12          :: DX12;
    WGPUInstanceBackend_DX11          :: DX11;
    WGPUInstanceBackend_BrowserWebGPU :: BrowserWebGPU;
    WGPUInstanceBackend_Primary       :: Primary;

    WGPUInstanceBackend_Secondary     :: Secondary;
    WGPUInstanceBackend_None          :: None;
    WGPUInstanceBackend_Force32       :: Force32;
}

InstanceBackendFlags :: Flags;

Dx12Compiler :: enum u32 {
    Undefined :: 0;
    Fxc       :: 1;
    Dxc       :: 2;
    Force32   :: 2147483647;

    WGPUDx12Compiler_Undefined :: Undefined;
    WGPUDx12Compiler_Fxc       :: Fxc;
    WGPUDx12Compiler_Dxc       :: Dxc;
    WGPUDx12Compiler_Force32   :: Force32;
}

CompositeAlphaMode :: enum u32 {
    Auto           :: 0;
    Opaque         :: 1;
    PreMultiplied  :: 2;
    PostMultiplied :: 3;
    Inherit        :: 4;
    Force32        :: 2147483647;

    WGPUCompositeAlphaMode_Auto           :: Auto;
    WGPUCompositeAlphaMode_Opaque         :: Opaque;
    WGPUCompositeAlphaMode_PreMultiplied  :: PreMultiplied;
    WGPUCompositeAlphaMode_PostMultiplied :: PostMultiplied;
    WGPUCompositeAlphaMode_Inherit        :: Inherit;
    WGPUCompositeAlphaMode_Force32        :: Force32;
}

InstanceExtras :: struct {
    chain:              ChainedStruct;
    backends:           InstanceBackendFlags;
    dx12ShaderCompiler: Dx12Compiler;
    dxilPath:           *u8;
    dxcPath:            *u8;
}

DeviceExtras :: struct {
    chain:     ChainedStruct;
    tracePath: *u8;
}

RequiredLimitsExtras :: struct {
    chain: ChainedStruct = .{
        sType = SType.RequiredLimitsExtras
    };
    maxPushConstantSize: u32;
}

SupportedLimitsExtras :: struct {
    chain:               ChainedStructOut;
    maxPushConstantSize: u32;
}

PushConstantRange :: struct {
    stages: ShaderStageFlags;
    start:  u32;
    end:    u32;
}

PipelineLayoutExtras :: struct {
    chain: ChainedStruct = .{    
        sType = SType.PipelineLayoutExtras,
    };
    pushConstantRangeCount: u32;
    pushConstantRanges:     *PushConstantRange;
}

SubmissionIndex :: u64;

WrappedSubmissionIndex :: struct {
    queue:           Queue;
    submissionIndex: SubmissionIndex;
}

ShaderDefine :: struct {
    name:  *u8;
    value: *u8;
}

ShaderModuleGLSLDescriptor :: struct {
    chain:       ChainedStruct;
    stage:       ShaderStage;
    code:        *u8;
    defineCount: u32;
    defines:     *ShaderDefine;
}

StorageReport :: struct {
    numOccupied: u64;
    numVacant:   u64;
    numError:    u64;
    elementSize: u64;
}

HubReport :: struct {
    adapters:         StorageReport;
    devices:          StorageReport;
    pipelineLayouts:  StorageReport;
    shaderModules:    StorageReport;
    bindGroupLayouts: StorageReport;
    bindGroups:       StorageReport;
    commandBuffers:   StorageReport;
    renderBundles:    StorageReport;
    renderPipelines:  StorageReport;
    computePipelines: StorageReport;
    querySets:        StorageReport;
    buffers:          StorageReport;
    textures:         StorageReport;
    textureViews:     StorageReport;
    samplers:         StorageReport;
}

GlobalReport :: struct {
    surfaces:    StorageReport;
    backendType: BackendType;
    vulkan:      HubReport;
    metal:       HubReport;
    dx12:        HubReport;
    dx11:        HubReport;
    gl:          HubReport;
}

SurfaceCapabilities :: struct {
    formatCount:      u64;
    formats:          *TextureFormat;
    presentModeCount: u64;
    presentModes:     *PresentMode;
    alphaModeCount:   u64;
    alphaModes:       *CompositeAlphaMode;
}

SwapChainDescriptorExtras :: struct {
    chain:           ChainedStruct;
    alphaMode:       CompositeAlphaMode;
    viewFormatCount: u64;
    viewFormats:     *TextureFormat;
}

InstanceEnumerateAdapterOptions :: struct {
    nextInChain: *ChainedStruct;
    backends:    InstanceBackendFlags;
}

LogCallback :: #type (level: LogLevel, message: *u8, userdata: *void) -> void #c_call;

GenerateReport :: (instance: Instance, report: *GlobalReport) -> void #foreign wgpu_native "wgpuGenerateReport";
InstanceEnumerateAdapters :: (instance: Instance, options: *InstanceEnumerateAdapterOptions, adapters: *Adapter) -> u64 #foreign wgpu_native "wgpuInstanceEnumerateAdapters";

QueueSubmitForIndex :: (queue: Queue, commandCount: u64, commands: *CommandBuffer) -> SubmissionIndex #foreign wgpu_native "wgpuQueueSubmitForIndex";

// Returns true if the queue is empty, or false if there are more queue submissions still in flight.
DevicePoll :: (device: Device, wait: bool, wrappedSubmissionIndex: *WrappedSubmissionIndex) -> bool #foreign wgpu_native "wgpuDevicePoll";

SetLogCallback :: (callback: LogCallback, userdata: *void) -> void #foreign wgpu_native "wgpuSetLogCallback";

SetLogLevel :: (level: LogLevel) -> void #foreign wgpu_native "wgpuSetLogLevel";

GetVersion :: () -> u32 #foreign wgpu_native "wgpuGetVersion";

SurfaceGetCapabilities :: (surface: Surface, adapter: Adapter, capabilities: *SurfaceCapabilities) -> void #foreign wgpu_native "wgpuSurfaceGetCapabilities";

RenderPassEncoderSetPushConstants :: (encoder: RenderPassEncoder, stages: ShaderStageFlags, offset: u32, sizeBytes: u32, data: *void) -> void #foreign wgpu_native "wgpuRenderPassEncoderSetPushConstants";

RenderPassEncoderMultiDrawIndirect :: (encoder: RenderPassEncoder, buffer: Buffer, offset: u64, count: u32) -> void #foreign wgpu_native "wgpuRenderPassEncoderMultiDrawIndirect";
RenderPassEncoderMultiDrawIndexedIndirect :: (encoder: RenderPassEncoder, buffer: Buffer, offset: u64, count: u32) -> void #foreign wgpu_native "wgpuRenderPassEncoderMultiDrawIndexedIndirect";

RenderPassEncoderMultiDrawIndirectCount :: (encoder: RenderPassEncoder, buffer: Buffer, offset: u64, count_buffer: Buffer, count_buffer_offset: u64, max_count: u32) -> void #foreign wgpu_native "wgpuRenderPassEncoderMultiDrawIndirectCount";
RenderPassEncoderMultiDrawIndexedIndirectCount :: (encoder: RenderPassEncoder, buffer: Buffer, offset: u64, count_buffer: Buffer, count_buffer_offset: u64, max_count: u32) -> void #foreign wgpu_native "wgpuRenderPassEncoderMultiDrawIndexedIndirectCount";

#scope_file

#scope_file

#if OS == .WINDOWS {
    wgpu_native :: #library,no_dll "windows/wgpu_native";
} else #if OS == .LINUX {
    wgpu_native :: #library,no_dll "linux/libwgpu_native";
} else #if OS == .MACOS {
    wgpu_native :: #library,no_dll "macos/libwgpu_native";
}
