# SPF Library Nim Bindings
# https://github.com/shevek/libspf2/
#
# (c) 2026 George Lemon | MIT license
#          Made by Humans from OpenPeeps
#          https://github.com/openpeeps/libspf-nim

import ./spf_types
{.push importc, header: "spf.h".}
proc SPF_strerror*(spf_err: SPF_errcode_t): cstring
proc SPF_strresult*(result: SPF_result_t): cstring
proc SPF_strreason*(reason: SPF_reason_t): cstring
proc SPF_get_lib_version*(major, minor, patch: ptr cint)
proc SPF_strrrtype*(rr_type: cint): cstring
{.pop.}