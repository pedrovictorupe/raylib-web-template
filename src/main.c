/*******************************************************************************************
*
*   Game Name
*
*   Copyright (c) 2022 Pedro Victor (@pedrocga1)
*
********************************************************************************************/

#include <raylib.h>

#include <stdlib.h>

#if defined(PLATFORM_WEB)
    #include <emscripten/emscripten.h>
#endif

typedef struct
{
    Camera camera;
    int animFrameCounter;
    Model model;
    ModelAnimation *anims;
} Context;

//----------------------------------------------------------------------------------
// Global Variables Definition
//----------------------------------------------------------------------------------
const int screenWidth = 800;
const int screenHeight = 450;

//----------------------------------------------------------------------------------
// Module functions declaration
//----------------------------------------------------------------------------------
void UpdateDrawFrame(void *args);     // Update and Draw one frame

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
int main(void)
{
    // Initialization
    //--------------------------------------------------------------------------------------
    InitWindow(screenWidth, screenHeight, "Miss Showdown");

    // TODO: Remove this
    unsigned int animsCount = 0;

    Context context =
    {
        .camera =
        {
            .position = (Vector3){ 10.0f, 10.0f, 10.0f },
            .target = (Vector3){ 0.0f, 0.0f, 0.0f },
            .up = (Vector3){ 0.0f, 1.0f, 0.0f },
            .fovy = 45.0f,
            .projection = CAMERA_PERSPECTIVE,
        },
        .model = LoadModel("resources/cannon.m3d"),
        .anims = LoadModelAnimations("resources/cannon.m3d", &animsCount),
        .animFrameCounter = 0,
    };

    SetCameraMode(context.camera, CAMERA_FREE); // Set free camera mode

#if defined(PLATFORM_WEB)
    emscripten_set_main_loop_arg(UpdateDrawFrame, &context, 0, 1);
#else
    SetTargetFPS(60);   // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!WindowShouldClose())    // Detect window close button or ESC key
    {
        UpdateDrawFrame(&context);
    }
#endif

    // De-Initialization
    //--------------------------------------------------------------------------------------

    // Unload model animations data
    for (unsigned int i = 0; i < animsCount; i++) UnloadModelAnimation(context.anims[i]);
    RL_FREE(context.anims);

    UnloadModel(context.model);         // Unload model

    CloseWindow();              // Close window and OpenGL context
    //--------------------------------------------------------------------------------------
}

//----------------------------------------------------------------------------------
// Module Functions Definition
//----------------------------------------------------------------------------------
void UpdateDrawFrame(void *args)
{
    Context *c = args;

    // Update
    //----------------------------------------------------------------------------------
    UpdateCamera(&c->camera);

    // Play animation when spacebar is held down
    if (IsKeyDown(KEY_SPACE))
    {
        c->animFrameCounter++;
        UpdateModelAnimation(c->model, c->anims[0], c->animFrameCounter);
        if (c->animFrameCounter >= c->anims[0].frameCount) c->animFrameCounter = 0;
    }
    //----------------------------------------------------------------------------------

    // Draw
    //----------------------------------------------------------------------------------
    BeginDrawing();

        ClearBackground(RAYWHITE);

        BeginMode3D(c->camera);

            DrawModelEx(c->model, (Vector3) { 0.0f, 0.0f, 0.0f }, (Vector3){ 1.0f, 0.0f, 0.0f }, 0.0f, (Vector3){ 1.0f, 1.0f, 1.0f }, WHITE);

            for (int i = 0; i < c->model.boneCount; i++)
            {
                DrawCube(c->anims[0].framePoses[c->animFrameCounter][i].translation, 0.2f, 0.2f, 0.2f, RED);
            }

            DrawGrid(10, 1.0f);         // Draw a grid

        EndMode3D();

        DrawText("PRESS SPACE to PLAY MODEL ANIMATION", 10, 10, 20, MAROON);

    EndDrawing();
    //----------------------------------------------------------------------------------
}