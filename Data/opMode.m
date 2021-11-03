% Copyright 2021 The MathWorks, Inc.
classdef opMode < Simulink.IntEnumType
  enumeration
    Disable(0)
    Enable(1)
    Activate(2)
    Resume(3)
    Increment(4)
    IncrementHold(5)
    Decrement(6)
    DecrementHold(7)
  end
end
  