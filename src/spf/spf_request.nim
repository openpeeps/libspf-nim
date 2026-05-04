# SPF Library Nim Bindings
# https://github.com/shevek/libspf2/
#
# (c) 2026 George Lemon | MIT license
#          Made by Humans from OpenPeeps
#          https://github.com/openpeeps/libspf-nim

import ./spf_types

{.push importc, header: "spf.h".}
proc SPF_request_new*(spf_server: SPF_server): SPF_request
proc SPF_request_free*(sr: SPF_request)
proc SPF_request_set_ipv4*(sr: SPF_request, address: in_addr): SPF_errcode_t
proc SPF_request_set_ipv6*(sr: SPF_request, address: in6_addr): SPF_errcode_t
proc SPF_request_set_ipv4_str*(sr: SPF_request, astr: cstring): SPF_errcode_t
proc SPF_request_set_ipv6_str*(sr: SPF_request, astr: cstring): SPF_errcode_t
proc SPF_request_set_helo_dom*(sr: SPF_request, dom: cstring): SPF_errcode_t
proc SPF_request_set_env_from*(sr: SPF_request, fromAddress: cstring): cint
proc SPF_request_get_rec_dom*(sr: SPF_request): cstring
proc SPF_request_get_client_dom*(sr: SPF_request): cstring
proc SPF_request_is_loopback*(sr: SPF_request): cint

proc SPF_request_query_mailfrom*(spf_request: SPF_request, spf_responsep: ptr SPF_response): SPF_errcode_t
proc SPF_request_query_rcptto*(spf_request: SPF_request, spf_responsep: ptr SPF_response, rcpt_to: cstring): SPF_errcode_t
proc SPF_request_query_fallback*(spf_request: SPF_request, spf_responsep: ptr SPF_response, record: cstring): SPF_errcode_t

proc SPF_request_get_exp*(spf_server: SPF_server, spf_request: SPF_request, spf_response: SPF_response, spf_record: SPF_record, bufp: ptr cstring, buflenp: ptr csize_t): SPF_errcode_t

proc SPF_i_done*(spf_response: SPF_response, result: SPF_result_t, reason: SPF_reason_t, err: SPF_errcode_t): SPF_errcode_t

{.pop.}