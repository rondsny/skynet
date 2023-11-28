#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

#include <skynet.h>
#include <skynet_server.h>

#include <string.h>
#include <stdint.h>

int snlua_pop_traces(void* instance, lua_State *L);
void snlua_set_traces(void* instance);

static int
_exec_get_trace(struct skynet_context *ctx, void *L) {
    const char* modname = skynet_modname(ctx);
    if(modname && strcmp(modname, "snlua") == 0){
        void* instance = skynet_context_instance(ctx);
        int ret = snlua_pop_traces(instance, L);
        snlua_set_traces(instance);
        return ret;
    }
    return 0;
}

static int
lget_tarce(lua_State *L) {
    uint32_t handle = luaL_checkinteger(L,1);
    int ret = skynet_exec(handle, _exec_get_trace, L);
    return ret;
}



LUAMOD_API int
luaopen_skynet_snlua_c(lua_State *L) {
    luaL_checkversion(L);
    luaL_Reg l[] = {
        {"get_trace", lget_tarce},
        { NULL, NULL },
    };
    luaL_newlib(L,l);
    return 1;
}