//TEST(compute):COMPARE_COMPUTE:
//TEST_INPUT:ubuffer(data=[0 0 0 0], stride=4):dxbinding(0),glbinding(0),out

// Confirm that a struct type defined in a generic parent works

RWStructuredBuffer<float> outputBuffer;

struct GenStruct<T>
{
    struct SubType
    {
        T x;
    };
    T getVal(SubType v)
    {
        return v.x;
    }
};

T test<T>(T val)
{
    GenStruct<T>.SubType sb;
    sb.x = val;
    GenStruct<T> obj;
    return obj.getVal(sb);
}


[numthreads(4, 1, 1)]
void computeMain(uint3 dispatchThreadID : SV_DispatchThreadID)
{
    uint tid = dispatchThreadID.x;
    float inVal = float(tid);
    float outVal = test(inVal);
    outputBuffer[tid] = outVal.x;
}