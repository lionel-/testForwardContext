#define R_NO_REMAP
#include <Rinternals.h>

SEXP test_eval_forward(SEXP expr, SEXP env) {
    int error = 0;
    SEXP out = PROTECT(R_tryEvalForward(expr, env, &error));

    UNPROTECT(1);
    return out;
}

SEXP test_eval_forward_callback(SEXP expr, SEXP callback, SEXP env) {
    SEXP out = PROTECT(test_eval_forward(expr, env));

    Rf_eval(callback, env);

    UNPROTECT(1);
    return out;
}
