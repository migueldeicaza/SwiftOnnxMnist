//
//  onnx.cpp
//  OnnxMnist
//
//  Created by Miguel de Icaza on 2/11/20.
//  Copyright © 2020 Miguel de Icaza. All rights reserved.
//
#include "onnxruntime_cxx_api.h"
#include "onnx.hpp"
#include <array>

const int width = 28;
const int height = 28;


std::array<float, width * height> input_image{};
Ort::Value input_tensor{nullptr};
std::array<int64_t, 4> input_shape{1, 1, width, height};

std::array<float, 10> results{};
Ort::Value output_tensor{nullptr};
std::array<int64_t, 2> output_shape{1, 10};

Ort::Env env;
Ort::Session session {env, "/tmp/mnist/model.onnx", Ort::SessionOptions{nullptr}};

void startOnnx ()
{
    
    auto memory_info = Ort::MemoryInfo::CreateCpu(OrtDeviceAllocator, OrtMemTypeCPU);
    Ort::Value::CreateTensor<float>(memory_info, input_image.data(), input_image.size(), input_shape.data(), input_shape.size());
    Ort::Value::CreateTensor<float>(memory_info, results.data(), results.size(), output_shape.data(), output_shape.size());
}

int64_t run (float data [], float resOut [])
{
    const char* input_names[] = {"Input3"};
    const char* output_names[] = {"Plus214_Output_0"};
    int64_t result{0};
    
    session.Run(Ort::RunOptions{nullptr}, input_names, &input_tensor, 1, output_names, &output_tensor, 1);

    result = std::distance(results.begin(), std::max_element(results.begin(), results.end()));
    for (int i = 0; i < 10; i++)
        resOut [i] = results [i];
        
    return result;
}
