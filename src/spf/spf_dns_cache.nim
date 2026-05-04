# SPF Library Nim Bindings
# https://github.com/shevek/libspf2/
#
# (c) 2026 George Lemon | MIT license
#          Made by Humans from OpenPeeps
#          https://github.com/openpeeps/libspf-nim

import ./spf_types
type time_t* = cint

{.push importc, header: "spf.h".}
proc SPF_dns_cache_new*(layer_below: SPF_dns_server_t, name: cstring, debug: cint, cache_bits: cint): SPF_dns_server_t
proc SPF_dns_cache_set_ttl*(spf_dns_server: SPF_dns_server_t, min_ttl: time_t, err_ttl: time_t, txt_ttl: time_t, rdns_ttl: time_t)
proc SPF_dns_set_conserve_cache*(spf_dns_server: SPF_dns_server_t, conserve_cache: cint)
{.pop.}