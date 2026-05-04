# SPF Library Nim Bindings
# https://github.com/shevek/libspf2/
#
# (c) 2026 George Lemon | MIT license
#          Made by Humans from OpenPeeps
#          https://github.com/openpeeps/libspf-nim

import ./spf_types

{.push importc, header: "spf.h".}
proc SPF_dns_rr_new*(): SPF_dns_rr
proc SPF_dns_rr_free*(spfrr: SPF_dns_rr)
proc SPF_dns_rr_new_init*(spf_dns_server: SPF_dns_server, domain: cstring, rr_type: cint, ttl: cint, herrno: SPF_dns_stat_t): SPF_dns_rr
proc SPF_dns_rr_new_nxdomain*(spf_dns_server: SPF_dns_server, domain: cstring): SPF_dns_rr
proc SPF_dns_rr_buf_realloc*(spfrr: SPF_dns_rr, idx: cint, len: csize_t): SPF_errcode_t
proc SPF_dns_rr_dup*(dstp: ptr SPF_dns_rr, src: SPF_dns_rr): SPF_errcode_t
{.pop.}