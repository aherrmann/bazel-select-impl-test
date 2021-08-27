load("//:def.bzl", "facade")

FACADE_LABEL = facade.label("peek")

def _facade_transition_impl(settings, attr):
    return facade.transition_impl(settings, attr, FACADE_LABEL)

_facade_transition = transition(
    implementation = _facade_transition_impl,
    inputs = [],
    outputs = [FACADE_LABEL],
)

create_facade_library = rule(
    implementation = facade.rule_impl,
    attrs = facade.attributes(_facade_transition),
)
