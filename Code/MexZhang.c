#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "mex.h"
#include <cvode/cvode.h>
#include <cvode/cvode_dense.h>
#include <sundials/sundials_nvector.h>
#include <sundials/sundials_dense.h>
#include <sundials/sundials_types.h>
#include <nvector/nvector_serial.h>
/* Path to CVode to be changed as required above */


/* Input Arguments
 * - T_IN - Simulation Time and Time Step input in the form [T_0:time_step:T1]
 * - Y_IN - Initial Conditions
 * - P_IN - Parameter values the model is to be simulated with */

#define	T_IN	prhs[0]
#define	Y_IN	prhs[1]
#define P_IN    prhs[2]

/* Output Arguments
 * - YP_OUT is a vector containing the probability of being in the open state
 * at each time point */


static int f(realtype t, N_Vector y, N_Vector ydot, void* pr0);

/* Mex Function*/
static void MexZhang(N_Vector ydot, realtype t, N_Vector y, double* pr, double* T, double* Y0, int M, double* yout, double* zout, double* wout) {
    
    int N=(M-1);
    
    /*Work out T0 and Tfinal from T_IN*/
    realtype T0 =T[0];
    
    realtype Tfinal = (M-1)*(T[1]-T[0]);
    
    /* Define tolerances to be used*/
    N_Vector abstol = NULL;
    
    abstol = N_VNew_Serial(3);
    
    NV_Ith_S(abstol, 0) = 1e-8;
    NV_Ith_S(abstol, 1) = 1e-8;
    NV_Ith_S(abstol, 2) = 1e-8;
    
    realtype reltol = 1e-8;
    
    /* Set up CVode*/
    int flag, k;
    N_Vector y0 = NULL;
    void* cvode_mem = NULL;
    y0 = N_VNew_Serial(3);
    NV_Ith_S(y0, 0) = Y0[0];
    NV_Ith_S(y0, 1) = Y0[1];
    NV_Ith_S(y0, 2) = Y0[2];
    
    
    realtype NState = 3;
    
    /* Solver options*/
    cvode_mem = CVodeCreate(CV_BDF, CV_NEWTON);
    
    /* Initialize the memory */
    flag = CVodeSetUserData(cvode_mem, pr);
    
    flag = CVodeInit(cvode_mem, &f, T0, y0);
    
    /* Set tolerances and maximum step*/
    flag = CVodeSVtolerances(cvode_mem, reltol, abstol);
    flag = CVDense(cvode_mem, NState);
    flag = CVodeSetMaxStep(cvode_mem, 0.1);
    flag = CVodeSetMaxNumSteps(cvode_mem, 100000);
    /* Call CVode test for error and add result to output vector yout */
    for (k = 1; k < N; ++k) {
        double tout = k*Tfinal/N;
        
        
        if (CVode(cvode_mem, tout, y0, &t, CV_NORMAL) < 0) {
            fprintf(stderr, "Error in CVode: %d\n", flag);
        }
        
        /*Probability of being in open state is equal to 1-probability of being in any other state*/
        yout[k] = NV_Ith_S(y0, 0);
        zout[k] = NV_Ith_S(y0, 1);
        wout[k] = NV_Ith_S(y0, 2);
    }
    
    /*Free memory*/
    N_VDestroy_Serial(y0);
    CVodeFree(&cvode_mem);
    
}


