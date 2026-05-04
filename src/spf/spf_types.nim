# SPF Library Nim Bindings
# https://github.com/shevek/libspf2/
#
# (c) 2026 George Lemon | MIT license
#          Made by Humans from OpenPeeps
#          https://github.com/openpeeps/libspf-nim

{.passC: "-include netinet/in.h".}
{.emit: "#include <netinet/in.h>".}
type
  in_addr* {.importc: "struct in_addr", bycopy, header: "<netinet/in.h>".} = object
  in6_addr* {.importc: "struct in6_addr", bycopy, header: "<netinet/in.h>".} = object

{.push importc, header: "spf.h".}
type
  SPF_server_t* {.incompleteStruct.} = object
  SPF_server* = ptr SPF_server_t

  SPF_server_dnstype_t* {.size: sizeof(cint).} = enum
    SPF_DNS_RESOLV,
    SPF_DNS_CACHE,
    SPF_DNS_ZONE


  SPF_dns_stat_t* = cint
  SPF_dns_server_t* {.incompleteStruct.} = object
  SPF_dns_server* = ptr SPF_dns_server_t

type
  SPF_response_t* {.incompleteStruct.} = object # Opaque, use pointer below
  SPF_response* = ptr SPF_response_t

  SPF_result_t* {.size: sizeof(cint).} = enum
    SPF_RESULT_INVALID = 0,
    SPF_RESULT_NEUTRAL,
    SPF_RESULT_PASS,
    SPF_RESULT_FAIL,
    SPF_RESULT_SOFTFAIL,
    SPF_RESULT_NONE,
    SPF_RESULT_TEMPERROR,
    SPF_RESULT_PERMERROR

  SPF_reason_t* {.size: sizeof(cint).} = enum
    SPF_REASON_NONE = 0,
    SPF_REASON_FAILURE,
    SPF_REASON_LOCALHOST,
    SPF_REASON_LOCAL_POLICY,
    SPF_REASON_MECH,
    SPF_REASON_DEFAULT,
    SPF_REASON_2MX

  SPF_errcode_t* {.size: sizeof(cint).} = enum
    SPF_E_SUCCESS = 0,
    SPF_E_NO_MEMORY,
    SPF_E_NOT_SPF,
    SPF_E_SYNTAX,
    SPF_E_MOD_W_PREF,
    SPF_E_INVALID_CHAR,
    SPF_E_UNKNOWN_MECH,
    SPF_E_INVALID_OPT,
    SPF_E_INVALID_CIDR,
    SPF_E_MISSING_OPT,
    SPF_E_INTERNAL_ERROR,
    SPF_E_INVALID_ESC,
    SPF_E_INVALID_VAR,
    SPF_E_BIG_SUBDOM,
    SPF_E_INVALID_DELIM,
    SPF_E_BIG_STRING,
    SPF_E_BIG_MECH,
    SPF_E_BIG_MOD,
    SPF_E_BIG_DNS,
    SPF_E_INVALID_IP4,
    SPF_E_INVALID_IP6,
    SPF_E_INVALID_PREFIX,
    SPF_E_RESULT_UNKNOWN,
    SPF_E_UNINIT_VAR,
    SPF_E_MOD_NOT_FOUND,
    SPF_E_NOT_CONFIG,
    SPF_E_DNS_ERROR,
    SPF_E_BAD_HOST_IP,
    SPF_E_BAD_HOST_TLD,
    SPF_E_MECH_AFTER_ALL,
    SPF_E_INCLUDE_RETURNED_NONE,
    SPF_E_RECURSIVE,
    SPF_E_MULTIPLE_RECORDS

  SPF_error_t* = object
    code*: SPF_errcode_t
    message*: cstring
    is_error*: char
    
  SPF_error* = ptr SPF_error_t


  SPF_request_t* {.incompleteStruct.} = object # Opaque, use pointer below
  SPF_request* = ptr SPF_request_t

  SPF_record_t* {.incompleteStruct.} = object # Opaque, use pointer below
  SPF_record* = ptr SPF_record_t

  SPF_macro_t* {.incompleteStruct.} = object # Opaque, use pointer below
  SPF_macro* = ptr SPF_macro_t

  # Data structures for SPF_data_str_t, SPF_data_var_t, SPF_data_cidr_t, SPF_data_t
  SPF_data_str_t* {.incompleteStruct.} = object
    parm_type*: uint8
    len*: uint8

  SPF_data_var_t* = object
    parm_type*: uint8
    num_rhs*: uint8
    rev*: uint16
    url_encode*: uint16
    delim_dot*: uint16
    delim_dash*: uint16
    delim_plus*: uint16
    delim_equal*: uint16
    delim_bar*: uint16
    delim_under*: uint16

  SPF_data_cidr_t* {.incompleteStruct.} = object
    parm_type*: uint8
    ipv4*: uint8
    ipv6*: uint8

  SPF_data_t* {.union.} = object
    dv*: SPF_data_var_t
    ds*: SPF_data_str_t
    dc*: SPF_data_cidr_t

  SPF_mech_t* = object
    prefix_type*: uint8
    mech_type*: uint8
    mech_len*: uint16

  SPF_mod_t* = object
    name_len*: uint16
    data_len*: uint16

  SPF_dns_rr_data_t* {.union.} = object
    a*: in_addr
    `ptr`*: array[1, char]
    mx*: array[1, char]
    txt*: array[1, char]
    aaaa*: in6_addr

  SPF_dns_rr_t* = object
    domain*: cstring
    domain_buf_len*: csize_t
    rr_type*: cint
    num_rr*: cint
    rr*: ptr ptr SPF_dns_rr_data_t
    rr_buf_len*: ptr csize_t
    rr_buf_num*: cint
    ttl*: culong      # time_t is usually long
    utc_ttl*: culong  # time_t is usually long
    herrno*: SPF_dns_stat_t
    hook*: pointer
    source*: SPF_dns_server

  SPF_dns_rr* = ptr SPF_dns_rr_t
{.pop.}
