//
// This file was auto-generated using the following command:
//
// jai ./generate.jai
//



VMA_VULKAN_VERSION :: 1003000;
VMA_DEDICATED_ALLOCATION :: 1;
VMA_BIND_MEMORY2 :: 1;
VMA_MEMORY_BUDGET :: 1;
VMA_BUFFER_DEVICE_ADDRESS :: 1;
VMA_MEMORY_PRIORITY :: 1;
VMA_EXTERNAL_MEMORY :: 1;
VMA_STATS_STRING_ENABLED :: 1;
VmaAllocatorCreateFlagBits :: enum s32 {
    EXTERNALLY_SYNCHRONIZED_BIT    :: 1;
    KHR_DEDICATED_ALLOCATION_BIT   :: 2;
    KHR_BIND_MEMORY2_BIT           :: 4;
    EXT_MEMORY_BUDGET_BIT          :: 8;
    AMD_DEVICE_COHERENT_MEMORY_BIT :: 16;
    BUFFER_DEVICE_ADDRESS_BIT      :: 32;
    EXT_MEMORY_PRIORITY_BIT        :: 64;
    FLAG_BITS_MAX_ENUM             :: 2147483647;

    VMA_ALLOCATOR_CREATE_EXTERNALLY_SYNCHRONIZED_BIT    :: EXTERNALLY_SYNCHRONIZED_BIT;
    VMA_ALLOCATOR_CREATE_KHR_DEDICATED_ALLOCATION_BIT   :: KHR_DEDICATED_ALLOCATION_BIT;
    VMA_ALLOCATOR_CREATE_KHR_BIND_MEMORY2_BIT           :: KHR_BIND_MEMORY2_BIT;
    VMA_ALLOCATOR_CREATE_EXT_MEMORY_BUDGET_BIT          :: EXT_MEMORY_BUDGET_BIT;
    VMA_ALLOCATOR_CREATE_AMD_DEVICE_COHERENT_MEMORY_BIT :: AMD_DEVICE_COHERENT_MEMORY_BIT;
    VMA_ALLOCATOR_CREATE_BUFFER_DEVICE_ADDRESS_BIT      :: BUFFER_DEVICE_ADDRESS_BIT;
    VMA_ALLOCATOR_CREATE_EXT_MEMORY_PRIORITY_BIT        :: EXT_MEMORY_PRIORITY_BIT;
    VMA_ALLOCATOR_CREATE_FLAG_BITS_MAX_ENUM             :: FLAG_BITS_MAX_ENUM;
}
VmaAllocatorCreateFlags :: VmaAllocatorCreateFlagBits;
VmaMemoryUsage :: enum s32 {
    UNKNOWN              :: 0;
    GPU_ONLY             :: 1;
    CPU_ONLY             :: 2;
    CPU_TO_GPU           :: 3;
    GPU_TO_CPU           :: 4;
    CPU_COPY             :: 5;
    GPU_LAZILY_ALLOCATED :: 6;
    AUTO                 :: 7;
    AUTO_PREFER_DEVICE   :: 8;
    AUTO_PREFER_HOST     :: 9;
    MAX_ENUM             :: 2147483647;

    VMA_MEMORY_USAGE_UNKNOWN              :: UNKNOWN;
    VMA_MEMORY_USAGE_GPU_ONLY             :: GPU_ONLY;
    VMA_MEMORY_USAGE_CPU_ONLY             :: CPU_ONLY;
    VMA_MEMORY_USAGE_CPU_TO_GPU           :: CPU_TO_GPU;
    VMA_MEMORY_USAGE_GPU_TO_CPU           :: GPU_TO_CPU;
    VMA_MEMORY_USAGE_CPU_COPY             :: CPU_COPY;
    VMA_MEMORY_USAGE_GPU_LAZILY_ALLOCATED :: GPU_LAZILY_ALLOCATED;
    VMA_MEMORY_USAGE_AUTO                 :: AUTO;
    VMA_MEMORY_USAGE_AUTO_PREFER_DEVICE   :: AUTO_PREFER_DEVICE;
    VMA_MEMORY_USAGE_AUTO_PREFER_HOST     :: AUTO_PREFER_HOST;
    VMA_MEMORY_USAGE_MAX_ENUM             :: MAX_ENUM;
}
VmaAllocationCreateFlagBits :: enum s32 {
    DEDICATED_MEMORY_BIT                   :: 1;
    NEVER_ALLOCATE_BIT                     :: 2;
    MAPPED_BIT                             :: 4;
    USER_DATA_COPY_STRING_BIT              :: 32;
    UPPER_ADDRESS_BIT                      :: 64;
    DONT_BIND_BIT                          :: 128;
    WITHIN_BUDGET_BIT                      :: 256;
    CAN_ALIAS_BIT                          :: 512;
    HOST_ACCESS_SEQUENTIAL_WRITE_BIT       :: 1024;
    HOST_ACCESS_RANDOM_BIT                 :: 2048;
    HOST_ACCESS_ALLOW_TRANSFER_INSTEAD_BIT :: 4096;
    STRATEGY_MIN_MEMORY_BIT                :: 65536;
    STRATEGY_MIN_TIME_BIT                  :: 131072;
    STRATEGY_MIN_OFFSET_BIT                :: 262144;
    STRATEGY_BEST_FIT_BIT                  :: 65536;
    STRATEGY_FIRST_FIT_BIT                 :: 131072;
    STRATEGY_MASK                          :: 458752;
    FLAG_BITS_MAX_ENUM                     :: 2147483647;

    VMA_ALLOCATION_CREATE_DEDICATED_MEMORY_BIT                   :: DEDICATED_MEMORY_BIT;
    VMA_ALLOCATION_CREATE_NEVER_ALLOCATE_BIT                     :: NEVER_ALLOCATE_BIT;
    VMA_ALLOCATION_CREATE_MAPPED_BIT                             :: MAPPED_BIT;
    VMA_ALLOCATION_CREATE_USER_DATA_COPY_STRING_BIT              :: USER_DATA_COPY_STRING_BIT;
    VMA_ALLOCATION_CREATE_UPPER_ADDRESS_BIT                      :: UPPER_ADDRESS_BIT;
    VMA_ALLOCATION_CREATE_DONT_BIND_BIT                          :: DONT_BIND_BIT;
    VMA_ALLOCATION_CREATE_WITHIN_BUDGET_BIT                      :: WITHIN_BUDGET_BIT;
    VMA_ALLOCATION_CREATE_CAN_ALIAS_BIT                          :: CAN_ALIAS_BIT;
    VMA_ALLOCATION_CREATE_HOST_ACCESS_SEQUENTIAL_WRITE_BIT       :: HOST_ACCESS_SEQUENTIAL_WRITE_BIT;
    VMA_ALLOCATION_CREATE_HOST_ACCESS_RANDOM_BIT                 :: HOST_ACCESS_RANDOM_BIT;
    VMA_ALLOCATION_CREATE_HOST_ACCESS_ALLOW_TRANSFER_INSTEAD_BIT :: HOST_ACCESS_ALLOW_TRANSFER_INSTEAD_BIT;
    VMA_ALLOCATION_CREATE_STRATEGY_MIN_MEMORY_BIT                :: STRATEGY_MIN_MEMORY_BIT;
    VMA_ALLOCATION_CREATE_STRATEGY_MIN_TIME_BIT                  :: STRATEGY_MIN_TIME_BIT;
    VMA_ALLOCATION_CREATE_STRATEGY_MIN_OFFSET_BIT                :: STRATEGY_MIN_OFFSET_BIT;
    VMA_ALLOCATION_CREATE_STRATEGY_BEST_FIT_BIT                  :: STRATEGY_BEST_FIT_BIT;
    VMA_ALLOCATION_CREATE_STRATEGY_FIRST_FIT_BIT                 :: STRATEGY_FIRST_FIT_BIT;
    VMA_ALLOCATION_CREATE_STRATEGY_MASK                          :: STRATEGY_MASK;
    VMA_ALLOCATION_CREATE_FLAG_BITS_MAX_ENUM                     :: FLAG_BITS_MAX_ENUM;
}
VmaAllocationCreateFlags :: VmaAllocationCreateFlagBits;

