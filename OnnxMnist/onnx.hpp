//
//  onnx.hpp
//  OnnxMnist
//
//  Created by Miguel de Icaza on 2/11/20.
//  Copyright © 2020 Miguel de Icaza. All rights reserved.
//

#ifndef onnx_hpp
#define onnx_hpp

#include <stdio.h>
extern "C" {
    void startOnnx ();
    int64_t run (float data [], float resOut []);
}

#endif /* onnx_hpp */
