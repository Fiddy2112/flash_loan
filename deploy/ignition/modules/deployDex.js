const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("DexModule", (m) => {
  const dex = m.contract("Dex");

  return { dex };
});

// #Dex - 0x84C18815572dE8eB68A88ef51a9927C3FA6B75e4
