Sub_Mesh :: struct {
    vertices : Buffer_Location;
    vertex_count: u64;
    indices : Buffer_Location;
    index_count : u32;
}

Mesh :: struct {
    submeshes : [..] Sub_Mesh;
}

PBR_Material :: struct {
    using buffer: PBR_Material_Buffer;
    albedo_texture: *SDL_GPUTexture;
    normal_texture: *SDL_GPUTexture;
    metallic_roughness_texture: *SDL_GPUTexture;
    ao_texture: *SDL_GPUTexture;
    emission_texture: *SDL_GPUTexture;
}

default_material :: () -> PBR_Material {
    return .{
        albedo = .{1, 1, 1},
        metallic = 0,
        roughness = 0,
        albedo_texture = global_renderer.white_texture,
        normal_texture = global_renderer.empty_normal,
        metallic_roughness_texture = global_renderer.white_texture,
        ao_texture = global_renderer.white_texture,
        emission_texture = global_renderer.black_texture
    };
}

Renderable_Mesh :: struct {
    mesh: Mesh;
    material: PBR_Material;
}

destroy :: (renderable: *Renderable_Mesh) {
    destroy(*renderable.mesh);
    destroy(*renderable.material);
}

destroy :: (renderable: *[]Renderable_Mesh) {
    for renderable.* { 
        destroy(*it.mesh);
        destroy(*it.material);
    }
    free(renderable);
}

destroy :: (using mesh : *Mesh) {
    array_reset(*submeshes);
}

bind :: (mat: PBR_Material, cmd: *SDL_GPUCommandBuffer, render_pass: *SDL_GPURenderPass) {
    SDL_PushGPUFragmentUniformData(cmd, 1, *mat.buffer, size_of(type_of(mat.buffer)));
    bindings : [5]SDL_GPUTextureSamplerBinding;
    bindings[0] = .{ mat.albedo_texture, global_renderer.sampler};
    bindings[1] = .{ mat.normal_texture, global_renderer.sampler};
    bindings[2] = .{ mat.metallic_roughness_texture, global_renderer.sampler};
    bindings[3] = .{ mat.ao_texture, global_renderer.sampler};
    bindings[4] = .{ mat.emission_texture, global_renderer.sampler};
    SDL_BindGPUFragmentSamplers(render_pass, xx Texture_Binding.DIFFUSE, bindings.data, bindings.count);
}

destroy :: (mat: *PBR_Material) {
    if mat.albedo_texture {
        destroy(mat.albedo_texture);
    }
    if mat.normal_texture {
        destroy(mat.normal_texture);
    }
    if mat.metallic_roughness_texture {
        destroy(mat.metallic_roughness_texture);
    }
    if mat.ao_texture {
        destroy(mat.ao_texture);
    }
}

draw :: inline(using self: Mesh, render_pass: *SDL_GPURenderPass, instances : u32 = 1) {
    for submeshes {
        SDL_BindGPUIndexBuffer(render_pass, *it.indices, ._32BIT);
        SDL_BindGPUVertexBuffers(render_pass, 0, *it.vertices, 1);
        SDL_DrawGPUIndexedPrimitives(render_pass, it.index_count, instances, 0, 0, 0);
    }
}

load_mesh_from_vertices :: (vertices: []Standard_Vertex, indices: []u32) -> Mesh {
    result: Mesh;
    array_add(*result.submeshes, buffer_pool_load_mesh(*global_renderer.vertex_buffer_pool, vertices, indices));
    return result;
}

// Loads the first mesh
load_from_file :: (path: string, mesh: *Mesh) -> success: bool {
    log("[MESH] Loading %.", path);
    gltf_data := gltf_parse_file(path);
    defer gltf_free(*gltf_data);

    gltf_load_buffers(*gltf_data);

    for gltf_data.meshes { 
        s := load_primitive(it.primitives[0], gltf_data, mesh);
        assert(s, "Unable to load primitive 0 in %", path);
        if !s then return false;
    }
    return true;
}

load_from_file :: (path: string, meshes: *[]Renderable_Mesh) -> bool {
    log("[MESH] Loading %.", path);
    gltf_data := gltf_parse_file(path);
    defer gltf_free(*gltf_data);
    gltf_load_buffers(*gltf_data);

    current_dir := get_working_directory();
    defer set_working_directory(current_dir);

    dir := path_strip_filename(path);
    set_working_directory(dir);

    total_nb := 0;
    for gltf_data.meshes { 
        total_nb += it.primitives.count;
    }
    meshes.* = NewArray(total_nb, Renderable_Mesh);

    id := 0;
    for gltf_data.meshes { 
        for it.primitives {
            defer id += 1;
            success := load_primitive(it, gltf_data, *(meshes.*[id].mesh), *(meshes.*[id]).material);
            assert(success);
            if !success return false;
        }
    }

    return true;
}

