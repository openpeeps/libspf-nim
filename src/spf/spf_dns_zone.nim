# SPF Library Nim Bindings
# https://github.com/shevek/libspf2/
#
# (c) 2026 George Lemon | MIT license
#          Made by Humans from OpenPeeps
#          https://github.com/openpeeps/libspf-nim

{.passC: "-include spf.h -include spf_dns.h".}

import ./spf_types

{.push importc, header: "spf_dns_zone.h".}
proc SPF_dns_zone_new*(layer_below: SPF_dns_server, name: cstring, debug: cint): SPF_dns_server
proc SPF_dns_zone_add_str*(spf_dns_server: SPF_dns_server, domain: cstring, rr_type: cint, herrno: SPF_dns_stat_t, data: cstring): SPF_errcode_t
{.pop.}

{.push importc, header: "spf_dns_test.h".}
proc SPF_dns_test_new*(layer_below: SPF_dns_server, name: cstring, debug: cint): SPF_dns_server
{.pop.}