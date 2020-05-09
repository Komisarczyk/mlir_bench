 func @scop_entry(%arg0: memref<2100x1900xf32>, %arg1: memref<1900xf32>, %arg2: memref<2100xf32>, %arg3: memref<2100xf32>, %arg4: memref<1900xf32>) {
    affine.for %arg5 = 0 to 1900 {
      %cst = constant 0.000000e+00 : f32
      affine.store %cst, %arg4[%arg5] : memref<1900xf32>
    }
    affine.for %arg5 = 0 to 2100 {
      %cst = constant 0.000000e+00 : f32
      affine.store %cst, %arg2[%arg5] : memref<2100xf32>
      affine.for %arg6 = 0 to 1900 {
        %0 = affine.load %arg4[%arg6] : memref<1900xf32>
        %1 = affine.load %arg3[%arg5] : memref<2100xf32>
        %2 = affine.load %arg0[%arg5, %arg6] : memref<2100x1900xf32>
        %3 = mulf %1, %2 : f32
        %4 = addf %0, %3 : f32
        affine.store %4, %arg4[%arg6] : memref<1900xf32>
        %5 = affine.load %arg2[%arg5] : memref<2100xf32>
        %6 = affine.load %arg0[%arg5, %arg6] : memref<2100x1900xf32>
        %7 = affine.load %arg1[%arg6] : memref<1900xf32>
        %8 = mulf %6, %7 : f32
        %9 = addf %5, %8 : f32
        affine.store %9, %arg2[%arg5] : memref<2100xf32>
      }
    }
    return
  }





func @main() {
  %A = alloc() : memref<2100x1900xf32>
  %B = alloc() : memref<1900xf32>
  %C = alloc() : memref<2100xf32>
  %D = alloc() : memref<2100xf32>
  %E = alloc() : memref<1900xf32>

  %cf1 = constant 1.00000e+00 : f32
  %cf2 = constant 2.00000e+00 : f32
  linalg.fill(%A, %cf1) : memref<2100x1900xf32>, f32
  linalg.fill(%B, %cf1) : memref<1900xf32>, f32
  linalg.fill(%C, %cf2) : memref<2100xf32>, f32
  linalg.fill(%D, %cf1) : memref<2100xf32>, f32
  linalg.fill(%E, %cf2) : memref<1900xf32>, f32
  
  call @start_timer() : () -> ()
  call @scop_entry(%A, %B, %C, %D, %E) :
    ( memref<2100x1900xf32>,  memref<1900xf32>,  memref<2100xf32>,  memref<2100xf32>, memref<1900xf32>) -> ()
  call @stop_timer() : () -> ()
  return
}

func @start_timer()
func @stop_timer()
func @print_memref_f32(memref<*xf32>)