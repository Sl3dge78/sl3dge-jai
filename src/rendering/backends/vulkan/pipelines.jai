Pipeline :: struct {
    layout: VkPipelineLayout;
    pipeline: VkPipeline;
}

// --------
// 2d/ui pipeline

create_ui_pipeline :: (device: VkDevice, render_pass: VkRenderPass) -> Pipeline {

    // Pipeline
    vtx := create_shader_module(device, "shaders/ui.vert.spv");
    defer vkDestroyShaderModule(device, vtx, null);

    frag := create_shader_module(device, "shaders/ui.frag.spv");
    defer vkDestroyShaderModule(device, frag, null);

    builder: Pipeline_Builder;
    Pipeline_Builder.add_descriptor_set_layouts(*builder, global_renderer.single_texture_layout);
    Pipeline_Builder.set_push_constants(*builder, .VERTEX_BIT, 4 * size_of(float));
    Pipeline_Builder.add_vertex_input(*builder, UI_Vertex);
    Pipeline_Builder.add_shader(*builder, .VERTEX_BIT, vtx, "main");
    Pipeline_Builder.add_shader(*builder, .FRAGMENT_BIT, frag, "main");
    Pipeline_Builder.add_dynamic_state(*builder, VkDynamicState.VIEWPORT, VkDynamicState.SCISSOR);
    builder.color_blend = true;
    pipeline := Pipeline_Builder.build(*builder, device, render_pass);
    log("UI Pipeline created.");

    return pipeline;
}

Material :: struct {
    shadowmap: Pipeline;
    color: Pipeline;
    #place shadowmap; pipelines: [2]Pipeline;

    destroy :: (device: VkDevice, material: *Material) {
        for material.pipelines {
            vkDestroyPipelineLayout(device, it.layout, null);
            vkDestroyPipeline(device, it.pipeline, null);
        }
    }
}

create_static_mesh_material :: (device : VkDevice, shadowmap_rp: VkRenderPass, color_rp: VkRenderPass) -> Material {
    result: Material;

    vtx := create_shader_module(device, "shaders/static.vert.spv");
    defer vkDestroyShaderModule(device, vtx, null);

    frag := create_shader_module(device, "shaders/color.frag.spv");
    defer vkDestroyShaderModule(device, frag, null);

    {   // Shadowmap   
        builder: Pipeline_Builder;
        Pipeline_Builder.add_descriptor_set_layouts(*builder, global_renderer.camera_set_layout);
        Pipeline_Builder.set_push_constants(*builder, .VERTEX_BIT, size_of(PushConstantData));
        Pipeline_Builder.add_vertex_input(*builder, Standard_Vertex);
        Pipeline_Builder.add_shader(*builder, .VERTEX_BIT, vtx, "main");
        Pipeline_Builder.rasterization_state_depth_bias(*builder, 1.25, 0, 1.75);
        Pipeline_Builder.viewport_state(*builder, Renderer.SHADOWMAP_SIZE, Renderer.SHADOWMAP_SIZE);
        result.pipelines[Pipeline_Kind.SHADOWMAP] = Pipeline_Builder.build(*builder, device, shadowmap_rp);
        log("Shadowmap pipeline created.");
    }

    {   // Color   
        builder: Pipeline_Builder;
        Pipeline_Builder.add_descriptor_set_layouts(*builder, 
            global_renderer.camera_set_layout,
            global_renderer.shadowmap_layout,
            global_renderer.single_texture_layout);
        Pipeline_Builder.set_push_constants(*builder, .VERTEX_BIT, size_of(PushConstantData));
        Pipeline_Builder.add_vertex_input(*builder, Standard_Vertex);
        Pipeline_Builder.add_shader(*builder, .VERTEX_BIT, vtx, "main");
        Pipeline_Builder.add_shader(*builder, .FRAGMENT_BIT, frag, "main");
        Pipeline_Builder.add_dynamic_state(*builder, VkDynamicState.VIEWPORT, VkDynamicState.SCISSOR);
        result.pipelines[Pipeline_Kind.COLOR] = Pipeline_Builder.build(*builder, device, color_rp);
        log("Color pipeline created.");
    }
    return result;
}

