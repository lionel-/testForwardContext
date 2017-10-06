context("forward")

test_that("can eval without longjump", {
    expect_identical(eval_forward(quote(sapply(letters, identity))), setNames(letters, letters))
})

test_that("handles exiting handlers", {
    expect_error(eval_forward(quote(stop("err"))), "err")

    out <- tryCatch(error = identity, eval_forward(quote(stop("err"))))
    expect_is(out, "simpleError")

    intervening <- function(expr) {
        force(expr)
        warning("shouldn't be run")
    }
    out <- tryCatch(intervening(eval_forward(quote(stop("err")))), error = identity)
    expect_is(out, "simpleError")


    block <- quote({
        signalCondition(NULL)
        stop("bad")
    })
    out <- tryCatch(simpleCondition = function(...) "foo", eval_forward(block))
    expect_identical(out, "foo")
})

test_that("handles long returns", {
    ret <- function() {
        eval_forward(quote(return("ret")))
    }
    expect_identical(ret(), "ret")
})

test_that("handles restarts", {
    out <- withRestarts(foo = function() "rst",
        eval_forward(quote(invokeRestart("foo")))
    )
    expect_identical(out, "rst")
})

test_that("can run R code calling `return()` in between", {
    # return() changes global variable for returned value
    ret <- function() return(1L)
    expr <- quote(signalCondition(NULL))
    cb <- quote(ret())

    out <- tryCatch(condition = function(...) "foo", eval_forward_callback(expr, cb))
    expect_identical(out, "foo")
})

test_that("can trigger and forward a longjump during another forwarded longjump", {
    cb <- quote(eval_forward(quote(signalCondition("foo"))))

    out <- tryCatch(condition = identity, error = identity,
        eval_forward_callback(quote(stop("err")), cb)
    )

    expect_is(out, "simpleCondition")
})
