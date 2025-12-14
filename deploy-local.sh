clear
# mops test

# dfx stop
rm -rf .dfx
# dfx start --clean --background

echo "$(dfx identity use default)"
export DEFAULT_ACCOUNT_ID=$(dfx ledger account-id)
echo "DEFAULT_ACCOUNT_ID: " $DEFAULT_ACCOUNT_ID
export DEFAULT_PRINCIPAL=$(dfx identity get-principal)

export LINKER_ID="gvqys-hyaaa-aaaar-qagfa-cai" #ICP
export PX1M_ID="sv3dd-oaaaa-aaaar-qacoa-cai"
export FEE_COLLECTOR="oi6vq-zielx-3e5hy-wczon-esmft-5pinr-nyfjt-jmgxg-bzsjp-chwct-mae"

dfx deploy px1m_backend --no-wallet --specified-id $PX1M_ID --argument "(
  variant {
    Init = record {
			available = true;
			memo_size = record { min = 1; max = 32 };
      canvas = record { h = 1000; w = 1000 };
			duration = record {
				tx_window = 86_400_000_000_000;
				permitted_drift = 60_000_000_000;
			};
			fee_collector = principal \"$FEE_COLLECTOR\";
			linker = \"$LINKER_ID\";
      plans = vec {
        record { credits = 100; multiplier = 3 };
        record { credits = 1_000; multiplier = 2 };
        record { credits = 5_000; multiplier = 1 };
      };
			max_update_batch_size = 25;
      max_query_batch_size = 250;
      max_take_value = 250;
			archive = record {
				max_update_batch_size = 10;
				root = null;
				standby = null;
				min_tcycles = 4;
			}
		}
	}
)"

dfx deploy px1m_frontend --no-wallet