create_skinned_mesh_material :: (device : VkDevice, shadowmap_rp: VkRenderPass, color_rp: VkRenderPass) -> Material {
    result: Material;

    vtx := create_shader_module(device, "shaders/skinned.vert.spv");
    defer vkDestroyShaderModule(device, vtx, null);

    frag := create_shader_module(device, "shaders/color.frag.spv");
    defer vkDestroyShaderModule(device, frag, null);

    {   // Shadowmap   
        builder: Pipeline_Builder;
        Pipeline_Builder.add_descriptor_set_layouts(*builder, 
            global_renderer.camera_set_layout,
            global_renderer.empty_set_layout,
            global_renderer.empty_set_layout,
            global_renderer.skinned_mesh_layout);
        Pipeline_Builder.set_push_constants(*builder, .VERTEX_BIT, size_of(PushConstantData));
        Pipeline_Builder.add_vertex_input(*builder, Standard_Vertex);
        Pipeline_Builder.add_vertex_input(*builder, Skinned_Vertex);
        Pipeline_Builder.add_shader(*builder, .VERTEX_BIT, vtx, "main");
        Pipeline_Builder.rasterization_state_depth_bias(*builder, 1.25, 0, 1.75);
        Pipeline_Builder.viewport_state(*builder, Renderer.SHADOWMAP_SIZE, Renderer.SHADOWMAP_SIZE);
        result.pipelines[Pipeline_Kind.SHADOWMAP] = Pipeline_Builder.build(*builder, device, shadowmap_rp);
        
        log("Shadowmap pipeline created.");
    }

    {   // Color   
        builder: Pipeline_Builder;
        Pipeline_Builder.add_descriptor_set_layouts(*builder, 
            global_renderer.camera_set_layout,
            global_renderer.shadowmap_layout,
            global_renderer.single_texture_layout,
            global_renderer.skinned_mesh_layout);
        Pipeline_Builder.set_push_constants(*builder, .VERTEX_BIT, size_of(PushConstantData));
        Pipeline_Builder.add_vertex_input(*builder, Standard_Vertex);
        Pipeline_Builder.add_vertex_input(*builder, Skinned_Vertex);
        Pipeline_Builder.add_shader(*builder, .VERTEX_BIT, vtx, "main");
        Pipeline_Builder.add_shader(*builder, .FRAGMENT_BIT, frag, "main");
        Pipeline_Builder.add_dynamic_state(*builder, VkDynamicState.VIEWPORT, VkDynamicState.SCISSOR);
        result.pipelines[Pipeline_Kind.COLOR] = Pipeline_Builder.build(*builder, device, color_rp);
        
        log("Color pipeline created.");
    }
    return result;
}

Pipeline_Kind :: enum {
    SHADOWMAP :: 0;
    COLOR :: 1;
}

bind_material :: (command_buffer: VkCommandBuffer, material: Material, $kind: Pipeline_Kind) {
    #if kind == .SHADOWMAP {
        pipeline := material.shadowmap;
        vkCmdBindPipeline(command_buffer, .GRAPHICS, pipeline.pipeline);
        vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, pipeline.layout, Renderer.FRAME_CAMERADATA_SET, 1, *context.vk.shadowmap_camera_descriptor, 0, null);
    } else #if kind == .COLOR {
        pipeline := material.color;
        vkCmdBindPipeline(command_buffer, .GRAPHICS, pipeline.pipeline);
        vkCmdSetViewport(command_buffer, 0, 1, *VkViewport.{0, xx global_renderer.swapchain.extent.height, xx global_renderer.swapchain.extent.width, -(cast(float)global_renderer.swapchain.extent.height), 0, 1});
        vkCmdSetScissor(command_buffer, 0, 1, *VkRect2D.{.{0, 0}, global_renderer.swapchain.extent});
        vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, pipeline.layout, Renderer.FRAME_CAMERADATA_SET, 1, *context.vk.camera_descriptor, 0, null);
        vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, pipeline.layout, Renderer.FRAME_SHADOWMAP_SET, 1, *global_renderer.shadowmap_descriptor_set, 0, null);
        vkCmdBindDescriptorSets(command_buffer, .GRAPHICS, pipeline.layout, Renderer.MATERIAL_SET, 1, *global_renderer.default_texture_descriptor, 0, null);
    } else {
        #assert false;
    }
}