#include <CoreImage/CoreImage.h>

extern "C" {
    namespace coreimage {

        float4 flipAndColorShift(sampler s, destination dest) {
            float width = s.extent()[2];        // 0:x, 1:y, 2:width, 3:height
            float x = width - dest.coord().x;
            float y = dest.coord().y;
            return s.sample(s.transform(float2(x, y))).gbra;
        }

    }
}
