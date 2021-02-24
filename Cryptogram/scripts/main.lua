operators = require("libraries.operators")

-- 要加密的字符串A
A = "cnsdjncjsdncjsd"

-- 加密后的长度，应为128
Len = 0
while Len ~= 128 do
    -- 加密后的字符串B
    B = operators.encrypt(A)
    Len = string.len(B)
end
print(B)
-- 解密B之后得到C，yuA一致
C = operators.decrypt(B)
print(C)
