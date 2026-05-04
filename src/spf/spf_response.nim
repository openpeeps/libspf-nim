# SPF Library Nim Bindings
# https://github.com/shevek/libspf2/
#
# (c) 2026 George Lemon | MIT license
#          Made by Humans from OpenPeeps
#          https://github.com/openpeeps/libspf-nim

import ./spf_types

{.push importc, header: "spf.h".}
proc SPF_response_new*(spf_request: SPF_request): SPF_response
proc SPF_response_free*(rp: SPF_response)
proc SPF_response_combine*(main: SPF_response, r2mx: SPF_response): SPF_response

proc SPF_response_result*(rp: SPF_response): SPF_result_t
proc SPF_response_reason*(rp: SPF_response): SPF_reason_t
proc SPF_response_errcode*(rp: SPF_response): SPF_errcode_t
proc SPF_response_get_received_spf*(rp: SPF_response): cstring
proc SPF_response_get_received_spf_value*(rp: SPF_response): cstring
proc SPF_response_get_header_comment*(rp: SPF_response): cstring
proc SPF_response_get_smtp_comment*(rp: SPF_response): cstring
proc SPF_response_get_explanation*(rp: SPF_response): cstring

proc SPF_response_messages*(rp: SPF_response): cint
proc SPF_response_errors*(rp: SPF_response): cint
proc SPF_response_warnings*(rp: SPF_response): cint
proc SPF_response_message*(rp: SPF_response, idx: cint): SPF_error

proc SPF_error_code*(err: SPF_error): SPF_errcode_t
proc SPF_error_message*(err: SPF_error): cstring
proc SPF_error_errorp*(err: SPF_error): char

proc SPF_response_add_error_ptr*(rp: SPF_response, code: SPF_errcode_t, text, tptr, format: cstring): SPF_errcode_t {.importc, varargs.}
proc SPF_response_add_error_idx*(rp: SPF_response, code: SPF_errcode_t, text: cstring, idx: cint, format: cstring): SPF_errcode_t {.importc, varargs.}
proc SPF_response_add_error*(rp: SPF_response, code: SPF_errcode_t, format: cstring): SPF_errcode_t {.importc, varargs.}
proc SPF_response_add_warn_ptr*(rp: SPF_response, code: SPF_errcode_t, text, tptr, format: cstring): SPF_errcode_t {.importc, varargs.}
proc SPF_response_add_warn_idx*(rp: SPF_response, code: SPF_errcode_t, text: cstring, idx: cint, format: cstring): SPF_errcode_t {.importc, varargs.}
proc SPF_response_add_warn*(rp: SPF_response, code: SPF_errcode_t, format: cstring): SPF_errcode_t {.importc, varargs.}

{.pop.}