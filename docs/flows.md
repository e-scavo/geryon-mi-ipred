# Runtime Flows

## Overview

Mi IP·RED is driven by a backend-centric runtime model over WebSocket.

The most important flows are:

1. application bootstrap
2. handshake and token negotiation
3. channel subscription
4. backend status request
5. login state verification
6. login execution
7. dashboard/customer data usage

Phase 5 preserved all of these flows while reducing internal complexity in `ServiceProvider`.

---

## 1. Startup flow

    main.dart
      -> ProviderScope
      -> ServiceProvider creation
      -> init()
      -> socket connect
      -> wait for first backend message

Key constraint:
- startup visible behavior must remain stable

---

## 2. Handshake flow

    _onData(...)
      -> detect handshake message
      -> validate token
      -> apply session token
      -> continue initialization
          -> subscribeChannel()
          -> init() continuation

Important notes:
- handshake remains a special first-message path
- token assignment behavior was preserved
- Phase 5 only decomposed this flow into helpers

---

## 3. Channel subscription flow

    subscribeChannel()
      -> build subscribe request
      -> execute tracked request flow
      -> subscribeChannelCallback()
          -> update per-channel status
          -> advance counter
          -> finalize when expected channels are processed

Important notes:
- completion remains counter-based
- callback semantics remain unchanged
- partial and final subscription stages were preserved

---

## 4. Backend status flow

    getBackendStatus()
      -> build backend status request
      -> execute tracked request flow
      -> evaluate final response
      -> doCheckLogin()
          -> if user missing:
               show login popup
          -> if user available:
               apply authenticated context

Important notes:
- the post-success flow of backend status was decomposed
- login-popup fallback behavior remains unchanged
- backend contract remains unchanged

---

## 5. Check-login flow

    doCheckLogin()
      -> request current login/session state
      -> doCheckLoginCallback()
          -> parse current logged user if available
          -> apply authenticated context
          -> finalize tracked response

Important notes:
- callback-driven state application remains the real behavior
- success/failure semantics were preserved

---

## 6. Login flow

    doLogin()
      -> build login request
      -> execute tracked request flow
      -> doLoginCallback()
          -> parse login result
          -> apply authenticated context
          -> finalize tracked response

Important notes:
- `doLogin()` is request orchestration
- `doLoginCallback()` remains the place where authenticated user state is materialized
- this was preserved intentionally

---

## 7. Tracked request flow

This internal pattern is now explicit and reused:

    build request
      -> sendMessageV2(...)
      -> prepare tracked response state
      -> wait for tracked completion
      -> read final response
      -> wait until post-processing is done
      -> cleanup tracking

Applied in the most sensitive flows:
- backend status
- subscribe channel
- login

---

## 8. Dashboard usage flow

    provider ready
      -> current user/company/customer context available
      -> dashboard widgets consume provider data
      -> billing and receipts flows remain available

Important notes:
- dashboard behavior was not redesigned in Phase 5
- the purpose of this phase was to keep the provider runtime more maintainable without changing UI behavior
