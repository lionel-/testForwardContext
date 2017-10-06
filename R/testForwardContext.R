#' @useDynLib testForwardContext test_eval_forward test_eval_forward_callback test_cpp
"_PACKAGE"

#' @export
eval_forward <- function(expr, env = parent.frame()) {
    .Call(test_eval_forward, expr, env)
}

#' @export
eval_forward_callback <- function(expr, callback = letters, env = parent.frame()) {
    .Call(test_eval_forward_callback, expr, callback, env)
}

#' @export
cpp_eval <- function(expr, indicator, env = parent.frame()) {
    .Call(test_cpp, expr, env, indicator)
}
