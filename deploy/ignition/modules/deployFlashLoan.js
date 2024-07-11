const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("flashLoanModule", (m) => {
  const addressProvider = m.getParameter(
    "_addressProvider",
    "0x012bAC54348C0E635dCAc9D5FB99f06F24136C9A"
  );

  const lock = m.contract("FlashLoan", [addressProvider]);

  return { lock };
});

// #FlashLoan - 0xdd72E3f8Ea86b10d11deEF2c0e95705fedCa3b84
