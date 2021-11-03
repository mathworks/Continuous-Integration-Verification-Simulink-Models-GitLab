% Copyright 2021 The MathWorks, Inc.
classdef reqMode < Simulink.IntEnumType
    enumeration
        NoRequest(0)
        Cancel(1)
        Cruise(2)
        Set(3)
        ResumeReq(4)
        Inc_Short(5)
        Inc_Middle(6)
        Inc_Long(7)
        Dec_Short(8)
        Dec_Middle(9)
        Dec_Long(10)
    end
end
