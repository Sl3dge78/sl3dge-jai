Pipeline_Builder :: struct {
    stages : [..]VkPipelineShaderStageCreateInfo;
    
    vertex_bindings: [..]VkVertexInputBindingDescription;
    vertex_attributes: [..]VkVertexInputAttributeDescription;

    input_assembly := VkPipelineInputAssemblyStateCreateInfo.{
        topology = VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST,
        primitiveRestartEnable = VK_FALSE,
    };

    viewport := VkPipelineViewportStateCreateInfo.{
        viewportCount = 1,
        pViewports = VK_NULL_HANDLE,
        scissorCount = 1,
        pScissors = VK_NULL_HANDLE,
    };

    rasterization := VkPipelineRasterizationStateCreateInfo.{
        depthClampEnable = VK_FALSE,
        rasterizerDiscardEnable = VK_FALSE,
        polygonMode = VK_POLYGON_MODE_FILL,
        cullMode = VK_CULL_MODE_NONE,
        frontFace = VK_FRONT_FACE_COUNTER_CLOCKWISE,
        depthBiasEnable = VK_FALSE,
        depthBiasConstantFactor = 0,
        depthBiasClamp = 0,
        depthBiasSlopeFactor = 0,
        lineWidth = 1,
    };

    multisample := VkPipelineMultisampleStateCreateInfo.{
        rasterizationSamples = VK_SAMPLE_COUNT_1_BIT,
        sampleShadingEnable = VK_FALSE,
        minSampleShading = 1,
        pSampleMask = VK_NULL_HANDLE,
        alphaToCoverageEnable = VK_FALSE,
        alphaToOneEnable = VK_FALSE,
    };

    color_blend : bool; 

    dynamic_state : [..]VkDynamicState;
    depth_stencil := VkPipelineDepthStencilStateCreateInfo.{
        depthTestEnable = VK_TRUE,
        depthWriteEnable = VK_TRUE,
        depthCompareOp = VK_COMPARE_OP_LESS,
        depthBoundsTestEnable = VK_FALSE,
        minDepthBounds = 0,
        maxDepthBounds = 1,
        stencilTestEnable = VK_FALSE,
    };

    descriptor_set_layouts: [..]VkDescriptorSetLayout;
    push_constant: VkPushConstantRange;

    color_attachment_formats: [..]VkFormat;
    depth_attachment_format: VkFormat = 0;
    stencil_attachment_format: VkFormat = 0;

    add_shader :: (self: *Pipeline_Builder, stage: VkShaderStageFlagBits, module: VkShaderModule, entry_point: string) {
        self.stages.allocator = temp;
        array_add(*self.stages, .{stage = stage, module = module, pName = temp_c_string(entry_point)});
    }

    add_vertex_input :: (self: *Pipeline_Builder, $type: Type) {
        self.vertex_attributes.allocator = temp;
    
        info := type_info(type);
        
        for info.members {
            format: VkFormat;

            if it.type.type == {
                case .FLOAT; {
                    assert(it.type.runtime_size <= 4, "Only float32 is supported in Vertex Attribute Data.");
                    format = VK_FORMAT_R32_SFLOAT;
                }
                case .STRUCT; {
                    struct_type_info := cast(*Type_Info_Struct) it.type;

                    if struct_type_info.name == {
                        case "Vector4"; format = VK_FORMAT_R32G32B32A32_SFLOAT;
                        case "Vector3"; format = VK_FORMAT_R32G32B32_SFLOAT;
                        case "Vector2"; format = VK_FORMAT_R32G32_SFLOAT;
                        case; assert(false, "Unsupported struct type. Only Vector2, Vector3, Vector4 are supported");
                    }
                }
                case .ARRAY; {
                    array_type_info := cast(*Type_Info_Array) it.type;
                    if array_type_info.element_type.type == .INTEGER && array_type_info.element_type.runtime_size == 1 && array_type_info.array_count == 4 {
                        format = VK_FORMAT_R8G8B8A8_UINT;
                    } else {
                        assert(false, "Unhandled array type: % in vertex input.", array_type_info.element_type);
                    }
                }
                case; {
                    assert(false, "Unhandled type % in vertex input", it.type.type);
                }
            }
            array_add(*self.vertex_attributes, .{location = xx self.vertex_attributes.count, binding = xx self.vertex_bindings.count, format = format, offset = xx it.offset_in_bytes });
        }
        self.vertex_bindings.allocator = temp;
        array_add(*self.vertex_bindings, .{xx self.vertex_bindings.count, size_of(type), VK_VERTEX_INPUT_RATE_VERTEX});
        
    }

    rasterization_state_depth_bias :: (self: *Pipeline_Builder, constant_factor: float, clamp: float, slope_factor: float) {
        self.rasterization.depthBiasEnable = VK_TRUE;
        self.rasterization.depthBiasConstantFactor = constant_factor;
        self.rasterization.depthBiasClamp = clamp;
        self.rasterization.depthBiasSlopeFactor = slope_factor;
    }

    viewport_state :: (self: *Pipeline_Builder, w: u32, h: u32) {
        using self.viewport;
        pViewports = New(VkViewport, false, allocator = temp);
        pScissors = New(VkRect2D, false, allocator = temp);
        pViewports.* = .{0, 0, xx w,  cast(float)h, 0, 1};
        pScissors.* = .{offset = .{0, 0}, extent = .{w, h}};
        viewportCount = 1;
        scissorCount = 1;
    }

    add_dynamic_state :: (self: *Pipeline_Builder, dyn: ..VkDynamicState) {
        self.dynamic_state.allocator = temp;
        array_add(*self.dynamic_state, ..dyn);
    }

    add_descriptor_set_layouts :: (self: *Pipeline_Builder, dsl: ..VkDescriptorSetLayout) {
        self.descriptor_set_layouts.allocator = temp;
        array_add(*self.descriptor_set_layouts, ..dsl);
    }

    set_push_constants :: (self: *Pipeline_Builder, stage: VkShaderStageFlagBits, size: int, offset := 0) {
        self.push_constant = .{
            stageFlags = stage,
            offset = xx offset,
            size = xx size
        };
    }

    color_format :: (self: *Pipeline_Builder, formats: ..VkFormat) {
        array_add(*self.color_attachment_formats, ..formats);
    }

    depth_format :: (self: *Pipeline_Builder, format: VkFormat) {
        self.depth_attachment_format = format;
    }

    build :: (self: *Pipeline_Builder, device: VkDevice) -> Pipeline #must {
        layout_ci := VkPipelineLayoutCreateInfo.{
            pushConstantRangeCount = 1,
            pPushConstantRanges = *self.push_constant,
            setLayoutCount = xx self.descriptor_set_layouts.count,
            pSetLayouts = self.descriptor_set_layouts.data
        };

        layout: VkPipelineLayout = ---;
        Vk_Check(vkCreatePipelineLayout(device, *layout_ci, null, *layout));

        vertex_input : VkPipelineVertexInputStateCreateInfo = .{
            vertexBindingDescriptionCount = xx self.vertex_bindings.count,
            pVertexBindingDescriptions = self.vertex_bindings.data,
            vertexAttributeDescriptionCount = xx self.vertex_attributes.count,
            pVertexAttributeDescriptions = self.vertex_attributes.data
        };
        
        color_blend_attachment :=
        ifx self.color_blend then VkPipelineColorBlendAttachmentState.{
            blendEnable = VK_TRUE,
            srcColorBlendFactor = VK_BLEND_FACTOR_SRC_ALPHA,
            dstColorBlendFactor = VK_BLEND_FACTOR_ONE_MINUS_SRC_ALPHA,
            colorBlendOp = VK_BLEND_OP_ADD,
            srcAlphaBlendFactor = VK_BLEND_FACTOR_SRC_ALPHA,
            dstAlphaBlendFactor = VK_BLEND_FACTOR_ONE_MINUS_SRC_ALPHA,
            alphaBlendOp = VK_BLEND_OP_ADD,
            colorWriteMask = VK_COLOR_COMPONENT_R_BIT | VK_COLOR_COMPONENT_G_BIT | VK_COLOR_COMPONENT_B_BIT | VK_COLOR_COMPONENT_A_BIT,
        } else .{            
            blendEnable = VK_FALSE,
            srcColorBlendFactor = VK_BLEND_FACTOR_ONE,
            dstColorBlendFactor = VK_BLEND_FACTOR_ZERO,
            colorBlendOp = VK_BLEND_OP_ADD,
            srcAlphaBlendFactor = VK_BLEND_FACTOR_ONE,
            dstAlphaBlendFactor = VK_BLEND_FACTOR_ZERO,
            alphaBlendOp = VK_BLEND_OP_ADD,
            colorWriteMask = VK_COLOR_COMPONENT_R_BIT | VK_COLOR_COMPONENT_G_BIT | VK_COLOR_COMPONENT_B_BIT | VK_COLOR_COMPONENT_A_BIT,
        };

        color_blend := VkPipelineColorBlendStateCreateInfo.{
            logicOpEnable = VK_FALSE,
            attachmentCount = 1,
            pAttachments = *color_blend_attachment
        };

        pipeline_rendering := VkPipelineRenderingCreateInfo.{
            viewMask = 0, // @TODO: Figure out what this is?
            colorAttachmentCount    = xx self.color_attachment_formats.count,
            pColorAttachmentFormats = self.color_attachment_formats.data,
            depthAttachmentFormat   = self.depth_attachment_format,
            stencilAttachmentFormat = self.stencil_attachment_format,
        };

        dynamic_state := VkPipelineDynamicStateCreateInfo.{
            dynamicStateCount = xx self.dynamic_state.count,
            pDynamicStates = self.dynamic_state.data,
        };
        create_info := VkGraphicsPipelineCreateInfo.{
            pNext = *pipeline_rendering,
            stageCount = xx self.stages.count,
            pStages = self.stages.data,
            pVertexInputState = *vertex_input,
            pInputAssemblyState = *self.input_assembly,
            pViewportState = *self.viewport,
            pRasterizationState = *self.rasterization,
            pMultisampleState = *self.multisample,
            pColorBlendState = *color_blend,
            pDynamicState = *dynamic_state,
            pDepthStencilState = *self.depth_stencil,
            layout = layout,
            renderPass = null,
        };

        pipeline: VkPipeline = ---;
        Vk_Check(vkCreateGraphicsPipelines(device, VK_NULL_HANDLE, 1, *create_info, null, *pipeline));

        return .{ layout, pipeline };
    }
}