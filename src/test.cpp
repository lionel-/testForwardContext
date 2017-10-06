#define R_NO_REMAP
#include <Rinternals.h>

struct r_exception_t { };

// Class that indicates to R-level caller whether C++ stack was unwound
struct unwind_indicator_t {
  unwind_indicator_t(SEXP indicator_) {
    // Check unwind indicator is a scalar logical
    if (TYPEOF(indicator_) != LGLSXP || Rf_length(indicator_) != 1)
      throw r_exception_t();

    // Reset it to FALSE
    indicator = indicator_;
    *LOGICAL(indicator) = 0;
  }

  ~unwind_indicator_t() {
    *LOGICAL(indicator) = 1;
  }

  SEXP indicator;
};


SEXP test_cpp_eval(SEXP expr, SEXP env, SEXP indicator) {
  unwind_indicator_t my_data(indicator);

  int error = 0;
  SEXP out = ::R_tryEvalForward(expr, env, &error);

  if (error)
    throw r_exception_t();
  else
    return out;
}

extern "C"
SEXP test_cpp(SEXP expr, SEXP env, SEXP indicator) {
  try {
    return test_cpp_eval(expr, env, indicator);
  } catch (...) {
    return R_NilValue;
  }
}
