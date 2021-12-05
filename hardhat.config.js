/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require('dotenv').config();
require('@nomiclabs/hardhat-ethers');
const {API_URL, METAMASK_PRIVATE_KEY, PROD_API_URL, PROD_METAMASK_PRIVATE_KEY, RINKEBY_API_URL} = process.env
module.exports = {
  solidity: {
    version: "0.8.0",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  defaultNetwork: "ropsten",
  networks: {
    hardhat: {},
    ropsten: {
      url: API_URL,
      accounts: [`0x${METAMASK_PRIVATE_KEY}`]
    },
    rinkeby: {
      url: RINKEBY_API_URL,
      accounts: [`0x${METAMASK_PRIVATE_KEY}`],
      gas: "auto",
      gasPrice: "auto"
    },
    mainnet: {
      url: PROD_API_URL,
      accounts: [`0x${PROD_METAMASK_PRIVATE_KEY}`],
      gasPrice: 150000000000
    }
  }
};
