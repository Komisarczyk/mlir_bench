#map0 = affine_map<(d0) -> (d0)>
#map1 = affine_map<(d0, d1) -> (d0, d1)>
#map2 = affine_map<() -> (0)>
#map3 = affine_map<() -> (2000)>
#map4 = affine_map<() -> (990)>
#map5 = affine_map<() -> (1002)>

  func @scop_entry(%arg0: memref<2000x2000xf32>, %arg1: memref<2000xf32>, %arg2: memref<2000xf32>) {
    affine.for %arg3 = 0 to 2000 {
      %0 = affine.load %arg1[%arg3] : memref<2000xf32>
      affine.store %0, %arg2[%arg3] : memref<2000xf32>
      affine.for %arg4 = 0 to #map0(%arg3) {
        %4 = affine.load %arg0[%arg3, %arg4] : memref<2000x2000xf32>
        %5 = affine.load %arg2[%arg4] : memref<2000xf32>
        %6 = mulf %4, %5 : f32
        %7 = affine.load %arg2[%arg3] : memref<2000xf32>
        %8 = subf %6, %7 : f32
        affine.store %8, %arg2[%arg3] : memref<2000xf32>
      }
      %1 = affine.load %arg2[%arg3] : memref<2000xf32>
      %2 = affine.load %arg0[%arg3, %arg3] : memref<2000x2000xf32>
      %3 = divf %1, %2 : f32
      affine.store %3, %arg2[%arg3] : memref<2000xf32>
    }
    return
  }



func @main() {
  %A = alloc() : memref<2000x2000xf32>
  %B = alloc() : memref<2000xf32>
  %C = alloc() : memref<2000xf32>


  %cf1 = constant 1.00000e+00 : f32
  %cf2 = constant 9.00000e+00 : f32
  linalg.fill(%A, %cf2) : memref<2000x2000xf32>, f32
  linalg.fill(%B, %cf2) : memref<2000xf32>, f32
  linalg.fill(%C, %cf2) : memref<2000xf32>, f32

  call @start_timer() : () -> ()
  call @scop_entry(%A,%B,%C) :
    (memref<2000x2000xf32>, memref<2000xf32>, memref<2000xf32>) -> ()
  call @stop_timer() : () -> ()
  return
}

func @start_timer()
func @stop_timer()
func @print_memref_f32(memref<*xf32>)