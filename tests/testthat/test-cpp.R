context("cpp")

test_that("stack unwinds on error", {
    unwound <- FALSE
    expect_error(cpp_eval(quote(stop("err")), unwound), "err")
    expect_true(unwound)
})

test_that("stack unwinds on caught conditions", {
    unwound <- FALSE
    expr <- quote(signalCondition(simpleCondition("cnd")))
    cnd <- tryCatch(cpp_eval(expr, unwound), condition = identity)
    expect_is(cnd, "simpleCondition")
    expect_true(unwound)
})

test_that("stack unwinds on restart invokations", {
    unwound <- FALSE
    expr <- quote(invokeRestart("rst"))
    out <- withRestarts(cpp_eval(expr, unwound), rst = function(...) "restarted")
    expect_identical(out, "restarted")
    expect_true(unwound)
})

test_that("stack unwinds on long returns", {
    k <- function() {
        cpp_eval(quote(return("ret")), unwound)
        stop("never reached")
    }
    unwound <- FALSE
    expect_identical(k(), "ret")
    expect_true(unwound)
})
