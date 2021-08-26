load("@rules_cc//cc:defs.bzl", "cc_library")

def create_backend(name):
    cc_library(
        name = "empty",
        visibility = ["//visibility:public"],
    )

    native.label_setting(
        name = "mybackend",
        build_setting_default = ":empty",
    )

def _backend_transition_impl(settings, attr):
    return {
        "//peek:mybackend": attr.backend_lib,
    }

_backend_transition = transition(
    implementation = _backend_transition_impl,
    inputs = [],
    outputs = ["//peek:mybackend"],
)

def _set_backend_impl(ctx):
    return [ctx.attr.library[0][CcInfo]]

set_backend = rule(
    implementation = _set_backend_impl,
    attrs = {
        "backend_lib": attr.label(mandatory = True),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
        "library": attr.label(
            cfg = _backend_transition,
            mandatory = True,
            providers = [CcInfo],
        ),
    },
)
