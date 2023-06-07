/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * material_box.c
 *
 * Code generation for function 'material_box'
 *
 */

/* Include files */
#include "material_box.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtDCInfo emlrtDCI = { 27,    /* lineNo */
  12,                                  /* colNo */
  "material_box",                      /* fName */
  "/home/mharnisch/Schreibtisch/workingdirectory/PhD/data_set_creator/1D/data_set_creator_0002/material_laws/material_box.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo b_emlrtDCI = { 44,  /* lineNo */
  12,                                  /* colNo */
  "material_box",                      /* fName */
  "/home/mharnisch/Schreibtisch/workingdirectory/PhD/data_set_creator/1D/data_set_creator_0002/material_laws/material_box.m",/* pName */
  1                                    /* checkKind */
};

/* Function Definitions */
void material_box(const emlrtStack *sp, boolean_T init_flag, const real_T sdv[2],
                  real_T epsilon, real_T mat_flag, real_T matparam[3], real_T
                  *stress, real_T sdvup[2])
{
  real_T phi_tr_tmp;
  real_T phi_tr;

  /*  Material Box to be used in the Data Set creation */
  /*  In order to implement a new material model, two steps have to be carried */
  /*  out */
  /*  1. In the "init_flag" case distinction, the structure of the internal */
  /*  variables and the material parameters have to be defined. The structure */
  /*  of the internal variable can be chosen on own behalf as long as all */
  /*  information is assigned to the "sdvup" variable, which will be fed to the */
  /*  material law, and as long as the sdvup variable is consistently treated */
  /*  in your material routine. */
  /* Possible structure might of course be arrays, but the can */
  /*  also be of struct type (e.g. sdvup.plasti_strain = 0} or of cell type ( */
  /*  e.g. sdvup{1} = your_struct_here).  */
  /*  Note: The empty variable "stress = []" has to be defined for matlab to */
  /*  not abort with an error. */
  /*  2.  In the "mat_flag" case distinction, your material routine has to be */
  /*  implementd. The function can be of various as long as the output consists */
  /*  of the stress value (scalar) and your self defined sdvup structure. An */
  /*  example is given in the "linear_plasti" function. */
  if (init_flag) {
    /*  initialization of internal state variables */
    *stress = 0.0;
    sdvup[0] = 0.0;
    sdvup[1] = 0.0;
    if (mat_flag != (int32_T)muDoubleScalarFloor(mat_flag)) {
      emlrtIntegerCheckR2012b(mat_flag, &emlrtDCI, sp);
    }

    switch ((int32_T)mat_flag) {
     case 1:
      /*  linear plasticity with isotropic hardening */
      matparam[0] = 210000.0;
      matparam[1] = 500.0;
      matparam[2] = 10000.0;

      /*              stress = []; */
      break;

     case 2:
      /*  Your initilization of internal variables here */
      matparam[0] = 0.0;
      matparam[1] = 0.0;
      matparam[2] = 0.0;
      break;
    }
  } else {
    *stress = 0.0;
    sdvup[0] = 0.0;
    sdvup[1] = 0.0;
    if (mat_flag != (int32_T)muDoubleScalarFloor(mat_flag)) {
      emlrtIntegerCheckR2012b(mat_flag, &b_emlrtDCI, sp);
    }

    switch ((int32_T)mat_flag) {
     case 1:
      /*  linear plasticity with isotropic hardening */
      /*  One-dimensional constitutive modle for linear plasticity with linea isotropic hardening */
      /*  Extract Material parameters */
      /*  Extract internal variables */
      /* Predictor Corrector Scheme */
      *stress = matparam[0] * (epsilon - sdv[0]);
      phi_tr_tmp = muDoubleScalarAbs(*stress);
      phi_tr = phi_tr_tmp - (matparam[1] + matparam[2] * sdv[1]);
      if (phi_tr < 0.0) {
        sdvup[0] = sdv[0];
        sdvup[1] = sdv[1];
      } else {
        phi_tr /= matparam[0] + matparam[2];
        sdvup[0] = sdv[0] + phi_tr * muDoubleScalarSign(*stress);
        *stress *= 1.0 - matparam[0] * phi_tr / phi_tr_tmp;
        sdvup[1] = sdv[1] + phi_tr;
      }

      /*  Update internal variables into output structure */
      /*              [stress,sdvup] = linear_plasti_mex(sdv,epsilon,matparam); */
      matparam[0] = 0.0;
      matparam[1] = 0.0;
      matparam[2] = 0.0;
      break;

     case 2:
      /*  Your material model here */
      matparam[0] = 0.0;
      matparam[1] = 0.0;
      matparam[2] = 0.0;
      break;
    }
  }
}

/* End of code generation (material_box.c) */
