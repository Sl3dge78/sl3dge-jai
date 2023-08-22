Pipeline_Builder :: struct {
    stages : [..]VkPipelineShaderStageCreateInfo;
    
    vertex_bindings: [..]VkVertexInputBindingDescription;
    vertex_attributes: [..]VkVertexInputAttributeDescription;

    input_assembly := VkPipelineInputAssemblyStateCreateInfo.{
        topology = .TRIANGLE_LIST,
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
        polygonMode = .FILL,
        cullMode = .NONE,
        frontFace = .COUNTER_CLOCKWISE,
        depthBiasEnable = VK_FALSE,
        depthBiasConstantFactor = 0,
        depthBiasClamp = 0,
        depthBiasSlopeFactor = 0,
        lineWidth = 1,
    };

    multisample := VkPipelineMultisampleStateCreateInfo.{
        rasterizationSamples = ._1_BIT,
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
        depthCompareOp = .LESS,
        depthBoundsTestEnable = VK_FALSE,
        minDepthBounds = 0,
        maxDepthBounds = 1,
        stencilTestEnable = VK_FALSE,
    };

    descriptor_set_layouts: [..]VkDescriptorSetLayout;
    push_constant: VkPushConstantRange;

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
                    format = .R32_SFLOAT;
                }
                case .STRUCT; {
                    struct_type_info := cast(*Type_Info_Struct) it.type;

                    if struct_type_info.name == {
                        case "Vector4"; format = .R32G32B32A32_SFLOAT;
                        case "Vector3"; format = .R32G32B32_SFLOAT;
                        case "Vector2"; format = .R32G32_SFLOAT;
                        case; assert(false, "Unsupported struct type. Only Vector2, Vector3, Vector4 are supported");
                    }
                }
                case .ARRAY; {
                    array_type_info := cast(*Type_Info_Array) it.type;
                    if array_type_info.element_type.type == .INTEGER && array_type_info.element_type.runtime_size == 1 && array_type_info.array_count == 4 {
                        format = .R8G8B8A8_UINT;
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
        array_add(*self.vertex_bindings, .{xx self.vertex_bindings.count, size_of(type), .VERTEX});
        
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

    build :: (self: *Pipeline_Builder, device: VkDevice, render_pass: VkRenderPass) -> Pipeline #must {
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
            srcColorBlendFactor = .SRC_ALPHA,
            dstColorBlendFactor = .ONE_MINUS_SRC_ALPHA,
            colorBlendOp = .ADD,
            srcAlphaBlendFactor = .SRC_ALPHA,
            dstAlphaBlendFactor = .ONE_MINUS_SRC_ALPHA,
            alphaBlendOp = .ADD,
            colorWriteMask = .R_BIT | .G_BIT | .B_BIT | .A_BIT,
        } else .{            
            blendEnable = VK_FALSE,
            srcColorBlendFactor = .ONE,
            dstColorBlendFactor = .ZERO,
            colorBlendOp = .ADD,
            srcAlphaBlendFactor = .ONE,
            dstAlphaBlendFactor = .ZERO,
            alphaBlendOp = .ADD,
            colorWriteMask = .R_BIT | .G_BIT | .B_BIT | .A_BIT,
        };

        color_blend := VkPipelineColorBlendStateCreateInfo.{
            logicOpEnable = VK_FALSE,
            attachmentCount = 1,
            pAttachments = *color_blend_attachment
        };

        create_info := VkGraphicsPipelineCreateInfo.{
            stageCount = xx self.stages.count,
            pStages = self.stages.data,
            pVertexInputState = *vertex_input,
            pInputAssemblyState = *self.input_assembly,
            pViewportState = *self.viewport,
            pRasterizationState = *self.rasterization,
            pMultisampleState = *self.multisample,
            pColorBlendState = *color_blend,
            pDynamicState = *VkPipelineDynamicStateCreateInfo.{
                dynamicStateCount = xx self.dynamic_state.count,
                pDynamicStates = self.dynamic_state.data,
            },
            pDepthStencilState = *self.depth_stencil,
            layout = layout,
            renderPass = render_pass,
        };

        pipeline: VkPipeline = ---;
        Vk_Check(vkCreateGraphicsPipelines(device, VK_NULL_HANDLE, 1, *create_info, null, *pipeline));

        return .{ layout, pipeline };
    }
}