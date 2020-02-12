//
//  ContentView.swift
//  OnnxMnist
//
//  Created by Miguel de Icaza on 2/11/20.
//  Copyright © 2020 Miguel de Icaza. All rights reserved.
//

import SwiftUI

let mnistSize = 28

struct DrawSurface: View {
    @Binding var pixels: [Float]
    @Binding var prediction: [Float]
    
    func getCellSize (_ geometry: GeometryProxy) -> CGFloat
    {
         min (geometry.size.width, geometry.size.height) / CGFloat (mnistSize)
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            Path { path in
                let s = self.getCellSize (geometry)
                
                for x in 0..<mnistSize {
                    for y in 0..<mnistSize {
                        if self.pixels [x + y * mnistSize] > 0 {
                            path.addRect(CGRect(x: CGFloat(x)*s, y: CGFloat(y)*s, width: s, height: s))
                        }
                    }
                }
            }
            
            .fill (Color.red)
            .background(Color.white)
            .gesture (
                DragGesture ()
                    .onChanged { value in
                        let s = self.getCellSize (geometry)
                        let x = Int (value.location.x) / Int (s)
                        let y = Int (value.location.y) / Int (s)
                        if x < 0 || x >= mnistSize || y < 0 || y >= mnistSize {
                            return
                        }
                        let idx = x + y * mnistSize
                        if self.pixels [idx] == 0 {
                            self.pixels [idx] = 1
                        }
                        self.pixels.withUnsafeMutableBufferPointer { pixelPtr in
                            self.prediction.withUnsafeMutableBufferPointer { predictionPtr in
                                run (pixelPtr.baseAddress, predictionPtr.baseAddress)
                            }
                        }
                    }
            )
            
            }
            .aspectRatio(1.0, contentMode: .fit)
    }
}

struct ContentView: View {
    let size = 28
    @State var pixels: [Float] = Array.init(repeating: 0.0, count: mnistSize * mnistSize)
    @State var prediction: [Float] = Array.init (repeating: 0.0, count: 10)
    
    var body: some View {
        HStack {
            VStack {
                Text ("Draw below")
                    .font(.title)
                    .padding()
                    
                HStack {
                    VStack {
                        DrawSurface (pixels: $pixels, prediction: $prediction)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        Button(action: { for x in 0..<self.pixels.count { self.pixels [x] = 0 }}) {
                            Text("Clear")
                        }
                    }
                    VStack {
                        Text ("Prediction")
                        ForEach((0..<10)) { value in
                            Text ("\(value): \(self.prediction[value])")
                        }
                    }.padding ()
                }
                Spacer ()
            }
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
