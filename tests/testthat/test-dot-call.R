context("dot-call")

test_that(".Call() continuation is not run on error", {
    run <- FALSE
    eval_wrapper <- function(expr, env = parent.frame()) {
        .Call(test_eval_forward, expr, env)
        run <- TRUE
        stop("never run")
    }

    expect_error(eval_wrapper(quote(stop("err"))), "err")
    expect_false(run)
})

test_that("can tryCatch() around .Call()", {
    expr <- quote(stop("err"))
    out <- tryCatch(error = function(cnd) "err",
        .Call(test_eval_forward, expr, environment())
    )
    expect_identical(out, "err")
})
