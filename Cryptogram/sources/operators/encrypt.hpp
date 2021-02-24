#pragma once

#ifndef OPERATORS_ENCRYPT_HPP_INCLUDED
#define OPERATORS_ENCRYPT_HPP_INCLUDED

/* 公钥解密 */
int public_key_decrypt(unsigned char *enc_data, int data_len, unsigned char *key, unsigned char *decrypted);

/* 私钥加密 */
int private_key_encrypt(unsigned char *data, int data_len, unsigned char *key, unsigned char *encrypted);

/* 公钥加密 */
int public_key_encrypt(unsigned char *data, int data_len, unsigned char *key, unsigned char *encrypted);

/* 私钥解密 */
int private_key_decrypt(unsigned char *enc_data, int data_len, unsigned char *key, unsigned char *decrypted);

#endif