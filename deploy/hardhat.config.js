require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
    sepolia: {
      url: `https://eth-sepolia.g.alchemy.com/v2/${process.env.SEPOLIA_TESTNET}`,
      accounts: [`0x${process.env.PRIVATE_KEY}`],
    },
  },
};

// #FlashLoan - 0xdd72E3f8Ea86b10d11deEF2c0e95705fedCa3b84
