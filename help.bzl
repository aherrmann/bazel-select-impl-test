COLOR_ASCII_CODES = {
    "black": "\033[0;30m",
    "red": "\033[0;31m",
    "green": "\033[0;32m",
    "yellow": "\033[0;33m",
    "blue": "\033[0;34m",
    "magenta": "\033[0;35m",
    "cyan": "\033[0;36m",
    "white": "\033[0;37m",
    "b_black": "\033[0;90m",
    "b_red": "\033[0;91m",
    "b_green": "\033[0;92m",
    "b_yellow": "\033[0;93m",
    "b_blue": "\033[0;94m",
    "b_magenta": "\033[0;95m",
    "b_cyan": "\033[0;96m",
    "b_white": "\033[0;97m",
}

DISABLE_COLOR = "\033[0m"

def _color(s, color):
    return "{}{}{}".format(COLOR_ASCII_CODES[color], s, DISABLE_COLOR)

def dump_variable(variable):
    """Dump contents of the variable.

    Args:
      variable: Variable to dump
    """
    dump_str = []
    prohibited_attributes = ["aspect_ids", "build_setting_value", "rule"]
    for attr in dir(variable):
        if attr not in prohibited_attributes:
            value = getattr(variable, attr)
            vtype = type(value)
            if vtype == "root":
                value = value.path
            elif vtype == "File":
                value = "{} ({})".format(value.path, "SOURCE" if value.is_source else "GENERATED")
            dump_str.append("{}({}) -> {}".format(
                _color(attr, "magenta"),
                _color(vtype, "blue"),
                _color(value, "green"),
            ))
    print("\n".join(dump_str))
