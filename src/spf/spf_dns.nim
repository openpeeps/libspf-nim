# SPF Library Nim Bindings
# https://github.com/shevek/libspf2/
#
# (c) 2026 George Lemon | MIT license
#          Made by Humans from OpenPeeps
#          https://github.com/openpeeps/libspf-nim

import ./spf_types

{.push importc, header: "spf.h".}
proc SPF_dns_free*(spf_dns_server: SPF_dns_server)
proc SPF_dns_lookup*(spf_dns_server: SPF_dns_server, domain: cstring, rr_type: cint, should_cache: cint): SPF_dns_rr
proc SPF_dns_rlookup*(spf_dns_server: SPF_dns_server, ipv4: in_addr, rr_type: cint, should_cache: cint): SPF_dns_rr
proc SPF_dns_rlookup6*(spf_dns_server: SPF_dns_server, ipv6: in6_addr, rr_type: cint, should_cache: cint): SPF_dns_rr
proc SPF_dns_get_client_dom*(spf_dns_server: SPF_dns_server, sr: SPF_request): cstring
{.pop.}