static int f(realtype t, N_Vector y, N_Vector ydot, void* pr0) {
    double* pr = pr0;
    
    
    /* Define voltage protocol to be used*/
    double v;
    /* This shift is needed for simulated protocol to match the protocol recorded in experiment, which is shifted by 0.1ms as compared to the original input protocol. Consequently, each step is held for 0.1ms longer in this version of the protocol as compared to the input.*/
    double shift = 0.1;
    /* The number corresponding to the protocol to be simulated is passed at the front of the parameter values vector*/
    double protocol_number = pr[0];
    
    
    /* sine wave*/
    if (protocol_number==1) {
        double C[6] = {54, 26, 10, 0.007/(2*M_PI), 0.037/(2*M_PI), 0.19/(2*M_PI)};
        
        if (t>=0 && t<250+shift)
        {
            v = -80;
        }
        
        if (t>=250+shift && t<300+shift)
        {
            v = -120;
        }
        
        if (t>=300+shift && t<500+shift)
        {
            v = -80;
        }
        
        if (t>=500+shift && t<1500+shift)
        {
            v = 40;
        }
        
        
        if (t>=1500+shift && t<2000+shift)
        {
            v = -120;
        }
        if (t>=2000+shift && t<3000+shift)
        {
            v = -80;
        }
        
        
        if (t>=3000+shift && t<6500+shift)
        {
            v=-30+C[0]*(sin(2*M_PI*C[3]*(t-2500-shift))) + C[1]*(sin(2*M_PI*C[4]*(t-2500-shift))) + C[2]*(sin(2*M_PI*C[5]*(t-2500-shift)));
            
        }
        if (t>=6500+shift && t<7000+shift)
        {
            v=-120;
        }
        if (t>= 7000+shift && t<8000+shift)
        {
            v = -80;
        }
    }
    
    
    
    if (protocol_number==7)
    {
        
        int l = floor(10*t);
        v=pr[l+16];
        
    }
    
    if (protocol_number==9){
        
        int l = floor(10*t);
        v=pr[l+16];
        
    }
    
    if (protocol_number==11){
        
        int l = floor(10*t);
        v=pr[l+16];
        
    }
    if (protocol_number==12){
        
        int l = floor(10*t);
        v=pr[l+16];
        
    }
    if (protocol_number==13){
        
        int l = floor(10*t);
        v=pr[l+16];
        
    }     if (protocol_number==14){
        
        int l = floor(10*t);
        v=pr[l+16];
        
    }
    
    
    if (protocol_number==18)
    {
        
        int l = floor(10*t);
        v=pr[l+16];
        
    }
    
    
    
    
    if (protocol_number==19)
    {
        
        int l = floor(10*t);
        v=pr[l+16];
        
    }
     if (protocol_number==20)
    {
        
        int l = floor(10*t);
        v=pr[l+16];
        
    }
    
    
    /* Parameters from input parameters - as the first element of the vector corresponds to the protocol number, the parameter values start from the second element*/
    
    double P1 = pr[1];
    double P2 = pr[2];
    double P3 = pr[3];
    double P4 = pr[4];
    double P5 = pr[5];
    double P6 = pr[6];
    double P7 = pr[7];
    double P8 = pr[8];
    double P9 = pr[9];
    double P10 = pr[10];
    double P11 = pr[11];
    double P12 = pr[12];
    double P13 = pr[13];
    double P14 = pr[14];
    double P15 = pr[15];
    
    
    
    /*Ensures microscopic reversibility condition satisfied*/
    
    const double y1 = NV_Ith_S(y, 0);
    const double y2 = NV_Ith_S(y, 1);
    const double y3 = NV_Ith_S(y, 2);
    
    
    
    
    /* Model equations*/
    
    const double y1_inf = 1/(1+P1*exp(-P2*v));
    const double tau_fast = (1/((P3*exp(P4*v) + P5*exp(-P6*v))));
    const double tau_slow = (1/((P7*exp(P8*v) + P9*exp(-P10*v))));
    const double tau_rkr = P13;
    const double rkr_inf = 1/(1+P11*exp(P12*v));
    
    
    
    
    
    NV_Ith_S(ydot, 0) =  (y1_inf-y1)/tau_fast;
    NV_Ith_S(ydot, 1) =  (y1_inf-y2)/tau_slow;
    NV_Ith_S(ydot, 2) =  (rkr_inf-y3)/tau_rkr;
    
    
    return 0;
}


/* Mex function definition */
void mexFunction(int nlhs, mxArray *plhs[],
        int nrhs, const mxArray*prhs[] )
        
{
    N_Vector ydot;
    realtype t;
    N_Vector y;
    int M;
    
    /* Pointer to input variables/parameters*/
    
    double* pr;
    pr = mxGetPr(prhs[2]);
    
    M = mxGetN(T_IN);
    double* T;
    T = mxGetPr(prhs[0]);
    
    double* Y0;
    Y0 = mxGetPr(prhs[1]);
    
    double *yout;
    double *zout;
    double *wout;
    
    int Numvar;
    Numvar = mxGetN(Y_IN);
    
    /* Create a matrix for the return vector of open probabilities */
    plhs[0] = mxCreateDoubleMatrix(M-1, 1, mxREAL);
    plhs[1] = mxCreateDoubleMatrix(M-1, 1, mxREAL);
    plhs[2] = mxCreateDoubleMatrix(M-1, 1, mxREAL);
    
    /* Assign pointer output */
    yout = mxGetPr(plhs[0]);
    zout = mxGetPr(plhs[1]);
    wout = mxGetPr(plhs[2]);
    /* Mex function call */
    MexZhang(ydot, t, y, pr, T, Y0, M, yout, zout, wout);
    return;
    
}
