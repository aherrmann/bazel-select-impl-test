
_LABEL_NAME = "facade_implemenation"

def _facade_label(package):
    return "//{}:{}".format(package, _LABEL_NAME)

def _setup_facade(name):
    """Setup a facade for a library"""
    native.label_setting(
        name = _LABEL_NAME,
        build_setting_default = "//:empty",
    )

def _create_facade_impl(ctx):
    """Return the facade implemenation library."""
    lib = ctx.attr.facade[0]
    return lib[CcInfo]

def _facade_transition_impl(settings, attr, label):
    """Implemenation of transition for the facade"""
    return {label: attr.facade_impl}

def _facade_attributes(transition_fn):
    return {
        "facade_impl": attr.label(
            doc = "Library that implements the interface",
            mandatory = True,
        ),
        "facade": attr.label(
            doc = "Library that needs a implemenation to function",
            cfg = transition_fn,
            mandatory = True,
            providers = [CcInfo],
        ),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    }

facade = struct(
    label = _facade_label,
    setup_facade_library = _setup_facade,
    rule_impl = _create_facade_impl,
    transition_impl = _facade_transition_impl,
    attributes = _facade_attributes,
)
