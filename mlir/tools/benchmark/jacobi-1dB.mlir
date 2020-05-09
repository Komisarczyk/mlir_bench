#map0 = affine_map<(d0) -> (d0 - 1)>
#map1 = affine_map<(d0) -> (d0)>
#map2 = affine_map<(d0) -> (d0 + 1)>
#map3 = affine_map<() -> (1)>
#map4 = affine_map<() -> (1999)>
#map5 = affine_map<() -> (0)>
#map6 = affine_map<() -> (500)>


  func @scop_entry(%arg0: memref<2000xf32>, %arg1: memref<2000xf32>) {
    affine.for %arg2 = 0 to 500 {
      affine.for %arg3 = 1 to 1999 {
        %cst = constant 3.333300e-01 : f32
        %0 = affine.apply #map0(%arg3)
        %1 = affine.load %arg0[%0] : memref<2000xf32>
        %2 = affine.load %arg0[%arg3] : memref<2000xf32>
        %3 = addf %1, %2 : f32
        %4 = affine.apply #map2(%arg3)
        %5 = affine.load %arg0[%4] : memref<2000xf32>
        %6 = addf %3, %5 : f32
        %7 = mulf %cst, %6 : f32
        affine.store %7, %arg1[%arg3] : memref<2000xf32>
      }
      affine.for %arg3 = 1 to 1999 {
        %cst = constant 3.333300e-01 : f32
        %0 = affine.apply #map0(%arg3)
        %1 = affine.load %arg1[%0] : memref<2000xf32>
        %2 = affine.load %arg1[%arg3] : memref<2000xf32>
        %3 = addf %1, %2 : f32
        %4 = affine.apply #map2(%arg3)
        %5 = affine.load %arg1[%4] : memref<2000xf32>
        %6 = addf %3, %5 : f32
        %7 = mulf %cst, %6 : f32
        affine.store %7, %arg0[%arg3] : memref<2000xf32>
      }
    }
    return
  }


func @main() {
  %A = alloc() : memref<2000xf32>
%B = alloc() : memref<2000xf32>


  %cf1 = constant 1.00000e+00 : f32
  %cf2 = constant 2.00000e+00 : f32
  linalg.fill(%A, %cf2) : memref<2000xf32>, f32
  linalg.fill(%B, %cf2) : memref<2000xf32>, f32


  
  call @start_timer() : () -> ()
  call @scop_entry(%A,%B) :
    ( memref<2000xf32>,memref<2000xf32>) -> ()
  call @stop_timer() : () -> ()
  return
}

func @start_timer()
func @stop_timer()
func @print_memref_f32(memref<*xf32>)