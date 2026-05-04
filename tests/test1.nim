when defined(macos):
  {.passL:"-L/usr/local/lib -lspf2".}
  {.passC:"-I/usr/local/include/spf2".}
elif defined(linux):
  {.passL:"-L/usr/lib/x86_64-linux-gnu -lspf2".}
  {.passC:"-I/usr/include/spf2".}

import unittest, strutils
import ../src/spf

const TXT = 16

proc runMailFromQuery(
  spf: SPF_server,
  ip, heloDom, envFrom: string
): tuple[err: SPF_errcode_t, result: SPF_result_t, receivedSpf: string, explanation: string] =
  let req = SPF_request_new(spf)
  check req != nil

  var resp: SPF_response = nil
  try:
    check SPF_request_set_ipv4_str(req, ip) == SPF_E_SUCCESS
    check SPF_request_set_helo_dom(req, heloDom) == SPF_E_SUCCESS
    check SPF_request_set_env_from(req, envFrom) == 0

    resp = SPF_response_new(req)
    check resp != nil

    result.err = SPF_request_query_mailfrom(req, addr resp)
    result.result = SPF_response_result(resp)

    let rcv = SPF_response_get_received_spf(resp)
    result.receivedSpf = if rcv == nil: "" else: $rcv

    let exp = SPF_response_get_explanation(resp)
    result.explanation = if exp == nil: "" else: $exp
  finally:
    if resp != nil:
      SPF_response_free(resp)
    SPF_request_free(req)

suite "SPF Library Tests":
  test "SPF PASS for allowed IPv4":
    # Create a test DNS server and add an SPF record for example.com
    let dns = SPF_dns_zone_new(nil, "test", 0)
    discard SPF_dns_zone_add_str(dns, "example.com", 16, 0, "v=spf1 ip4:203.0.113.5 -all") # 16 = TXT

    # Create SPF server using the test DNS
    let spf = SPF_server_new_dns(dns, 0)

    # Create a request and set the client IP and HELO domain
    let req = SPF_request_new(spf)
    discard SPF_request_set_ipv4_str(req, "203.0.113.5")
    discard SPF_request_set_helo_dom(req, "example.com")
    discard SPF_request_set_env_from(req, "sender@example.com")

    # Prepare response object
    let resp = SPF_response_new(req)
    discard SPF_request_query_mailfrom(req, addr resp)

    # Check result
    let result = SPF_response_result(resp)
    check result == SPF_RESULT_PASS
    SPF_response_free(resp)
    SPF_request_free(req)
    SPF_server_free(spf)

  test "SPF FAIL for disallowed IPv4 with -all":
    let dns = SPF_dns_zone_new(nil, "test", 0)
    check dns != nil
    check SPF_dns_zone_add_str(dns, "example.com", TXT, 0, "v=spf1 ip4:203.0.113.5 -all") == SPF_E_SUCCESS

    let spf = SPF_server_new_dns(dns, 0)
    check spf != nil
    try:
      let r = runMailFromQuery(spf, "203.0.113.99", "example.com", "sender@example.com")
      check r.err == SPF_E_SUCCESS
      check r.result == SPF_RESULT_FAIL
      check r.receivedSpf.toLowerAscii.contains("fail")
    finally:
      SPF_server_free(spf)

  test "SPF SOFTFAIL with ~all":
    let dns = SPF_dns_zone_new(nil, "test", 0)
    check dns != nil
    check SPF_dns_zone_add_str(dns, "example.com", TXT, 0, "v=spf1 ip4:203.0.113.5 ~all") == SPF_E_SUCCESS

    let spf = SPF_server_new_dns(dns, 0)
    check spf != nil
    try:
      let r = runMailFromQuery(spf, "203.0.113.99", "example.com", "sender@example.com")
      check r.err == SPF_E_SUCCESS
      check r.result == SPF_RESULT_SOFTFAIL
    finally:
      SPF_server_free(spf)

  test "SPF NONE when no SPF record exists":
    let dns = SPF_dns_zone_new(nil, "test", 0)
    check dns != nil

    let spf = SPF_server_new_dns(dns, 0)
    check spf != nil
    try:
      let r = runMailFromQuery(spf, "203.0.113.5", "nospf.example.com", "sender@nospf.example.com")
      check r.err == SPF_E_NOT_SPF
      check r.result == SPF_RESULT_NONE
    finally:
      SPF_server_free(spf)

  test "Malformed SPF record is treated as NOT_SPF":
    let dns = SPF_dns_zone_new(nil, "test", 0)
    check dns != nil
    check SPF_dns_zone_add_str(dns, "example.com", TXT, 0, "v=spf1 ip4:999.1.1.1 -all") == SPF_E_SUCCESS

    let spf = SPF_server_new_dns(dns, 0)
    check spf != nil
    try:
      let r = runMailFromQuery(spf, "203.0.113.5", "example.com", "sender@example.com")
      check r.err == SPF_E_NOT_SPF
      check r.result == SPF_RESULT_INVALID
    finally:
      SPF_server_free(spf)

  test "SPF PERMERROR for recursive include":
    let dns = SPF_dns_zone_new(nil, "test", 0)
    check dns != nil
    check SPF_dns_zone_add_str(dns, "loop.example.com", TXT, 0, "v=spf1 include:loop.example.com -all") == SPF_E_SUCCESS

    let spf = SPF_server_new_dns(dns, 0)
    check spf != nil
    try:
      let r = runMailFromQuery(spf, "203.0.113.5", "loop.example.com", "sender@loop.example.com")
      check r.err == SPF_E_RECURSIVE
      check r.result == SPF_RESULT_PERMERROR
    finally:
      SPF_server_free(spf)

  test "SPF PASS via include mechanism":
    let dns = SPF_dns_zone_new(nil, "test", 0)
    check dns != nil
    check SPF_dns_zone_add_str(dns, "example.com", TXT, 0, "v=spf1 include:_spf.example.net -all") == SPF_E_SUCCESS
    check SPF_dns_zone_add_str(dns, "_spf.example.net", TXT, 0, "v=spf1 ip4:203.0.113.10 -all") == SPF_E_SUCCESS

    let spf = SPF_server_new_dns(dns, 0)
    check spf != nil
    try:
      let r = runMailFromQuery(spf, "203.0.113.10", "example.com", "sender@example.com")
      check r.err == SPF_E_SUCCESS
      check r.result == SPF_RESULT_PASS
    finally:
      SPF_server_free(spf)


