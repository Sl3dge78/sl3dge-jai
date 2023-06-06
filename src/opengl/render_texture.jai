Render_Texture :: struct {
    Kind :: enum {
        RENDER_TEXTURE;
        MSAA;
    }

    kind : Kind = .RENDER_TEXTURE;
    framebuffer: GLuint;
    texture: Texture;
    width: int;
    height: int;

    init :: (w: int, h: int) -> Render_Texture {
        self: Render_Texture = ---;
        
        self.width = w;
        self.height = h;

        glGenFramebuffers(1, *self.framebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, self.framebuffer);

        self.texture = Texture.init();
        Texture.bind(self.texture);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, xx w, xx h, 0, GL_RGB, GL_UNSIGNED_BYTE, null);
        Texture.set_filter(.LINEAR);
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, self.texture.handle, 0);
        result := glCheckFramebufferStatus(GL_FRAMEBUFFER);
        if result != GL_FRAMEBUFFER_COMPLETE {
            log_error("framebuffer isn't complete: %", result);
        }

        glBindFramebuffer(GL_FRAMEBUFFER, 0);

        return self;
    }

    init_depth :: (w: int, h: int) -> Render_Texture {
        self: Render_Texture = ---;
        self.width = w;
        self.height = h;

        glGenFramebuffers(1, *self.framebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, self.framebuffer);

        self.texture = Texture.init();
        Texture.bind(self.texture);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT, xx w, xx h, 0, GL_DEPTH_COMPONENT, GL_FLOAT, null);
        Texture.set_filter(.NEAREST);
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, self.texture.handle, 0);
        glDrawBuffer(GL_NONE);
        glReadBuffer(GL_NONE);
        result := glCheckFramebufferStatus(GL_FRAMEBUFFER);
        if result != GL_FRAMEBUFFER_COMPLETE {
            log_error("framebuffer isn't complete: %", result);
        }

        glBindFramebuffer(GL_FRAMEBUFFER, 0);
        return self;
    }

    deinit :: (self: *Render_Texture) {
        glDeleteFramebuffers(1, *self.framebuffer);
        Texture.deinit(*self.texture);
    }

    maybe_resolve :: (self: *Render_Texture) {
        if self.kind == .MSAA {
            MSAA_Render_Texture.resolve(xx self);
        }
    }
}

MSAA_Render_Texture :: struct {
    using #as render_texture: Render_Texture;
    kind = .MSAA;

    msaa_framebuffer: GLuint;
    msaa_texture: Texture;

    init_msaa :: (w: int, h: int) -> MSAA_Render_Texture {
        self: MSAA_Render_Texture = ---;
        self.render_texture = Render_Texture.init(w, h);
        // MSAA framebuffer
        glGenFramebuffers(1, *self.msaa_framebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, self.msaa_framebuffer);

        glCreateTextures(GL_TEXTURE_2D_MULTISAMPLE, 1, *self.msaa_texture.handle);
        glBindTexture(GL_TEXTURE_2D_MULTISAMPLE, self.msaa_texture.handle);
        glTexImage2DMultisample(GL_TEXTURE_2D_MULTISAMPLE, 8, GL_RGB, xx w, xx h, GL_TRUE);
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D_MULTISAMPLE, self.msaa_texture.handle, 0);
        return self;
    }

    deinit :: (self: *MSAA_Render_Texture) {
        Render_Texture.deinit(self);

        glDeleteFramebuffers(1, *self.msaa_framebuffer);
        Texture.deinit(*self.msaa_texture);
    }

    resolve :: (self: *MSAA_Render_Texture) {
        glBindFramebuffer(GL_READ_FRAMEBUFFER, self.msaa_framebuffer);
        glBindFramebuffer(GL_DRAW_FRAMEBUFFER, self.framebuffer);
        glBlitFramebuffer(0, 0, xx self.width, xx self.height, 0, 0, xx self.width, xx self.height, GL_COLOR_BUFFER_BIT, GL_LINEAR);
        glBindFramebuffer(GL_FRAMEBUFFER, 0);
    }
}
