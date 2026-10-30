import assert from "node:assert/strict";
import { describe, it } from "node:test";

import { network } from "hardhat";
import { parseEther, parseGwei } from "viem";

describe("CTF", async function () {
  const { viem } = await network.create();
  const publicClient = await viem.getPublicClient();
  const [deployer, alice, player] = await viem.getWalletClients();

  it("drain the pool", async function () {
    // Setup: Alice seeds the pool, then it earns fees.
    const pool = await viem.deployContract("Pool");
    await pool.write.deposit({ account: alice.account, value: parseGwei("1") });
    await deployer.sendTransaction({ to: pool.address, value: parseEther("10") });

    const assetsBefore = await publicClient.getBalance({ address: pool.address });
    const sharesBefore = await pool.read.totalShares();

    // ---- YOUR EXPLOIT HERE (use `player` only) ----

    // ---- END OF EXPLOIT ----

    const assetsAfter = await publicClient.getBalance({ address: pool.address });
    const sharesAfter = await pool.read.totalShares();

    // The value of a share must never decrease. You win if it did.
    assert.ok(
      assetsAfter * sharesBefore < assetsBefore * sharesAfter,
      "pool is still balanced: the value of a share did not decrease",
    );
  });
});
