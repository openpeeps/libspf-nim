# SPF Library Nim Bindings
# https://github.com/shevek/libspf2/
#
# (c) 2026 George Lemon | MIT license
#          Made by Humans from OpenPeeps
#          https://github.com/openpeeps/libspf-nim

import ./spf_types

{.push importc, header: "spf.h".}
proc SPF_dns_resolv_new*(layer_below: SPF_dns_server_t, name: cstring, debug: cint): SPF_dns_server_t
{.pop.}