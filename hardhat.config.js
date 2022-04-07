require("dotenv").config();
require("@openzeppelin/hardhat-upgrades");

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.5.16",
      },
      {
        version: "0.6.2",
      },
      {
        version: "0.6.4",
      },
      {
        version: "0.7.0",
      },
      {
        version: "0.8.0",
      },
      {
        version: "0.8.2",
      },
    ],
  },
  networks: {
    hardhat: {
      gasPrice: 225000000000,
      chainId: 31337,
    },
    mumbai: {
      url: "https://rpc-mumbai.maticvigil.com",
      chainId: 80001,
      accounts: [`0x${process.env.TESTNET_PRIVATE_KEY}`],
    },
    matic: {
      url: "https://polygon-rpc.com",
      chaindId: 137,
      accounts: [`0x${process.env.MAINNET_PRIVATE_KEY}`],
    },
    rinkeby: {
      url: "https://rinkeby.infura.io/v3/${INFURA_API_KEY}",
      chainId: 4,
      accounts: [`0x${process.env.TESTNET_PRIVATE_KEY}`],
    },
    mainnet: {
      url: "https://main-rpc.linkpool.io",
      chainId: 1,
      accounts: [`0x${process.env.MAINNET_PRIVATE_KEY}`],
    },
  },
};
