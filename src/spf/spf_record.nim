# SPF Library Nim Bindings
# https://github.com/shevek/libspf2/
#
# (c) 2026 George Lemon | MIT license
#          Made by Humans from OpenPeeps
#          https://github.com/openpeeps/libspf-nim

import ./spf_types

{.push importc, header: "spf.h".}
proc SPF_record_new*(spf_server: SPF_server, text: cstring): SPF_record
proc SPF_record_free*(rp: SPF_record)
proc SPF_macro_free*(mac: SPF_macro)

proc SPF_record_find_mod_value*(spf_server: SPF_server, spf_request: SPF_request, spf_response: SPF_response, spf_record: SPF_record, mod_name: cstring, bufp: ptr cstring, buflenp: ptr csize_t): SPF_errcode_t

proc SPF_record_compile*(spf_server: SPF_server, spf_response: SPF_response, spf_recordp: ptr SPF_record, record: cstring): SPF_errcode_t
proc SPF_record_compile_macro*(spf_server: SPF_server, spf_response: SPF_response, spf_macrop: ptr SPF_macro, record: cstring): SPF_errcode_t

proc SPF_record_interpret*(spf_record: SPF_record, spf_request: SPF_request, spf_response: SPF_response, depth: cint): SPF_errcode_t

proc SPF_record_expand_data*(spf_server: SPF_server, spf_request: SPF_request, spf_response: SPF_response, data: ptr SPF_data_t, data_len: csize_t, bufp: ptr cstring, buflenp: ptr csize_t): SPF_errcode_t

proc SPF_record_print*(spf_record: SPF_record): SPF_errcode_t
proc SPF_record_stringify*(spf_record: SPF_record, bufp: ptr cstring, buflenp: ptr csize_t): SPF_errcode_t

{.pop.}