VmaPoolCreateFlagBits :: enum s32 {
    IGNORE_BUFFER_IMAGE_GRANULARITY_BIT :: 2;
    LINEAR_ALGORITHM_BIT                :: 4;
    ALGORITHM_MASK                      :: 4;
    FLAG_BITS_MAX_ENUM                  :: 2147483647;

    VMA_POOL_CREATE_IGNORE_BUFFER_IMAGE_GRANULARITY_BIT :: IGNORE_BUFFER_IMAGE_GRANULARITY_BIT;
    VMA_POOL_CREATE_LINEAR_ALGORITHM_BIT                :: LINEAR_ALGORITHM_BIT;
    VMA_POOL_CREATE_ALGORITHM_MASK                      :: ALGORITHM_MASK;
    VMA_POOL_CREATE_FLAG_BITS_MAX_ENUM                  :: FLAG_BITS_MAX_ENUM;
}
VmaPoolCreateFlags :: VkFlags;
VmaDefragmentationFlagBits :: enum s32 {
    ALGORITHM_FAST_BIT      :: 1;
    ALGORITHM_BALANCED_BIT  :: 2;
    ALGORITHM_FULL_BIT      :: 4;
    ALGORITHM_EXTENSIVE_BIT :: 8;
    ALGORITHM_MASK          :: 15;
    BITS_MAX_ENUM           :: 2147483647;

    VMA_DEFRAGMENTATION_FLAG_ALGORITHM_FAST_BIT      :: ALGORITHM_FAST_BIT;
    VMA_DEFRAGMENTATION_FLAG_ALGORITHM_BALANCED_BIT  :: ALGORITHM_BALANCED_BIT;
    VMA_DEFRAGMENTATION_FLAG_ALGORITHM_FULL_BIT      :: ALGORITHM_FULL_BIT;
    VMA_DEFRAGMENTATION_FLAG_ALGORITHM_EXTENSIVE_BIT :: ALGORITHM_EXTENSIVE_BIT;
    VMA_DEFRAGMENTATION_FLAG_ALGORITHM_MASK          :: ALGORITHM_MASK;
    VMA_DEFRAGMENTATION_FLAG_BITS_MAX_ENUM           :: BITS_MAX_ENUM;
}
VmaDefragmentationFlags :: VkFlags;
VmaDefragmentationMoveOperation :: enum s32 {
    COPY    :: 0;
    IGNORE  :: 1;
    DESTROY :: 2;

    VMA_DEFRAGMENTATION_MOVE_OPERATION_COPY    :: COPY;
    VMA_DEFRAGMENTATION_MOVE_OPERATION_IGNORE  :: IGNORE;
    VMA_DEFRAGMENTATION_MOVE_OPERATION_DESTROY :: DESTROY;
}
VmaVirtualBlockCreateFlagBits :: enum s32 {
    LINEAR_ALGORITHM_BIT :: 1;
    ALGORITHM_MASK       :: 1;
    FLAG_BITS_MAX_ENUM   :: 2147483647;

    VMA_VIRTUAL_BLOCK_CREATE_LINEAR_ALGORITHM_BIT :: LINEAR_ALGORITHM_BIT;
    VMA_VIRTUAL_BLOCK_CREATE_ALGORITHM_MASK       :: ALGORITHM_MASK;
    VMA_VIRTUAL_BLOCK_CREATE_FLAG_BITS_MAX_ENUM   :: FLAG_BITS_MAX_ENUM;
}
VmaVirtualBlockCreateFlags :: VkFlags;
VmaVirtualAllocationCreateFlagBits :: enum s32 {
    UPPER_ADDRESS_BIT       :: 64;
    STRATEGY_MIN_MEMORY_BIT :: 65536;
    STRATEGY_MIN_TIME_BIT   :: 131072;
    STRATEGY_MIN_OFFSET_BIT :: 262144;
    STRATEGY_MASK           :: 458752;
    FLAG_BITS_MAX_ENUM      :: 2147483647;

    VMA_VIRTUAL_ALLOCATION_CREATE_UPPER_ADDRESS_BIT       :: UPPER_ADDRESS_BIT;
    VMA_VIRTUAL_ALLOCATION_CREATE_STRATEGY_MIN_MEMORY_BIT :: STRATEGY_MIN_MEMORY_BIT;
    VMA_VIRTUAL_ALLOCATION_CREATE_STRATEGY_MIN_TIME_BIT   :: STRATEGY_MIN_TIME_BIT;
    VMA_VIRTUAL_ALLOCATION_CREATE_STRATEGY_MIN_OFFSET_BIT :: STRATEGY_MIN_OFFSET_BIT;
    VMA_VIRTUAL_ALLOCATION_CREATE_STRATEGY_MASK           :: STRATEGY_MASK;
    VMA_VIRTUAL_ALLOCATION_CREATE_FLAG_BITS_MAX_ENUM      :: FLAG_BITS_MAX_ENUM;
}
VmaVirtualAllocationCreateFlags :: VkFlags;
VmaAllocator_T :: struct {}
VmaAllocator :: *VmaAllocator_T;
VmaPool_T :: struct {}
VmaPool :: *VmaPool_T;
VmaAllocation_T :: struct {}
VmaAllocation :: *VmaAllocation_T;
VmaDefragmentationContext_T :: struct {}
VmaDefragmentationContext :: *VmaDefragmentationContext_T;
VmaVirtualAllocation_T :: struct {}
VmaVirtualAllocation :: *VmaVirtualAllocation_T;
VmaVirtualBlock_T :: struct {}
VmaVirtualBlock :: *VmaVirtualBlock_T;
PFN_vmaAllocateDeviceMemoryFunction :: #type (allocator: VmaAllocator, memoryType: u32, memory: VkDeviceMemory, size: VkDeviceSize, pUserData: *void) -> void #c_call;
PFN_vmaFreeDeviceMemoryFunction :: #type (allocator: VmaAllocator, memoryType: u32, memory: VkDeviceMemory, size: VkDeviceSize, pUserData: *void) -> void #c_call;
VmaDeviceMemoryCallbacks :: struct {
    pfnAllocate: PFN_vmaAllocateDeviceMemoryFunction;
    pfnFree:     PFN_vmaFreeDeviceMemoryFunction;
    pUserData:   *void;
}
VmaVulkanFunctions :: struct {
    vkGetInstanceProcAddr:                   PFN_vkGetInstanceProcAddr;
    vkGetDeviceProcAddr:                     PFN_vkGetDeviceProcAddr;
    vkGetPhysicalDeviceProperties:           PFN_vkGetPhysicalDeviceProperties;
    vkGetPhysicalDeviceMemoryProperties:     PFN_vkGetPhysicalDeviceMemoryProperties;
    vkAllocateMemory:                        PFN_vkAllocateMemory;
    vkFreeMemory:                            PFN_vkFreeMemory;
    vkMapMemory:                             PFN_vkMapMemory;
    vkUnmapMemory:                           PFN_vkUnmapMemory;
    vkFlushMappedMemoryRanges:               PFN_vkFlushMappedMemoryRanges;
    vkInvalidateMappedMemoryRanges:          PFN_vkInvalidateMappedMemoryRanges;
    vkBindBufferMemory:                      PFN_vkBindBufferMemory;
    vkBindImageMemory:                       PFN_vkBindImageMemory;
    vkGetBufferMemoryRequirements:           PFN_vkGetBufferMemoryRequirements;
    vkGetImageMemoryRequirements:            PFN_vkGetImageMemoryRequirements;
    vkCreateBuffer:                          PFN_vkCreateBuffer;
    vkDestroyBuffer:                         PFN_vkDestroyBuffer;
    vkCreateImage:                           PFN_vkCreateImage;
    vkDestroyImage:                          PFN_vkDestroyImage;
    vkCmdCopyBuffer:                         PFN_vkCmdCopyBuffer;
    vkGetBufferMemoryRequirements2KHR:       PFN_vkGetBufferMemoryRequirements2KHR;
    vkGetImageMemoryRequirements2KHR:        PFN_vkGetImageMemoryRequirements2KHR;
    vkBindBufferMemory2KHR:                  PFN_vkBindBufferMemory2KHR;
    vkBindImageMemory2KHR:                   PFN_vkBindImageMemory2KHR;
    vkGetPhysicalDeviceMemoryProperties2KHR: PFN_vkGetPhysicalDeviceMemoryProperties2KHR;
    vkGetDeviceBufferMemoryRequirements:     PFN_vkGetDeviceBufferMemoryRequirements;
    vkGetDeviceImageMemoryRequirements:      PFN_vkGetDeviceImageMemoryRequirements;
}
VmaAllocatorCreateInfo :: struct {
    flags:                          VmaAllocatorCreateFlags;
    physicalDevice:                 VkPhysicalDevice;
    device:                         VkDevice;
    preferredLargeHeapBlockSize:    VkDeviceSize;
    pAllocationCallbacks:           *VkAllocationCallbacks;
    pDeviceMemoryCallbacks:         *VmaDeviceMemoryCallbacks;
    pHeapSizeLimit:                 *VkDeviceSize;
    pVulkanFunctions:               *VmaVulkanFunctions;
    instance:                       VkInstance;
    vulkanApiVersion:               u32;
    pTypeExternalMemoryHandleTypes: *VkExternalMemoryHandleTypeFlagsKHR;
}
VmaAllocatorInfo :: struct {
    instance:       VkInstance;
    physicalDevice: VkPhysicalDevice;
    device:         VkDevice;
}
VmaStatistics :: struct {
    blockCount:      u32;
    allocationCount: u32;
    blockBytes:      VkDeviceSize;
    allocationBytes: VkDeviceSize;
}
VmaDetailedStatistics :: struct {
    statistics:         VmaStatistics;
    unusedRangeCount:   u32;
    allocationSizeMin:  VkDeviceSize;
    allocationSizeMax:  VkDeviceSize;
    unusedRangeSizeMin: VkDeviceSize;
    unusedRangeSizeMax: VkDeviceSize;
}
VmaTotalStatistics :: struct {
    memoryType: [32] VmaDetailedStatistics;
    memoryHeap: [16] VmaDetailedStatistics;
    total:      VmaDetailedStatistics;
}
VmaBudget :: struct {
    statistics: VmaStatistics;
    usage:      VkDeviceSize;
    budget:     VkDeviceSize;
}
VmaAllocationCreateInfo :: struct {
    flags:          VmaAllocationCreateFlags;
    usage:          VmaMemoryUsage;
    requiredFlags:  VkMemoryPropertyFlags;
    preferredFlags: VkMemoryPropertyFlags;
    memoryTypeBits: u32;
    pool:           VmaPool;
    pUserData:      *void;
    priority:       float;
}
VmaPoolCreateInfo :: struct {
    memoryTypeIndex:        u32;
    flags:                  VmaPoolCreateFlags;
    blockSize:              VkDeviceSize;
    minBlockCount:          u64;
    maxBlockCount:          u64;
    priority:               float;
    minAllocationAlignment: VkDeviceSize;
    pMemoryAllocateNext:    *void;
}
VmaAllocationInfo :: struct {
    memoryType:   u32;
    deviceMemory: VkDeviceMemory;
    offset:       VkDeviceSize;
    size:         VkDeviceSize;
    pMappedData:  *void;
    pUserData:    *void;
    pName:        *u8;
}
VmaDefragmentationInfo :: struct {
    flags:                 VmaDefragmentationFlags;
    pool:                  VmaPool;
    maxBytesPerPass:       VkDeviceSize;
    maxAllocationsPerPass: u32;
}
VmaDefragmentationMove :: struct {
    operation:        VmaDefragmentationMoveOperation;
    srcAllocation:    VmaAllocation;
    dstTmpAllocation: VmaAllocation;
}
VmaDefragmentationPassMoveInfo :: struct {
    moveCount: u32;
    pMoves:    *VmaDefragmentationMove;
}
VmaDefragmentationStats :: struct {
    bytesMoved:              VkDeviceSize;
    bytesFreed:              VkDeviceSize;
    allocationsMoved:        u32;
    deviceMemoryBlocksFreed: u32;
}
VmaVirtualBlockCreateInfo :: struct {
    size:                 VkDeviceSize;
    flags:                VmaVirtualBlockCreateFlags;
    pAllocationCallbacks: *VkAllocationCallbacks;
}
VmaVirtualAllocationCreateInfo :: struct {
    size:      VkDeviceSize;
    alignment: VkDeviceSize;
    flags:     VmaVirtualAllocationCreateFlags;
    pUserData: *void;
}
VmaVirtualAllocationInfo :: struct {
    offset:    VkDeviceSize;
    size:      VkDeviceSize;
    pUserData: *void;
}
vmaCreateAllocator :: (pCreateInfo: *VmaAllocatorCreateInfo, pAllocator: *VmaAllocator) -> VkResult #foreign vk_mem_alloc;
vmaDestroyAllocator :: (allocator: VmaAllocator) -> void #foreign vk_mem_alloc;
vmaGetAllocatorInfo :: (allocator: VmaAllocator, pAllocatorInfo: *VmaAllocatorInfo) -> void #foreign vk_mem_alloc;
vmaGetPhysicalDeviceProperties :: (allocator: VmaAllocator, ppPhysicalDeviceProperties: **VkPhysicalDeviceProperties) -> void #foreign vk_mem_alloc;
vmaGetMemoryProperties :: (allocator: VmaAllocator, ppPhysicalDeviceMemoryProperties: **VkPhysicalDeviceMemoryProperties) -> void #foreign vk_mem_alloc;
vmaGetMemoryTypeProperties :: (allocator: VmaAllocator, memoryTypeIndex: u32, pFlags: *VkMemoryPropertyFlags) -> void #foreign vk_mem_alloc;
vmaSetCurrentFrameIndex :: (allocator: VmaAllocator, frameIndex: u32) -> void #foreign vk_mem_alloc;
vmaCalculateStatistics :: (allocator: VmaAllocator, pStats: *VmaTotalStatistics) -> void #foreign vk_mem_alloc;
vmaGetHeapBudgets :: (allocator: VmaAllocator, pBudgets: *VmaBudget) -> void #foreign vk_mem_alloc;
vmaFindMemoryTypeIndex :: (allocator: VmaAllocator, memoryTypeBits: u32, pAllocationCreateInfo: *VmaAllocationCreateInfo, pMemoryTypeIndex: *u32) -> VkResult #foreign vk_mem_alloc;
vmaFindMemoryTypeIndexForBufferInfo :: (allocator: VmaAllocator, pBufferCreateInfo: *VkBufferCreateInfo, pAllocationCreateInfo: *VmaAllocationCreateInfo, pMemoryTypeIndex: *u32) -> VkResult #foreign vk_mem_alloc;
vmaFindMemoryTypeIndexForImageInfo :: (allocator: VmaAllocator, pImageCreateInfo: *VkImageCreateInfo, pAllocationCreateInfo: *VmaAllocationCreateInfo, pMemoryTypeIndex: *u32) -> VkResult #foreign vk_mem_alloc;
vmaCreatePool :: (allocator: VmaAllocator, pCreateInfo: *VmaPoolCreateInfo, pPool: *VmaPool) -> VkResult #foreign vk_mem_alloc;
vmaDestroyPool :: (allocator: VmaAllocator, pool: VmaPool) -> void #foreign vk_mem_alloc;
vmaGetPoolStatistics :: (allocator: VmaAllocator, pool: VmaPool, pPoolStats: *VmaStatistics) -> void #foreign vk_mem_alloc;
vmaCalculatePoolStatistics :: (allocator: VmaAllocator, pool: VmaPool, pPoolStats: *VmaDetailedStatistics) -> void #foreign vk_mem_alloc;
vmaCheckPoolCorruption :: (allocator: VmaAllocator, pool: VmaPool) -> VkResult #foreign vk_mem_alloc;
vmaGetPoolName :: (allocator: VmaAllocator, pool: VmaPool, ppName: **u8) -> void #foreign vk_mem_alloc;
vmaSetPoolName :: (allocator: VmaAllocator, pool: VmaPool, pName: *u8) -> void #foreign vk_mem_alloc;
vmaAllocateMemory :: (allocator: VmaAllocator, pVkMemoryRequirements: *VkMemoryRequirements, pCreateInfo: *VmaAllocationCreateInfo, pAllocation: *VmaAllocation, pAllocationInfo: *VmaAllocationInfo) -> VkResult #foreign vk_mem_alloc;
vmaAllocateMemoryPages :: (allocator: VmaAllocator, pVkMemoryRequirements: *VkMemoryRequirements, pCreateInfo: *VmaAllocationCreateInfo, allocationCount: u64, pAllocations: *VmaAllocation, pAllocationInfo: *VmaAllocationInfo) -> VkResult #foreign vk_mem_alloc;
vmaAllocateMemoryForBuffer :: (allocator: VmaAllocator, buffer: VkBuffer, pCreateInfo: *VmaAllocationCreateInfo, pAllocation: *VmaAllocation, pAllocationInfo: *VmaAllocationInfo) -> VkResult #foreign vk_mem_alloc;
vmaAllocateMemoryForImage :: (allocator: VmaAllocator, image: VkImage, pCreateInfo: *VmaAllocationCreateInfo, pAllocation: *VmaAllocation, pAllocationInfo: *VmaAllocationInfo) -> VkResult #foreign vk_mem_alloc;
vmaFreeMemory :: (allocator: VmaAllocator, allocation: VmaAllocation) -> void #foreign vk_mem_alloc;
vmaFreeMemoryPages :: (allocator: VmaAllocator, allocationCount: u64, pAllocations: *VmaAllocation) -> void #foreign vk_mem_alloc;
vmaGetAllocationInfo :: (allocator: VmaAllocator, allocation: VmaAllocation, pAllocationInfo: *VmaAllocationInfo) -> void #foreign vk_mem_alloc;
vmaSetAllocationUserData :: (allocator: VmaAllocator, allocation: VmaAllocation, pUserData: *void) -> void #foreign vk_mem_alloc;
vmaSetAllocationName :: (allocator: VmaAllocator, allocation: VmaAllocation, pName: *u8) -> void #foreign vk_mem_alloc;
vmaGetAllocationMemoryProperties :: (allocator: VmaAllocator, allocation: VmaAllocation, pFlags: *VkMemoryPropertyFlags) -> void #foreign vk_mem_alloc;
vmaMapMemory :: (allocator: VmaAllocator, allocation: VmaAllocation, ppData: **void) -> VkResult #foreign vk_mem_alloc;
vmaUnmapMemory :: (allocator: VmaAllocator, allocation: VmaAllocation) -> void #foreign vk_mem_alloc;
vmaFlushAllocation :: (allocator: VmaAllocator, allocation: VmaAllocation, offset: VkDeviceSize, size: VkDeviceSize) -> VkResult #foreign vk_mem_alloc;
vmaInvalidateAllocation :: (allocator: VmaAllocator, allocation: VmaAllocation, offset: VkDeviceSize, size: VkDeviceSize) -> VkResult #foreign vk_mem_alloc;
vmaFlushAllocations :: (allocator: VmaAllocator, allocationCount: u32, allocations: *VmaAllocation, offsets: *VkDeviceSize, sizes: *VkDeviceSize) -> VkResult #foreign vk_mem_alloc;
vmaInvalidateAllocations :: (allocator: VmaAllocator, allocationCount: u32, allocations: *VmaAllocation, offsets: *VkDeviceSize, sizes: *VkDeviceSize) -> VkResult #foreign vk_mem_alloc;
vmaCheckCorruption :: (allocator: VmaAllocator, memoryTypeBits: u32) -> VkResult #foreign vk_mem_alloc;
vmaBeginDefragmentation :: (allocator: VmaAllocator, pInfo: *VmaDefragmentationInfo, pContext: *VmaDefragmentationContext) -> VkResult #foreign vk_mem_alloc;
vmaEndDefragmentation :: (allocator: VmaAllocator, _context: VmaDefragmentationContext, pStats: *VmaDefragmentationStats) -> void #foreign vk_mem_alloc;
vmaBeginDefragmentationPass :: (allocator: VmaAllocator, _context: VmaDefragmentationContext, pPassInfo: *VmaDefragmentationPassMoveInfo) -> VkResult #foreign vk_mem_alloc;
vmaEndDefragmentationPass :: (allocator: VmaAllocator, _context: VmaDefragmentationContext, pPassInfo: *VmaDefragmentationPassMoveInfo) -> VkResult #foreign vk_mem_alloc;
vmaBindBufferMemory :: (allocator: VmaAllocator, allocation: VmaAllocation, buffer: VkBuffer) -> VkResult #foreign vk_mem_alloc;
vmaBindBufferMemory2 :: (allocator: VmaAllocator, allocation: VmaAllocation, allocationLocalOffset: VkDeviceSize, buffer: VkBuffer, pNext: *void) -> VkResult #foreign vk_mem_alloc;
vmaBindImageMemory :: (allocator: VmaAllocator, allocation: VmaAllocation, image: VkImage) -> VkResult #foreign vk_mem_alloc;
vmaBindImageMemory2 :: (allocator: VmaAllocator, allocation: VmaAllocation, allocationLocalOffset: VkDeviceSize, image: VkImage, pNext: *void) -> VkResult #foreign vk_mem_alloc;
vmaCreateBuffer :: (allocator: VmaAllocator, pBufferCreateInfo: *VkBufferCreateInfo, pAllocationCreateInfo: *VmaAllocationCreateInfo, pBuffer: *VkBuffer, pAllocation: *VmaAllocation, pAllocationInfo: *VmaAllocationInfo) -> VkResult #foreign vk_mem_alloc;
vmaCreateBufferWithAlignment :: (allocator: VmaAllocator, pBufferCreateInfo: *VkBufferCreateInfo, pAllocationCreateInfo: *VmaAllocationCreateInfo, minAlignment: VkDeviceSize, pBuffer: *VkBuffer, pAllocation: *VmaAllocation, pAllocationInfo: *VmaAllocationInfo) -> VkResult #foreign vk_mem_alloc;
vmaCreateAliasingBuffer :: (allocator: VmaAllocator, allocation: VmaAllocation, pBufferCreateInfo: *VkBufferCreateInfo, pBuffer: *VkBuffer) -> VkResult #foreign vk_mem_alloc;
vmaDestroyBuffer :: (allocator: VmaAllocator, buffer: VkBuffer, allocation: VmaAllocation) -> void #foreign vk_mem_alloc;
vmaCreateImage :: (allocator: VmaAllocator, pImageCreateInfo: *VkImageCreateInfo, pAllocationCreateInfo: *VmaAllocationCreateInfo, pImage: *VkImage, pAllocation: *VmaAllocation, pAllocationInfo: *VmaAllocationInfo) -> VkResult #foreign vk_mem_alloc;
vmaCreateAliasingImage :: (allocator: VmaAllocator, allocation: VmaAllocation, pImageCreateInfo: *VkImageCreateInfo, pImage: *VkImage) -> VkResult #foreign vk_mem_alloc;
vmaDestroyImage :: (allocator: VmaAllocator, image: VkImage, allocation: VmaAllocation) -> void #foreign vk_mem_alloc;
vmaCreateVirtualBlock :: (pCreateInfo: *VmaVirtualBlockCreateInfo, pVirtualBlock: *VmaVirtualBlock) -> VkResult #foreign vk_mem_alloc;
vmaDestroyVirtualBlock :: (virtualBlock: VmaVirtualBlock) -> void #foreign vk_mem_alloc;
vmaIsVirtualBlockEmpty :: (virtualBlock: VmaVirtualBlock) -> VkBool32 #foreign vk_mem_alloc;
vmaGetVirtualAllocationInfo :: (virtualBlock: VmaVirtualBlock, allocation: VmaVirtualAllocation, pVirtualAllocInfo: *VmaVirtualAllocationInfo) -> void #foreign vk_mem_alloc;
vmaVirtualAllocate :: (virtualBlock: VmaVirtualBlock, pCreateInfo: *VmaVirtualAllocationCreateInfo, pAllocation: *VmaVirtualAllocation, pOffset: *VkDeviceSize) -> VkResult #foreign vk_mem_alloc;
vmaVirtualFree :: (virtualBlock: VmaVirtualBlock, allocation: VmaVirtualAllocation) -> void #foreign vk_mem_alloc;
vmaClearVirtualBlock :: (virtualBlock: VmaVirtualBlock) -> void #foreign vk_mem_alloc;
vmaSetVirtualAllocationUserData :: (virtualBlock: VmaVirtualBlock, allocation: VmaVirtualAllocation, pUserData: *void) -> void #foreign vk_mem_alloc;
vmaGetVirtualBlockStatistics :: (virtualBlock: VmaVirtualBlock, pStats: *VmaStatistics) -> void #foreign vk_mem_alloc;
vmaCalculateVirtualBlockStatistics :: (virtualBlock: VmaVirtualBlock, pStats: *VmaDetailedStatistics) -> void #foreign vk_mem_alloc;
vmaBuildVirtualBlockStatsString :: (virtualBlock: VmaVirtualBlock, ppStatsString: **u8, detailedMap: VkBool32) -> void #foreign vk_mem_alloc;
vmaFreeVirtualBlockStatsString :: (virtualBlock: VmaVirtualBlock, pStatsString: *u8) -> void #foreign vk_mem_alloc;
vmaBuildStatsString :: (allocator: VmaAllocator, ppStatsString: **u8, detailedMap: VkBool32) -> void #foreign vk_mem_alloc;
vmaFreeStatsString :: (allocator: VmaAllocator, pStatsString: *u8) -> void #foreign vk_mem_alloc;

#scope_file

#if OS == .WINDOWS {
    vk_mem_alloc :: #library,no_dll "win/vk_mem_alloc";
} else #if OS == .LINUX {

    vk_mem_alloc :: #library,no_dll "linux/vk_mem_alloc";
}
