# CTF: Rounding Errors

`contracts/Pool.sol` is a simple ETH pool: deposit ETH for shares, withdraw ETH
by burning shares. The value of a share should never go down.

## Play

```sh
npm ci
npm test
```

Edit only the marked section in `test/Pool.ts`, acting as `player`. You win
when `npm test` passes, meaning the value of a share went down.

Hint: Balancer V2 (November 2025) lost about $125M to a rounding error.
