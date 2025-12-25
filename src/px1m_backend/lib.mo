import T "type";
import Blob "mo:core/Blob";
import Nat "mo:base/Nat";
import Principal "mo:core/Principal";
import Order "mo:core/Order";
import Nat64 "mo:core/Nat64";
import Nat8 "mo:base/Nat8";
import RBTree "../util/motoko/StableCollections/RedBlackTree/RBTree";
import Value "../util/motoko/Value";
import Subaccount "../util/motoko/Subaccount";
import Option "../util/motoko/Option";

module {
  public func getCredit(u : T.User, s : Blob) : Nat = switch (RBTree.get(u, Blob.compare, s)) {
    case (?found) found;
    case _ 0;
  };
  public func useCredit(n : Nat) : Nat = if (n > 0) n - 1 else 0;
  public func saveCredit(u : T.User, s : Blob, n : Nat) : T.User = if (n > 0) RBTree.insert(u, Blob.compare, s, n) else RBTree.delete(u, Blob.compare, s);

  public func dedupeCommit((ap : Principal, a : T.CommitArg), (bp : Principal, b : T.CommitArg)) : Order.Order {
    switch (Option.compare(a.created_at, b.created_at, Nat64.compare)) {
      case (#equal) ();
      case other return other;
    };
    switch (Principal.compare(ap, bp)) {
      case (#equal) ();
      case other return other;
    };
    switch (Option.compare(a.subaccount, b.subaccount, Blob.compare)) {
      case (#equal) ();
      case other return other;
    };
    switch (Option.compare(a.memo, b.memo, Blob.compare)) {
      case (#equal) ();
      case other return other;
    };
    switch (Nat.compare(a.x, b.x)) {
      case (#equal) ();
      case other return other;
    };
    switch (Nat.compare(a.y, b.y)) {
      case (#equal) ();
      case other return other;
    };
    switch (Nat8.compare(a.color, b.color)) {
      case (#equal) ();
      case other return other;
    };
    #equal;
  };

  public func dedupeTopup((ap : Principal, a : T.TopupArg), (bp : Principal, b : T.TopupArg)) : Order.Order {
    switch (Option.compare(a.created_at, b.created_at, Nat64.compare)) {
      case (#equal) ();
      case other return other;
    };
    switch (Principal.compare(ap, bp)) {
      case (#equal) ();
      case other return other;
    };
    switch (Option.compare(a.subaccount, b.subaccount, Blob.compare)) {
      case (#equal) ();
      case other return other;
    };
    switch (Option.compare(a.memo, b.memo, Blob.compare)) {
      case (#equal) ();
      case other return other;
    };
    switch (Option.compare(a.fee, b.fee, Nat.compare)) {
      case (#equal) ();
      case other return other;
    };
    switch (Option.compare(a.amount, b.amount, Nat.compare)) {
      case (#equal) ();
      case other return other;
    };
    switch (Nat.compare(a.plan, b.plan)) {
      case (#equal) ();
      case other return other;
    };
    #equal;
  };

  public func valueTopup(caller : Principal, sub : Blob, topup_fee : Nat, topup_credits : Nat, arg : T.TopupArg, pay_id : Nat, now : Nat64, phash : ?Blob) : Value.Type {
    var tx = RBTree.empty<Text, Value.Type>();
    tx := Value.setAccountP(tx, "acct", ?{ owner = caller; subaccount = Subaccount.opt(sub) });
    tx := Value.setNat(tx, "plan", ?arg.plan);
    tx := Value.setNat(tx, "xfer", ?pay_id);
    tx := Value.setBlob(tx, "memo", arg.memo);
    switch (arg.created_at) {
      case (?t) tx := Value.setNat(tx, "ts", ?Nat64.toNat(t));
      case _ ();
    };
    var map = RBTree.empty<Text, Value.Type>();
    switch (arg.fee) {
      case (?defined) if (defined > 0) tx := Value.setNat(tx, "fee", arg.fee);
      case _ if (topup_fee > 0) map := Value.setNat(map, "fee", ?topup_fee);
    };
    switch (arg.amount) {
      case (?defined) if (defined > 0) tx := Value.setNat(tx, "amt", arg.amount);
      case _ if (topup_credits > 0) map := Value.setNat(map, "amt", ?topup_credits);
    };
    map := Value.setNat(map, "ts", ?Nat64.toNat(now));
    map := Value.setText(map, "op", ?"topup");
    map := Value.setMap(map, "tx", tx);
    map := Value.setBlob(map, "phash", phash);
    #Map(RBTree.array(map));
  };

  public func valueCommit(caller : Principal, sub : Blob, arg : T.CommitArg, now : Nat64, phash : ?Blob) : Value.Type {
    var tx = RBTree.empty<Text, Value.Type>();
    tx := Value.setAccountP(tx, "acct", ?{ owner = caller; subaccount = Subaccount.opt(sub) });
    tx := Value.setNat(tx, "x", ?arg.x);
    tx := Value.setNat(tx, "y", ?arg.y);
    tx := Value.setNat(tx, "color", ?Nat8.toNat(arg.color));
    tx := Value.setBlob(tx, "memo", arg.memo);
    switch (arg.created_at) {
      case (?t) tx := Value.setNat(tx, "ts", ?Nat64.toNat(t));
      case _ ();
    };
    var map = RBTree.empty<Text, Value.Type>();
    map := Value.setNat(map, "ts", ?Nat64.toNat(now));
    map := Value.setText(map, "op", ?"commit");
    map := Value.setMap(map, "tx", tx);
    map := Value.setBlob(map, "phash", phash);
    #Map(RBTree.array(map));
  };

};
