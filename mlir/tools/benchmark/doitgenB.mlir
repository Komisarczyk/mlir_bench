func @scop_entry(%arg0: memref<150x140x160xf32>, %arg1: memref<160x160xf32>, %arg2: memref<160xf32>) {
    affine.for %arg3 = 0 to 150 {
      affine.for %arg4 = 0 to 140 {
        affine.for %arg5 = 0 to 160 {
          %cst = constant 0.000000e+00 : f32
          affine.store %cst, %arg2[%arg5] : memref<160xf32>
          affine.for %arg6 = 0 to 160 {
            %0 = affine.load %arg0[%arg3, %arg4, %arg6] : memref<150x140x160xf32>
            %1 = affine.load %arg1[%arg6, %arg5] : memref<160x160xf32>
            %2 = mulf %0, %1 : f32
            %3 = affine.load %arg2[%arg5] : memref<160xf32>
            %4 = addf %2, %3 : f32
            affine.store %4, %arg2[%arg5] : memref<160xf32>
          }
        }
        affine.for %arg5 = 0 to 160 {
          %0 = affine.load %arg2[%arg5] : memref<160xf32>
          affine.store %0, %arg0[%arg3, %arg4, %arg5] : memref<150x140x160xf32>
        }
      }
    }
    return
  }




func @main() {
  %A = alloc() : memref<150x140x160xf32>
  %B = alloc() : memref<160x160xf32>
  %C = alloc() : memref<160xf32>   


  %cf1 = constant 1.00000e+00 : f32
  %cf2 = constant 2.00000e+00 : f32
  linalg.fill(%A, %cf1) : memref<150x140x160xf32>, f32
  linalg.fill(%B, %cf2) : memref<160x160xf32>, f32    
  linalg.fill(%C, %cf1) : memref<160xf32>, f32         

  
  call @start_timer() : () -> ()
  call @scop_entry(%A, %B, %C) :
    ( memref<150x140x160xf32>, memref<160x160xf32>, memref<160xf32>) -> ()
  call @stop_timer() : () -> ()
  return
}

func @start_timer()
func @stop_timer()
func @print_memref_f32(memref<*xf32>)