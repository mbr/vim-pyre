if exists('g:loaded_pyre')
    finish
endif
let g:loaded_pyre = 1

python <<ENDPYTHON
import re
import vim


def pyre_parse_perl_regex(s):
    delim = s[0]

    parts = []
    cur_part = []

    escaped = False
    inside_class = False

    for c in s[1:]:
        if c == '\\' and not escaped:
            escaped = True
        elif escaped:
            escaped = False
        elif c == '[':
            inside_class = True
        elif c == ']':
            inside_class = False
        elif c == delim and not escaped and not inside_class:
            # skip to next
            parts.append(cur_part)
            cur_part = []
            continue

        cur_part.append(c)

    parts.append(cur_part)

    return [''.join(p) for p in parts]


def pyre_sub(regexp, line1, line2):
    print "line1",line1,"line2",line2
    parts = pyre_parse_perl_regex(regexp)

    if len(parts) < 2:
        print "No substitution given"

    s_flags = parts[2] if len(parts) > 2 else ''
    pattern = parts[0]
    repl = parts[1]

    flags_translation = {
        'i': re.IGNORECASE,
        'l': re.LOCALE,
        's': re.DOTALL,
        'u': re.UNICODE,
        'x': re.VERBOSE,
    }

    count = 1
    flags = 0

    for f in s_flags:
        if f == 'g':
            count=0
        else:
            flags = flags | flags_translation[f]

    U_RE = re.compile(pattern, flags)

    for lineno in range(line1-1, line2):
        line = vim.current.buffer[lineno]
        vim.current.buffer[lineno] = U_RE.sub(repl, line, count)

ENDPYTHON

command -nargs=1 -range S py pyre_sub(<f-args>, <line1>, <line2>)
