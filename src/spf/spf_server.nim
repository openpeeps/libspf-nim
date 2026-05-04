# SPF Library Nim Bindings
# https://github.com/shevek/libspf2/
#
# (c) 2026 George Lemon | MIT license
#          Made by Humans from OpenPeeps
#          https://github.com/openpeeps/libspf-nim

import ./spf_dns, ./spf_types

{.push importc, header: "spf.h".}

proc SPF_server_new*(dnstype: SPF_server_dnstype_t, debug: cint): SPF_server
proc SPF_server_new_dns*(dns: SPF_dns_server, debug: cint): SPF_server
proc SPF_server_free*(sp: SPF_server)
proc SPF_server_set_rec_dom*(sp: SPF_server, dom: cstring): SPF_errcode_t
proc SPF_server_set_sanitize*(sp: SPF_server, sanitize: cint): SPF_errcode_t
proc SPF_server_set_explanation*(sp: SPF_server, exp: cstring, spf_responsep: ptr SPF_response_t): SPF_errcode_t
proc SPF_server_set_localpolicy*(sp: SPF_server, policy: cstring, use_default_whitelist: cint, spf_responsep: ptr SPF_response_t): SPF_errcode_t
proc SPF_server_get_record*(spf_server: SPF_server, spf_request: SPF_request_t, spf_response: SPF_response_t, spf_recordp: ptr SPF_record_t): SPF_errcode_t

# Accessors for max_dns_mech, max_dns_ptr, max_dns_mx
proc SPF_server_set_max_dns_mech*(spf_server: SPF_server, n: cint): SPF_errcode_t
proc SPF_server_get_max_dns_mech*(spf_server: SPF_server): cint
proc SPF_server_set_max_dns_ptr*(spf_server: SPF_server, n: cint): SPF_errcode_t
proc SPF_server_get_max_dns_ptr*(spf_server: SPF_server): cint
proc SPF_server_set_max_dns_mx*(spf_server: SPF_server, n: cint): SPF_errcode_t
proc SPF_server_get_max_dns_mx*(spf_server: SPF_server): cint

{.pop.}