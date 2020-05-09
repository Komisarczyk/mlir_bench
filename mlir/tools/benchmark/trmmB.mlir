#map0 = affine_map<(d0, d1) -> (d0, d1)>
#map1 = affine_map<(d0) -> (d0)>
#map2 = affine_map<() -> (1000)>
#map3 = affine_map<() -> (0)>
#map4 = affine_map<() -> (1200)>

func @scop_entry(%arg0: memref<1000x1000xf32>, %arg1: memref<1000x1200xf32>, %arg2: f32) {
    affine.for %arg3 = 0 to 1000 {
      affine.for %arg4 = 0 to 1200 {
        affine.for %arg5 = #map1(%arg3) to 1000 {
          %2 = affine.load %arg0[%arg5, %arg3] : memref<1000x1000xf32>
          %3 = affine.load %arg1[%arg5, %arg4] : memref<1000x1200xf32>
          %4 = mulf %2, %3 : f32
          %5 = affine.load %arg1[%arg3, %arg4] : memref<1000x1200xf32>
          %6 = addf %4, %5 : f32
          affine.store %6, %arg1[%arg3, %arg4] : memref<1000x1200xf32>
        }
        %0 = affine.load %arg1[%arg3, %arg4] : memref<1000x1200xf32>
        %1 = mulf %arg2, %0 : f32
        affine.store %1, %arg1[%arg3, %arg4] : memref<1000x1200xf32>
      }
    }
    return
  }





func @main() {
  %A = alloc() : memref<1000x1000xf32>
  %B = alloc() : memref<1000x1200xf32>


  %cf1 = constant 1.00000e+00 : f32
  %cf2 = constant 2.00000e+00 : f32
  linalg.fill(%A, %cf2) : memref<1000x1000xf32>, f32
  linalg.fill(%B, %cf1) : memref<1000x1200xf32>, f32

  
  call @start_timer() : () -> ()
  call @scop_entry(%A, %B, %cf2) :
    (memref<1000x1000xf32>, memref<1000x1200xf32>, f32) -> ()
  call @stop_timer() : () -> ()
  return
}

func @start_timer()
func @stop_timer()
func @print_memref_f32(memref<*xf32>)