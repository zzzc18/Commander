operators = require("libraries.operators")

A = "cnsdjncjsdncjsd"
Len = 0
while Len ~= 128 do
    B = operators.encrypt(A)
    Len = string.len(B)
end
print(B)
C = operators.decrypt(B)
print(C)
