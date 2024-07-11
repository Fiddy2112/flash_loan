const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("FlashLoanArbitrageModule", (m) => {
  const addressProvider = m.getParameter(
    "_addressProvider",
    "0x012bAC54348C0E635dCAc9D5FB99f06F24136C9A"
  );

  const lock = m.contract("FlashLoanArbitrage", [addressProvider]);

  return { lock };
});

// #FlashLoanArbitrage - 0x34445dC13325bC569061Ae85ECc8cA7C4721cBAe
