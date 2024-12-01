texture_from_file :: (path: string) -> Texture {
    channels: s32;
    w: s32;
    h: s32;
    img := stbi_load(temp_c_string(path), *w, *h, *channels, 4);
    assert(img != null, "Unable to load %.", path);
    defer stbi_image_free(img);
    return texture_from_data(img, xx w, xx h, 4, u8, path_filename(path));
}