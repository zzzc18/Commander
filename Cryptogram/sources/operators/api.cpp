#include <lua.hpp>
#include <string.h>
#include "encrypt.hpp"
#include <stdlib.h>
int encrypt(lua_State *L)
{
    unsigned char publicKey[] = "-----BEGIN PUBLIC KEY-----\n"
                                "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDpnuNRUS/EcPE1bsPcow4zVGQw\n"
                                "sZNF1P9dinqDt77hupwSkyj98WVlXo88fF15vNzIycYYXxBXcT+zco/SXRkFIxGF\n"
                                "KhGNvLBIZPgFwhhLdUYuC1IUGheAi7HRXd/LRQkI7/NMQKFwdYV+rb2SL2tJMKt4\n"
                                "LEB64wNpkXXJ/ptPdQIDAQAB\n"
                                "-----END PUBLIC KEY-----\n";

    char a[36] = {'\0'};
    unsigned char encrypted_str[256];
    strcpy(a, lua_tostring(L, 1));
    // 需要初始化，否则解密出来的字符串会有多余的乱码
    memset(encrypted_str, '\0', sizeof(encrypted_str));
    size_t len = strlen((const char *)(a));
    public_key_encrypt((unsigned char *)a, len, publicKey, encrypted_str);
    lua_pushstring(L, (const char *)encrypted_str);
    return 1;
}

int decrypt(lua_State *L)
{
    //私钥以及格式
    unsigned char privateKey[] = "-----BEGIN PRIVATE KEY-----\n"
                                 "MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAOme41FRL8Rw8TVu\n"
                                 "w9yjDjNUZDCxk0XU/12KeoO3vuG6nBKTKP3xZWVejzx8XXm83MjJxhhfEFdxP7Ny\n"
                                 "j9JdGQUjEYUqEY28sEhk+AXCGEt1Ri4LUhQaF4CLsdFd38tFCQjv80xAoXB1hX6t\n"
                                 "vZIva0kwq3gsQHrjA2mRdcn+m091AgMBAAECgYEAzC3/woxQUUHcrrR2HhmsSZRS\n"
                                 "VHR+oKO95EUpOoGXJLXxvhI722XlFqmESnrvP3yfAiXHKnm7UJE7+VwA8vxG5hii\n"
                                 "+ufhzEw6eiwXt2SVtEF+xkAxx1pzmXT9sOE175gA7q5uH48yR61BwFTR3Q1Bh0sY\n"
                                 "GGkho73P9pYzyG+7xekCQQD+nPX/KqlGY/ShTd136FdQDwR9A9YSPvh47+3eIjUR\n"
                                 "ivKFTFottU0WAd4/b/fOtJ/1llvgZsS/2V56aSLB89yzAkEA6uSnk2TgO+EV/ocO\n"
                                 "iRyrN3/xk4/B2dnkAb3ZUEfQS4kkUcNDkpHup14F0mG5mKHnDt+j9v5dp28RQdH5\n"
                                 "yhoHNwJBALNuF+o3vU0u2dHnFsEOyqFPxAD5+B2ppN9NbltRzgZL3jdUJGT71JRC\n"
                                 "wsX/+SoBnoyq5pqQsezlmbA4cVcvrQMCQGLi3AFbKGNNAPtkVCQ444O74zGiBZP2\n"
                                 "/NwW1pPLh88k7xtUvu/Ha9cd6AmHhqDRF/rU/6wNrdO9GGDDSwtgJcUCQQD8BCWC\n"
                                 "XaGyVEs4oB9EaqgEeiTsoGt3E98ZCODp7WCjA0zfVXPinn8AQk5lsQapPzBM8KQc\n"
                                 "mRPLKY5/DIBJCviw\n"
                                 "-----END PRIVATE KEY-----\n";

    char a[256] = {'\0'};
    unsigned char decrypted_str[256];
    strcpy(a, lua_tostring(L, 1));
    // 需要初始化，否则解密出来的字符串会有多余的乱码
    memset(decrypted_str, '\0', sizeof(decrypted_str));

    size_t len = strlen((const char *)(a));
    private_key_decrypt((unsigned char *)a, 128, privateKey, decrypted_str);
    lua_pushstring(L, (const char *)decrypted_str);
    return 1;
}

extern "C"
{
    int luaopen_libraries_operators(lua_State *L)
    {
        constexpr luaL_Reg functions[] = {
            {"encrypt", encrypt}, {"decrypt", decrypt}, {NULL, NULL}};
        luaL_register(L, "operators", functions);
        return 1;
    }
}
