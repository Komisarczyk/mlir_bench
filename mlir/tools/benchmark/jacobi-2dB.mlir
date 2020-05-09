#map0 = affine_map<(d0, d1) -> (d0, d1)>
#map1 = affine_map<(d0) -> (d0 - 1)>
#map2 = affine_map<(d0) -> (d0 + 1)>
#map3 = affine_map<() -> (1)>
#map4 = affine_map<() -> (1299)>
#map5 = affine_map<() -> (0)>
#map6 = affine_map<() -> (500)>



  func @scop_entry(%arg0: memref<1300x1300xf32>, %arg1: memref<1300x1300xf32>) {
    affine.for %arg2 = 0 to 500 {
      affine.for %arg3 = 1 to 1299 {
        affine.for %arg4 = 1 to 1299 {
          %cst = constant 2.000000e-01 : f32
          %0 = affine.load %arg0[%arg3, %arg4] : memref<1300x1300xf32>
          %1 = affine.apply #map1(%arg4)
          %2 = affine.load %arg0[%arg3, %1] : memref<1300x1300xf32>
          %3 = addf %0, %2 : f32
          %4 = affine.apply #map2(%arg4)
          %5 = affine.load %arg0[%arg3, %4] : memref<1300x1300xf32>
          %6 = addf %3, %5 : f32
          %7 = affine.apply #map2(%arg3)
          %8 = affine.load %arg0[%7, %arg4] : memref<1300x1300xf32>
          %9 = addf %6, %8 : f32
          %10 = affine.apply #map1(%arg3)
          %11 = affine.load %arg0[%10, %arg4] : memref<1300x1300xf32>
          %12 = addf %9, %11 : f32
          %13 = mulf %cst, %12 : f32
          affine.store %13, %arg1[%arg3, %arg4] : memref<1300x1300xf32>
        }
      }
      affine.for %arg3 = 1 to 1299 {
        affine.for %arg4 = 1 to 1299 {
          %cst = constant 2.000000e-01 : f32
          %0 = affine.load %arg1[%arg3, %arg4] : memref<1300x1300xf32>
          %1 = affine.apply #map1(%arg4)
          %2 = affine.load %arg1[%arg3, %1] : memref<1300x1300xf32>
          %3 = addf %0, %2 : f32
          %4 = affine.apply #map2(%arg4)
          %5 = affine.load %arg1[%arg3, %4] : memref<1300x1300xf32>
          %6 = addf %3, %5 : f32
          %7 = affine.apply #map2(%arg3)
          %8 = affine.load %arg1[%7, %arg4] : memref<1300x1300xf32>
          %9 = addf %6, %8 : f32
          %10 = affine.apply #map1(%arg3)
          %11 = affine.load %arg1[%10, %arg4] : memref<1300x1300xf32>
          %12 = addf %9, %11 : f32
          %13 = mulf %cst, %12 : f32
          affine.store %13, %arg0[%arg3, %arg4] : memref<1300x1300xf32>
        }
      }
    }
    return
  }




func @main() {
  %A = alloc() : memref<1300x1300xf32>
  %B = alloc() : memref<1300x1300xf32>



  %cf1 = constant 5.00000e+00 : f32
  %cf2 = constant 9.00000e+00 : f32
  linalg.fill(%A, %cf1) : memref<1300x1300xf32>, f32
  linalg.fill(%B, %cf2) : memref<1300x1300xf32>, f32


  
  call @start_timer() : () -> ()
  call @scop_entry(%A,%B) :
    ( memref<1300x1300xf32>, memref<1300x1300xf32>) -> ()
  call @stop_timer() : () -> ()
  return
}

func @start_timer()
func @stop_timer()
func @print_memref_f32(memref<*xf32>)