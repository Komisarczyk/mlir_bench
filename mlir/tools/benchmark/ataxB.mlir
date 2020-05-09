func @scop_entry(%arg0: memref<1900x2100xf32>, %arg1: memref<1900xf32>, %arg2: memref<2100xf32>, %arg3: memref<2100xf32>) {
    affine.for %arg4 = 0 to 2100 {
      %cst = constant 0.000000e+00 : f32
      affine.store %cst, %arg3[%arg4] : memref<2100xf32>
    }
    affine.for %arg4 = 0 to 1900 {
      %cst = constant 0.000000e+00 : f32
      affine.store %cst, %arg1[%arg4] : memref<1900xf32>
      affine.for %arg5 = 0 to 2100 {
        %0 = affine.load %arg1[%arg4] : memref<1900xf32>
        %1 = affine.load %arg0[%arg4, %arg5] : memref<1900x2100xf32>
        %2 = affine.load %arg2[%arg5] : memref<2100xf32>
        %3 = mulf %1, %2 : f32
        %4 = addf %0, %3 : f32
        affine.store %4, %arg1[%arg4] : memref<1900xf32>
      }
      affine.for %arg5 = 0 to 2100 {
        %0 = affine.load %arg3[%arg5] : memref<2100xf32>
        %1 = affine.load %arg0[%arg4, %arg5] : memref<1900x2100xf32>
        %2 = affine.load %arg1[%arg4] : memref<1900xf32>
        %3 = mulf %1, %2 : f32
        %4 = addf %0, %3 : f32
        affine.store %4, %arg3[%arg5] : memref<2100xf32>
      }
    }
    return
  }








func @main() {
  %A = alloc() : memref<1900x2100xf32>
  %B = alloc() : memref<1900xf32>
  %C = alloc() : memref<2100xf32>
  %D = alloc() : memref<2100xf32>

  %cf1 = constant 1.00000e+00 : f32
  %cf2 = constant 2.00000e+00 : f32
  linalg.fill(%A, %cf1) : memref<1900x2100xf32>, f32
  linalg.fill(%B, %cf1) : memref<1900xf32>, f32 
  linalg.fill(%C, %cf2) : memref<2100xf32>, f32 
  linalg.fill(%D, %cf2) : memref<2100xf32>, f32 

  
  call @start_timer() : () -> ()
  call @scop_entry(%A, %B, %C, %D) :
    (memref<1900x2100xf32>, memref<1900xf32>, memref<2100xf32>, memref<2100xf32>) -> ()
  call @stop_timer() : () -> ()
  return
}

func @start_timer()
func @stop_timer()
func @print_memref_f32(memref<*xf32>)