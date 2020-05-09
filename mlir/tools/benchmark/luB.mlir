#map0 = affine_map<(d0, d1) -> (d0, d1)>
#map1 = affine_map<() -> (0)>
#map2 = affine_map<(d0) -> (d0)>
#map3 = affine_map<() -> (2000)>
#map4 = affine_map<() -> (1)>


  func @scop_entry(%arg0: memref<2000x2000xf32>) {
    affine.for %arg1 = 1 to 2000 {
      affine.for %arg2 = 0 to #map2(%arg1) {
        affine.for %arg3 = 0 to #map2(%arg2) {
          %3 = affine.load %arg0[%arg1, %arg3] : memref<2000x2000xf32>
          %4 = affine.load %arg0[%arg3, %arg2] : memref<2000x2000xf32>
          %5 = mulf %3, %4 : f32
          %6 = affine.load %arg0[%arg1, %arg2] : memref<2000x2000xf32>
          %7 = subf %5, %6 : f32
          affine.store %7, %arg0[%arg1, %arg2] : memref<2000x2000xf32>
        }
        %0 = affine.load %arg0[%arg2, %arg2] : memref<2000x2000xf32>
        %1 = affine.load %arg0[%arg1, %arg2] : memref<2000x2000xf32>
        %2 = divf %0, %1 : f32
        affine.store %2, %arg0[%arg1, %arg2] : memref<2000x2000xf32>
      }
      affine.for %arg2 = #map2(%arg1) to 2000 {
        affine.for %arg3 = 0 to #map2(%arg1) {
          %0 = affine.load %arg0[%arg1, %arg3] : memref<2000x2000xf32>
          %1 = affine.load %arg0[%arg3, %arg2] : memref<2000x2000xf32>
          %2 = mulf %0, %1 : f32
          %3 = affine.load %arg0[%arg1, %arg2] : memref<2000x2000xf32>
          %4 = subf %2, %3 : f32
          affine.store %4, %arg0[%arg1, %arg2] : memref<2000x2000xf32>
        }
      }
    }
    return
  }


func @main() {
  %A = alloc() : memref<2000x2000xf32>


  %cf1 = constant 1.00000e+00 : f32
  %cf2 = constant 9.00000e+00 : f32
  linalg.fill(%A, %cf2) : memref<2000x2000xf32>, f32

  call @start_timer() : () -> ()
  call @scop_entry(%A) :
    (memref<2000x2000xf32>) -> ()
  call @stop_timer() : () -> ()
  return
}

func @start_timer()
func @stop_timer()
func @print_memref_f32(memref<*xf32>)