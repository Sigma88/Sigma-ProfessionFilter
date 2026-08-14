-- Local Tables

SigmaProfessionFilter = {};

local SPF = SigmaProfessionFilter;

SPF[1] = {};
SPF[2] = {};

SPF[1]["CFOnShow"] = {};
SPF[1]["CFOnUpdate"] = {};
SPF[2]["TSFOnShow"] = {};


local hooksecurefunc = function(arg2, arg3)
    arg1 = getfenv(0);
    local orig = arg1[arg2]
    arg1[arg2] = function(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20)
        local x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20 = orig(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20)
        
        arg3(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20)
        
        return x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20
    end
end

SPF[1].hooksecurefunc = hooksecurefunc;
SPF[2].hooksecurefunc = hooksecurefunc;