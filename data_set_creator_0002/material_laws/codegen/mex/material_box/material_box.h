/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * material_box.h
 *
 * Code generation for function 'material_box'
 *
 */

#pragma once

/* Include files */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mex.h"
#include "emlrt.h"
#include "rtwtypes.h"
#include "material_box_types.h"

/* Function Declarations */
void material_box(const emlrtStack *sp, boolean_T init_flag, const real_T sdv[2],
                  real_T epsilon, real_T mat_flag, real_T matparam[3], real_T
                  *stress, real_T sdvup[2]);

/* End of code generation (material_box.h) */
