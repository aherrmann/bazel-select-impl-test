load("@rules_cc//cc:defs.bzl", "cc_library")
load("//:help.bzl", "dump_variable")

BackendProvider = provider(fields = ["type"])

def create_backend(name):
    cc_library(
        name = "empty",
        visibility = ["//visibility:public"],
    )

    create_backend_setting(name = name, lib = ":empty", build_setting_default = ":empty")

def _create_backend_setting(ctx):
    print(ctx.attr.lib)
    return ctx.attr.lib[CcInfo]

create_backend_setting = rule(
    implementation = _create_backend_setting,
    attrs = {
        "lib": attr.label(providers = [CcInfo], mandatory = True),
    },
    build_setting = config.string(),
)

def _backend_transition_impl(settings, attr):
    print("Transition", attr.backend_lib)
    return {
        "//peek:mybackend": attr.backend_lib.name,
    }

_backend_transition = transition(
    implementation = _backend_transition_impl,
    inputs = ["//peek:mybackend"],
    outputs = ["//peek:mybackend"],
)

def _set_backend_impl(ctx):
    print("Set backend", ctx.attr.library)
    for l in ctx.attr.library[0][CcInfo].linking_context.linker_inputs.to_list():
        print(l)
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
            providers = [[CcInfo]],
        ),
    },
)
