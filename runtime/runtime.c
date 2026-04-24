typedef void (*AppFn)(void);
typedef struct { const char* name; AppFn init; } App;

static App apps[MAX_APPS] = {0};
static int app_count = 0;

void runtime_load_app(const char* name, AppFn init) {
    if (app_count < MAX_APPS) {
        apps[app_count].name = name;
        apps[app_count].init = init;
        app_count++;
    }
}

void runtime_run_lua_app(const char* file) {
    lua_State* L = luaL_newstate();
    luaL_openlibs(L);
    if (luaL_dofile(L, file)!= LUA_OK) {

        kernel_print(lua_tostring(L, -1));
    }
    lua_close(L);
}

void runtime_run_apps() {
    for(int i =0; i<app_count; i++) {
        if(apps[i].init)apps[i].init();
    }
}

void runtime_boot() {
    kernel_boot();
    kernel_print("Cocos OS runtime minimalista iniciado\n");

    runtime_load_app("notepad", app_notepad_init);

    runtime_load_app("calculator", app_calculator_init);

    runtime_load_app("settings", app_settings_init);

    runtime_run_apps();

    runtime_run_lua_app("apps_lua/main_tribe.lua");
}

void runtime_tick(){
    kernel_print("tick\n"); 
}