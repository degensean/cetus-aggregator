module cetus_aggregator::utils {
    use sui::coin::{Self, Coin};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    use std::vector;

    const ECoinBelowThreshold: u64 = 1;

    #[allow(lint(self_transfer))]
    public fun transfer_or_destroy_coin<CoinType>(
        coin: Coin<CoinType>,
        ctx: &TxContext
    ) {
        if (coin::value(&coin) > 0) {
            transfer::public_transfer(coin, tx_context::sender(ctx))
        } else {
            coin::destroy_zero(coin)
        }
    }

    public fun check_coin_threshold<CoinType>(
        coin: &Coin<CoinType>,
        threshold: u64,
    ) {
        assert!(coin::value(coin) >= threshold, ECoinBelowThreshold);
    }

    public fun check_coins_threshold<CoinType>(
        coins: &vector<Coin<CoinType>>,
        threshold: u64,
    ) {
        let i = 0;
        let sum = 0;
        let length = vector::length(coins);
        while (i < length) {
            let coin = vector::borrow(coins, i);
            sum = sum + coin::value(coin);
            i = i + 1;
        };
        
        assert!(sum >= threshold, ECoinBelowThreshold);
    }
}
