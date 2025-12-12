module {
  public type Account = { owner : Principal; subaccount : ?Blob };
  public type Approval = { allowance : Nat; expires_at : Nat64 };
  public type ApproveArg = {
    fee : ?Nat;
    main_subaccount : ?Blob;
    memo : ?Blob;
    created_at : ?Nat64;
    proxy : Account;
    amount : Nat;
    expected_allowance : ?Nat;
    expires_at : ?Nat64;
    spender : Account;
  };
  public type ApproveICRC1Err = {
    #GenericError : Type__1;
    #Duplicate : { of : Nat };
    #InsufficientBalance : { balance : Nat };
    #UnproxyableAccount;
    #BadFee : { expected_fee : Nat };
    #AmountTooLow : { minimum_amount : Nat };
    #AllowanceChanged : { allowance : Nat };
    #CreatedInFuture : { time : Nat64 };
    #ProxyAccount : { of : Account };
    #TooOld;
    #Proxied : { by : Account };
    #ExpiresTooFar : { max_expires_at : Nat64 };
    #Expired : { time : Nat64 };
  };
  public type Canister = actor {
    linker1_allowances_of : shared query [{ proxy : Account; spender : Account }] -> async [Approval];
    linker1_approve : shared [ApproveArg] -> async [Type_3];
    linker1_deposit : shared DepositArg -> async Type_2;
    linker1_fee_collector : shared query () -> async Account;
    linker1_main_accounts_of : shared query [Account] -> async [?Account];
    linker1_max_expiry : shared query () -> async Nat64;
    linker1_proxies_of : shared query (Account, ?Principal, ?Nat) -> async [
      Principal
    ];
    linker1_proxy_subaccounts_of : shared query (
      Account,
      Principal,
      ?Blob,
      ?Nat,
    ) -> async [Blob];
    linker1_spender_subaccounts_of : shared query (
      Account,
      Account,
      Principal,
      ?Blob,
      ?Nat,
    ) -> async [Blob];
    linker1_spenders_of : shared query (
      Account,
      Account,
      ?Principal,
      ?Nat,
    ) -> async [Principal];
    linker1_subaccounts_of : shared query (Principal, ?Blob, ?Nat) -> async [
      Blob
    ];
    linker1_token : shared query () -> async Principal;
    linker1_unlocked_balances_of : shared query [Account] -> async [Nat];
    linker1_withdraw : shared WithdrawArg -> async Type_1;
    linker1_withdraw_from : shared WithdrawFromArg -> async Type;
  };
  public type DepositArg = {
    fee : ?Nat;
    memo : ?Blob;
    subaccount : ?Blob;
    created_at : ?Nat64;
    amount : Nat;
  };
  public type DepositICRC1Err = {
    #GenericError : Type__1;
    #InsufficientAllowance : { allowance : Nat };
    #Duplicate : { of : Nat };
    #InsufficientBalance : { balance : Nat };
    #BadFee : { expected_fee : Nat };
    #AmountTooLow : { minimum_amount : Nat };
    #Locked : { amount : Nat };
    #CreatedInFuture : { time : Nat64 };
    #ProxyAccount : { of : Account };
    #TooOld;
    #TransferFailed : TransferFromError;
  };
  public type TransferError = {
    #GenericError : Type__1;
    #TemporarilyUnavailable;
    #BadBurn : { min_burn_amount : Nat };
    #Duplicate : { duplicate_of : Nat };
    #BadFee : { expected_fee : Nat };
    #CreatedInFuture : { ledger_time : Nat64 };
    #TooOld;
    #InsufficientFunds : { balance : Nat };
  };
  public type TransferFromError = {
    #GenericError : Type__1;
    #TemporarilyUnavailable;
    #InsufficientAllowance : { allowance : Nat };
    #BadBurn : { min_burn_amount : Nat };
    #Duplicate : { duplicate_of : Nat };
    #BadFee : { expected_fee : Nat };
    #CreatedInFuture : { ledger_time : Nat64 };
    #TooOld;
    #InsufficientFunds : { balance : Nat };
  };
  public type Type = { #Ok : Nat; #Err : WithdrawFromICRC1Err };
  public type Type_1 = { #Ok : Nat; #Err : WithdrawICRC1Err };
  public type Type_2 = { #Ok : Nat; #Err : DepositICRC1Err };
  public type Type_3 = { #Ok : Nat; #Err : ApproveICRC1Err };
  public type Type__1 = { message : Text; error_code : Nat };
  public type WithdrawArg = {
    to : Account;
    fee : ?Nat;
    memo : ?Blob;
    created_at : ?Nat64;
    from_subaccount : ?Blob;
    amount : Nat;
  };
  public type WithdrawFromArg = {
    to : Account;
    fee : ?Nat;
    spender_subaccount : ?Blob;
    memo : ?Blob;
    created_at : ?Nat64;
    proxy : Account;
    amount : Nat;
  };
  public type WithdrawFromICRC1Err = {
    #GenericError : Type__1;
    #InsufficientAllowance : { allowance : Nat };
    #Duplicate : { of : Nat };
    #InsufficientBalance : { balance : Nat };
    #BadFee : { expected_fee : Nat };
    #Locked : { amount : Nat };
    #CreatedInFuture : { time : Nat64 };
    #Unproxied;
    #TooOld;
    #TransferFailed : TransferError;
  };
  public type WithdrawICRC1Err = {
    #GenericError : Type__1;
    #Duplicate : { of : Nat };
    #InsufficientBalance : { balance : Nat };
    #BadFee : { expected_fee : Nat };
    #Locked : { amount : Nat };
    #CreatedInFuture : { time : Nat64 };
    #ProxyAccount : { of : Account };
    #TooOld;
    #TransferFailed : TransferError;
  };
};
