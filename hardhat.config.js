require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.20",
  networks: {
    coreTestnet2: {
      url: "https://rpc.test2.btcs.network",
      accounts: [`0x${process.env.PRIVATE_KEY}`]
    }
  }
};
