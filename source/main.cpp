#include <3ds.h>
#include <citro2d.h>
#include <string.h>
#include <stdio.h>

#define TOP_WIDTH  400
#define TOP_HEIGHT 240
#define BOT_WIDTH  320
#define BOT_HEIGHT 240

int main(int argc, char* argv[]) {
    gfxInitDefault();
    C3D_Init(C3D_DEFAULT_CMDBUF_SIZE);
    C2D_Init(C2D_DEFAULT_MAX_OBJECTS);
    C2D_Prepare();

    C3D_RenderTarget* topTarget = C2D_CreateScreenTarget(GFX_TOP, GFX_LEFT);
    C3D_RenderTarget* botTarget = C2D_CreateScreenTarget(GFX_BOTTOM, GFX_LEFT);

    u32 clrBackground  = C2D_Color32(0xF4, 0xF4, 0xF4, 0xFF);
    u32 clrGridLine    = C2D_Color32(0xE0, 0xE0, 0xE0, 0xFF);
    u32 clrBorder      = C2D_Color32(0x50, 0x50, 0x50, 0xFF);
    u32 clrButton      = C2D_Color32(0xDD, 0xEE, 0xFF, 0xFF);

    while (aptMainLoop()) {
        hidScanInput();
        u32 kDown = hidKeysDown();
        if (kDown & KEY_START)
            break;

        C3D_FrameBegin(C3D_FRAME_SYNCDRAW);
        
        // -----------------------------------------
        // TOP SCREEN
        // -----------------------------------------
        C2D_TargetClear(topTarget, clrBackground);
        C2D_SceneBegin(topTarget);
        for (int i = 0; i < TOP_WIDTH; i += 20) {
            C2D_DrawLine(i, 0, clrGridLine, i, TOP_HEIGHT, clrGridLine, 1.0f, 0.5f);
        }
        for (int i = 0; i < TOP_HEIGHT; i += 20) {
            C2D_DrawLine(0, i, clrGridLine, TOP_WIDTH, i, clrGridLine, 1.0f, 0.5f);
        }
        C2D_DrawRectSolid(0, 0, 0, TOP_WIDTH, 25, clrBorder);
        
        // -----------------------------------------
        // BOTTOM SCREEN
        // -----------------------------------------
        C2D_TargetClear(botTarget, clrBackground);
        C2D_SceneBegin(botTarget);
        
        // Draw main canvas border by layering a dark rect under a light rect
        C2D_DrawRectSolid(10, 10, 0, 300, 120, clrBorder);
        C2D_DrawRectSolid(12, 12, 0, 296, 116, clrBackground);

        // "Clear" Button
        C2D_DrawRectSolid(10, 140, 0, 70, 30, clrBorder);
        C2D_DrawRectSolid(11, 141, 0, 68, 28, clrButton);

        // "Send" Button
        C2D_DrawRectSolid(240, 140, 0, 70, 30, clrBorder);
        C2D_DrawRectSolid(241, 141, 0, 68, 28, clrButton);

        // Keyboard placeholder area
        C2D_DrawRectSolid(10, 185, 0, 300, 45, clrBorder);
        C2D_DrawRectSolid(11, 186, 0, 298, 43, C2D_Color32(0xE5, 0xE5, 0xE5, 0xFF));

        C3D_FrameEnd(0);
    }

    C2D_Fini();
    C3D_Fini();
    gfxExit();
    return 0;
}