load_texture_from_gltf_data :: (gltf_data: GLTF_Data, info: GLTF_Texture_Info, result: **SDL_GPUTexture, $$format : SDL_GPUTextureFormat = .INVALID) -> bool {
    texture_info := gltf_data.textures[info.index];
    image_info := gltf_data.images[texture_info.source];
    if image_info.uri != "" { 
        result.* = texture_from_file(image_info.uri, format);
    } else { 
        result.* = texture_from_memory(image_info.data.data, xx image_info.data.count, format = format);
    }
    return true;
}

load_primitive :: (using primitive: GLTF_Primitive, gltf_data: GLTF_Data, dst_mesh: *Mesh, $$dst_material: *PBR_Material = null) -> success : bool {
    assert(position_accessor != -1, "No positions for vertices!");

    // Mesh data
    {   // Indices
        idx_accessor := gltf_data.accessors[indices_accessor];
        indices := NewArray(idx_accessor.count, u32,, allocator = temp);
        read_accessor_into_array(indices.data, 0, size_of(u32), size_of(u32), gltf_data, indices_accessor);

        // Vertices
        offset: *Standard_Vertex = null;
        accessor := gltf_data.accessors[position_accessor];
        assert(accessor.component_type == .FLOAT);

        vertices := NewArray(accessor.count, Standard_Vertex,, allocator = temp);
        read_accessor_into_array(vertices.data, xx *offset.position, size_of(Standard_Vertex), size_of(type_of(offset.position)), gltf_data, position_accessor);
        
        // Normals
        if normal_accessor != -1 {
            read_accessor_into_array(vertices.data, xx *offset.normal, size_of(Standard_Vertex), size_of(type_of(offset.normal)), gltf_data, normal_accessor);
        }

        if texcoord_0_accessor != -1 {
            read_accessor_into_array(vertices.data, xx *offset.uv, size_of(Standard_Vertex), size_of(type_of(offset.uv)), gltf_data, texcoord_0_accessor);
        }

        if tangent_accessor != -1 {
            read_accessor_into_array(vertices.data, xx *offset.tangent, size_of(Standard_Vertex), size_of(type_of(offset.tangent)), gltf_data, tangent_accessor);
        } else { 
            log("[MESH] Calculating tangents");
            calculate_tangents(vertices, indices);
        }
        dst_mesh.* = load_mesh_from_vertices(vertices, indices);
    }

    // Material data
    #if !is_constant(dst_material) {
        s := load_pbr_material(gltf_data.materials[primitive.material], gltf_data, dst_material);
        assert(s != false, "Unable to load material");
        if !s {
            return false;
        }
    }
    return true;
}

load_pbr_material :: (using material: GLTF_Material, gltf_data: GLTF_Data, result: *PBR_Material) -> success : bool { 
    {   // Mettalic Roughness
        result.* = default_material();
        mr := material.metallic_roughness;
        result.albedo = .{ mr.base_color_factor[0], mr.base_color_factor[1], mr.base_color_factor[2] };
        if mr.has_base_color {
            success := load_texture_from_gltf_data(gltf_data, mr.base_color_texture, *result.albedo_texture);
            if !success {
                log_error("Unable to load base color texture");
                return false;
            }
        } else { 
            result.albedo_texture = global_renderer.white_texture;
        }

        result.metallic = mr.metallic_factor;
        result.roughness = mr.roughness_factor;
        if mr.has_metallic_roughness {
            success := load_texture_from_gltf_data(gltf_data, mr.metallic_roughness_texture, *result.metallic_roughness_texture);
            if !success {
                log_error("Unable to load metallic_roughness_texture");
                return false;
            }
        } 
    }

    {   // Other
        if material.has_normal {
            success := load_texture_from_gltf_data(gltf_data, material.normal_texture, *result.normal_texture, .R8G8B8A8_UNORM);
            if !success {
                log_error("Unable to load normal_texture");
                return false;
            }
        }

        if material.has_occlusion {
            success := load_texture_from_gltf_data(gltf_data, material.occlusion_texture, *result.ao_texture);
            if !success {
                log_error("Unable to load occlusion_texture");
                return false;
            }
        } 

        if material.has_emissive {
            success := load_texture_from_gltf_data(gltf_data, material.emissive_texture, *result.emission_texture);
            if !success {
                log_error("Unable to load emissive_texture");
                return false;
            }
        } 
    }

    return true;
}

