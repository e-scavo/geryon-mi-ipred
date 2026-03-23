# Flows

## 1. Application startup flow

```text
main()
  -> WidgetsFlutterBinding.ensureInitialized()
  -> ProviderScope
  -> MyApp
  -> MyStartingPage
      -> _initWork()
      -> loading popup if app not ready
      -> waits for ServiceProvider lifecycle
      -> DashboardPage when ready
```

---

## 2. Connection bootstrap flow

```text
notifierServiceProvider
  -> waits for serviceProviderConfigProvider
  -> builds ServiceProvider(config)

MyStartingPage._initWork()
  -> appStatus.isReady?
    -> no: opens loading popup
    -> ServiceProvider.init()
```

---

## 3. WebSocket initialization flow

```text
ServiceProvider.init()
  -> wssClient.init()
  -> backend handshake
  -> token reception
  -> subscribeChannel()
  -> getBackendStatus()
  -> doCheckLogin()
```

---

## 4. Handshake flow

When the backend sends a message marked as `isNew == true`, the app interprets it as a connection bootstrap/handshake response.

Expected effects:
- receive `TokenID`
- mark connection as no longer new
- subscribe to backend channels
- continue initialization

This is a critical flow and must remain stable.

---

## 5. Channel subscription flow

Current subscribed channels:

- `GERYON_General`
- `GERYON_General_SCRUD`

Flow:

```text
subscribeChannel()
  -> send subscribe request
  -> wait for callback(s)
  -> mark channels as subscribed
  -> continue initialization
```

---

## 6. Backend status flow

After channel subscription, the app requests backend status.

Purpose:
- confirm backend availability
- move application into connected/ready state
- trigger login status verification

---

## 7. Login status verification flow

Current implemented behavior:

- if no in-memory logged user exists, return "not logged in"
- if an in-memory user exists, current implementation still forces re-login
- remote session validation code exists conceptually but is currently disabled/commented

This means current startup behavior effectively expects login as part of the normal flow.

---

## 8. Login flow

UI entry:
- `LoginPageWidget`

User input:
- DNI/CUIT
- remember me flag

Request:
- `Auth:Login`
- target = `customers`

Successful result:
- `loggedUser` is populated
- company context is populated
- dashboard becomes usable

---

## 9. Dashboard flow

```text
DashboardPage
  -> read loggedUser
  -> derive current selected customer
  -> show:
     - document
     - balance
     - payment details
     - latest payment
     - status
     - invoices
     - receipts
```

If multiple customers exist for the same login, the current customer can be switched through the UI menu.

---

## 10. Billing flow

`BillingWidget` is used to load customer billing-like data by type.

Observed active usage:
- `FacturasVT`
- `RecibosVT`

Commented/deferred:
- `CreditosVT`
- `DebitosVT`

The billing flow depends on:
- current logged user
- current selected customer
- generic table/data abstractions
- backend request/response processing through the central provider

---

## 11. Logout flow

```text
logout button
  -> SessionStorage.clear()
  -> ServiceProvider.logout()
  -> getBackendStatus()
  -> login required again
```

Note:
Local remembered DNI is cleared during explicit logout.