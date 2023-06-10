UI_Pass :: struct {
    descriptor_set_layouts: [2]VkDescriptorSetLayout;
    pipeline_layout: VkPipelineLayout;
    pipeline: VkPipeline;

    descriptor_sets: [Renderer.FRAME_COUNT][2] VkDescriptorSet;

    uniform_data: [Renderer.FRAME_COUNT] Buffer;

    using draw_data: Draw_Data;
}

create_ui_pass :: () -> UI_Pass {
    pass : UI_Pass;

    // Pipeline
    {
        vtx := create_shader_module(device, "shaders/ui.vert.spv");
        defer vkDestroyShaderModule(device, vtx, null);

        frag := create_shader_module(device, "shaders/ui.frag.spv");
        defer vkDestroyShaderModule(device, frag, null);

        bindings : [1]VkDescriptorSetLayoutBinding;
        bindings[0] = .{
            binding = 0,
            descriptorType = .UNIFORM_BUFFER,
            descriptorCount = 1,
            stageFlags = .VERTEX_BIT,
            pImmutableSamplers = null,
        };
        layout_info := VkDescriptorSetLayoutCreateInfo.{
            bindingCount = bindings.count,
            pBindings = bindings.data,
        };        
        
        Vk_Check(vkCreateDescriptorSetLayout(device, *layout_info, null, *pass.descriptor_set_layouts[0]));

        bindings[0] = .{
            binding = 0,
            descriptorType = .COMBINED_IMAGE_SAMPLER,
            descriptorCount = 1,
            stageFlags = .FRAGMENT_BIT,
            pImmutableSamplers = null,
        };
        Vk_Check(vkCreateDescriptorSetLayout(device, *layout_info, null, *pass.descriptor_set_layouts[1]));

        for *pass.uniform_data {
            it.* = create_buffer(size_of(CameraData), .UNIFORM_BUFFER_BIT, .UPLOAD, map = true);
        }

        layout_ci := VkPipelineLayoutCreateInfo.{ 
            setLayoutCount = color_pass.descriptor_set_layouts.count,
            pSetLayouts = color_pass.descriptor_set_layouts.data,
        };
        Vk_Check(vkCreatePipelineLayout(device, *layout_ci, null, *pass.pipeline_layout));

        create_info := pipeline_create_info(vtx, frag, color_pass.pipeline_layout);
        vkCreateGraphicsPipelines(device, null, 1, *create_info, null, *pass.pipeline);
        log("Pipeline created.");
    }

    // DescriptorSet
    {
        // @TODO: Move that in a Material struct
        alloc_info := VkDescriptorSetAllocateInfo.{
            descriptorPool = global_renderer.descriptor_pool,
            descriptorSetCount = pass.descriptor_set_layouts.count,
            pSetLayouts = pass.descriptor_set_layouts.data,
        };

        for *pass.descriptor_sets {
            Vk_Check(vkAllocateDescriptorSets(device, *alloc_info, it.data));
        }
    }

    return pass;
}

destroy_ui_pass :: (using pass: *UI_Pass, device: VkDevice) {
    for descriptor_set_layouts {
        vkDestroyDescriptorSetLayout(device, it, null);
    }
    vkDestroyPipelineLayout(device, pipeline_layout, null);
    vkDestroyPipeline(device, pipeline, null);
    for *uniform_data {
        destroy_buffer(it);
    }
    destroy_buffer(*vertex_buffer);
}

begin_2d :: () {
    // @ todo
}