read_accessor_into_array :: (dst: *void, dst_offset: u64, dst_stride: u64, dst_size: s64, gltf_data: GLTF_Data, accessor_id: int) {
    accessor := gltf_data.accessors[accessor_id];
    buffer_view := gltf_data.buffer_views[accessor.buffer_view];
    buffer      := gltf_data.buffers[buffer_view.buffer];
    component_info := get_component_info(accessor);
    offset := buffer_view.byte_offset + accessor.byte_offset;
        
    dst_data := dst + dst_offset;
    for data_index: 0..accessor.count - 1 {
        data := (buffer.data.data + offset + data_index * accessor.stride);
        memcpy(dst_data, data, min(dst_size, component_info.stride));
        dst_data += dst_stride;
    }
}

Mesh_Builder :: struct {
    vertices: [..]Standard_Vertex;
    indices: [..]u32;
}

mesh_builder_push_quad :: (using builder: *Mesh_Builder, p0: Vector3, p1: Vector3, p2: Vector3, p3: Vector3, normal: Vector3, color: Vector4 = .{1, 1, 1, 1}) {
    vertices.allocator = temp;
    indices.allocator = temp;
    i : u32 = xx vertices.count;
    array_add(*vertices, .{p0, normal, .{0, 0}, .{}});
    array_add(*vertices, .{p1, normal, .{1, 0}, .{}});
    array_add(*vertices, .{p2, normal, .{1, 1}, .{}});
    array_add(*vertices, .{p3, normal, .{0, 1}, .{}});

    array_add(*indices, ..u32.[i, i+1, i+2, i, i+2, i+3]);
}

mesh_builder_push_triangle :: (using builder: *Mesh_Builder, p0: Vector3, p1: Vector3, p2: Vector3, normal: Vector3, color:= Vector4.{1, 1, 1, 1}) {
    vertices.allocator = temp;
    indices.allocator = temp;
    i : u32 = xx vertices.count;
    array_add(*vertices, .{p0, normal, .{0, 0}, .{}});
    array_add(*vertices, .{p1, normal, .{1, 0}, .{}});
    array_add(*vertices, .{p2, normal, .{1, 1}, .{}});

    array_add(*indices, ..u32.[i, i+1, i+2]);
}

mesh_builder_load_mesh :: (using builder: *Mesh_Builder) -> Mesh {
    assert(vertices.count != 0);
    assert(indices.count != 0);

    calculate_tangents(vertices, indices);

    return load_mesh_from_vertices(vertices, indices);
}

calculate_tangents :: (vertices: []Standard_Vertex, indices: []u32) {
    remove_integer_part :: (v: Vector2) -> Vector2 {
        return .{
            ifx v.x > 1 then v.x - cast(int)v.x else v.x,
            ifx v.y > 1 then v.y - cast(int)v.y else v.y,
        };
    }

    for 0..(indices.count / 3) - 1 {
        v0 := vertices[indices[it * 3 + 0]];
        v1 := vertices[indices[it * 3 + 1]];
        v2 := vertices[indices[it * 3 + 2]];

        e0 := v1.position - v0.position;
        e1 := v2.position - v0.position;


        duv1 := remove_integer_part(v1.uv) - remove_integer_part(v0.uv);
        duv2 := remove_integer_part(v2.uv) - remove_integer_part(v0.uv);

        f := 1 / (duv1.x * duv2.y - duv2.x * duv1.y);
        tangent := Vector3.{
            f * (duv2.y * e0.x - duv1.y * e1.x),
            f * (duv2.y * e0.y - duv1.y * e1.y),
            f * (duv2.y * e0.z - duv1.y * e1.z),
        };
        // assert(!isnan(tangent.x) && !isnan(tangent.y) && !isnan(tangent.z));
        vertices[indices[it * 3 + 0]].tangent = unit_vector(tangent);
        vertices[indices[it * 3 + 1]].tangent = unit_vector(tangent);
        vertices[indices[it * 3 + 2]].tangent = unit_vector(tangent);
    }
}