proc runMailFromQueryV6(
  spf: SPF_server,
  ip, heloDom, envFrom: string
): tuple[err: SPF_errcode_t, result: SPF_result_t, receivedSpf: string, explanation: string] =
  let req = SPF_request_new(spf)
  check req != nil

  var resp: SPF_response = nil
  try:
    check SPF_request_set_ipv6_str(req, ip) == SPF_E_SUCCESS
    check SPF_request_set_helo_dom(req, heloDom) == SPF_E_SUCCESS
    check SPF_request_set_env_from(req, envFrom) == 0

    resp = SPF_response_new(req)
    check resp != nil

    result.err = SPF_request_query_mailfrom(req, addr resp)
    result.result = SPF_response_result(resp)

    let rcv = SPF_response_get_received_spf(resp)
    result.receivedSpf = if rcv == nil: "" else: $rcv

    let exp = SPF_response_get_explanation(resp)
    result.explanation = if exp == nil: "" else: $exp
  finally:
    if resp != nil:
      SPF_response_free(resp)
    SPF_request_free(req)

suite "SPF Library IPv6 Tests":
  test "SPF PASS for allowed IPv6":
    let dns = SPF_dns_zone_new(nil, "test-v6", 0)
    check dns != nil
    check SPF_dns_zone_add_str(dns, "example.com", TXT, 0, "v=spf1 ip6:2001:db8::1 -all") == SPF_E_SUCCESS

    let spf = SPF_server_new_dns(dns, 0)
    check spf != nil
    try:
      let r = runMailFromQueryV6(spf, "2001:db8::1", "example.com", "sender@example.com")
      check r.err == SPF_E_SUCCESS
      check r.result == SPF_RESULT_PASS
      check r.receivedSpf.toLowerAscii.contains("pass")
    finally:
      SPF_server_free(spf)

  test "SPF FAIL for disallowed IPv6 with -all":
    let dns = SPF_dns_zone_new(nil, "test-v6", 0)
    check dns != nil
    check SPF_dns_zone_add_str(dns, "example.com", TXT, 0, "v=spf1 ip6:2001:db8::1 -all") == SPF_E_SUCCESS

    let spf = SPF_server_new_dns(dns, 0)
    check spf != nil
    try:
      let r = runMailFromQueryV6(spf, "2001:db8::2", "example.com", "sender@example.com")
      check r.err == SPF_E_SUCCESS
      check r.result == SPF_RESULT_FAIL
      check r.receivedSpf.toLowerAscii.contains("fail")
    finally:
      SPF_server_free(spf)

  test "SPF SOFTFAIL for disallowed IPv6 with ~all":
    let dns = SPF_dns_zone_new(nil, "test-v6", 0)
    check dns != nil
    check SPF_dns_zone_add_str(dns, "example.com", TXT, 0, "v=spf1 ip6:2001:db8::1 ~all") == SPF_E_SUCCESS

    let spf = SPF_server_new_dns(dns, 0)
    check spf != nil
    try:
      let r = runMailFromQueryV6(spf, "2001:db8::2", "example.com", "sender@example.com")
      check r.err == SPF_E_SUCCESS
      check r.result == SPF_RESULT_SOFTFAIL
    finally:
      SPF_server_free(spf)

  test "SPF PASS via include mechanism (IPv6)":
    let dns = SPF_dns_zone_new(nil, "test-v6", 0)
    check dns != nil
    check SPF_dns_zone_add_str(dns, "example.com", TXT, 0, "v=spf1 include:_spf6.example.net -all") == SPF_E_SUCCESS
    check SPF_dns_zone_add_str(dns, "_spf6.example.net", TXT, 0, "v=spf1 ip6:2001:db8::10 -all") == SPF_E_SUCCESS

    let spf = SPF_server_new_dns(dns, 0)
    check spf != nil
    try:
      let r = runMailFromQueryV6(spf, "2001:db8::10", "example.com", "sender@example.com")
      check r.err == SPF_E_SUCCESS
      check r.result == SPF_RESULT_PASS
    finally:
      SPF_server_free(spf)