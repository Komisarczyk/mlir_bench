func @scop_entry(%arg0: memref<1300x1300xf32>, %arg1: memref<1300x1300xf32>, %arg2: f32, %arg3: f32, %arg4: memref<1300xf32>, %arg5: memref<1300xf32>, %arg6: memref<1300xf32>) {
    affine.for %arg7 = 0 to 1300 {
      %cst = constant 0.000000e+00 : f32
      affine.store %cst, %arg4[%arg7] : memref<1300xf32>
      %cst_0 = constant 0.000000e+00 : f32
      affine.store %cst_0, %arg6[%arg7] : memref<1300xf32>
      affine.for %arg8 = 0 to 1300 {
        %5 = affine.load %arg0[%arg7, %arg8] : memref<1300x1300xf32>
        %6 = affine.load %arg5[%arg8] : memref<1300xf32>
        %7 = mulf %5, %6 : f32
        %8 = affine.load %arg4[%arg7] : memref<1300xf32>
        %9 = addf %7, %8 : f32
        affine.store %9, %arg4[%arg7] : memref<1300xf32>
        %10 = affine.load %arg1[%arg7, %arg8] : memref<1300x1300xf32>
        %11 = affine.load %arg5[%arg8] : memref<1300xf32>
        %12 = mulf %10, %11 : f32
        %13 = affine.load %arg6[%arg7] : memref<1300xf32>
        %14 = addf %12, %13 : f32
        affine.store %14, %arg6[%arg7] : memref<1300xf32>
      }
      %0 = affine.load %arg4[%arg7] : memref<1300xf32>
      %1 = mulf %arg2, %0 : f32
      %2 = affine.load %arg6[%arg7] : memref<1300xf32>
      %3 = mulf %arg3, %2 : f32
      %4 = addf %1, %3 : f32
      affine.store %4, %arg6[%arg7] : memref<1300xf32>

    }
    return
  }



func @main() {
  %A = alloc() : memref<1300x1300xf32>
  %B = alloc() : memref<1300x1300xf32>
  %C = alloc() : memref<1300xf32>
  %D = alloc() : memref<1300xf32>
  %E = alloc() : memref<1300xf32>
  %cf1 = constant 1.00000e+00 : f32
  %cf2 = constant 2.00000e+00 : f32
  linalg.fill(%A, %cf1) : memref<1300x1300xf32>, f32
  linalg.fill(%B, %cf1) : memref<1300x1300xf32>, f32
  linalg.fill(%C, %cf2) : memref<1300xf32>, f32
  linalg.fill(%D, %cf2) : memref<1300xf32>, f32
  linalg.fill(%E, %cf2) : memref<1300xf32>, f32
  
  call @start_timer() : () -> ()
  call @scop_entry(%A, %B, %cf1, %cf2, %C, %D, %E) :
    (memref<1300x1300xf32>, memref<1300x1300xf32>, f32, f32, memref<1300xf32>, memref<1300xf32>, memref<1300xf32>) -> ()
  call @stop_timer() : () -> ()
  return
}

func @start_timer()
func @stop_timer()
func @print_memref_f32(memref<*xf32>)