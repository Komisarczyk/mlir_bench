  func @scop_entry(%arg0: memref<1000x1200xf64>, %arg1: memref<1200x1100xf64>, %arg2: memref<1000x1100xf64>, %arg3: f64, %arg4: f64) {
    affine.for %arg5 = 0 to 1000 {
      affine.for %arg6 = 0 to 1100 {
        %0 = affine.load %arg2[%arg5, %arg6] : memref<1000x1100xf64>
        %1 = mulf %arg4, %0 : f64
        affine.store %1, %arg2[%arg5, %arg6] : memref<1000x1100xf64>
      }
      affine.for %arg6 = 0 to 1200 {
        affine.for %arg7 = 0 to 1100 {
          %0 = affine.load %arg0[%arg5, %arg6] : memref<1000x1200xf64>
          %1 = mulf %arg3, %0 : f64
          %2 = affine.load %arg1[%arg6, %arg7] : memref<1200x1100xf64>
          %3 = mulf %1, %2 : f64
          %4 = affine.load %arg2[%arg5, %arg7] : memref<1000x1100xf64>
          %5 = addf %3, %4 : f64
          affine.store %5, %arg2[%arg5, %arg7] : memref<1000x1100xf64>
        }
      }
    }
    return
  }







func @main() {
  %A = alloc() : memref<1000x1200xf32>
  %B = alloc() : memref<1200x1100xf32>
  %C = alloc() : memref<1000x1100xf32>


  %cf1 = constant 1.00000e+00 : f32
  %cf2 = constant 2.00000e+00 : f32
  linalg.fill(%A, %cf1) : memref<1000x1200xf32>, f32
  linalg.fill(%B, %cf1) : memref<1200x1100xf32>, f32
  linalg.fill(%C, %cf2) : memref<1000x1100xf32>, f32

  
  call @start_timer() : () -> ()
  call @scop_entry(%A, %B, %C, %cf1, %cf2) :
    (memref<1000x1200xf32>, memref<1200x1100xf32>, memref<1000x1100xf32>, f32, f32) -> ()
  call @stop_timer() : () -> ()
  return
}

func @start_timer()
func @stop_timer()
func @print_memref_f32(memref<*xf32>)