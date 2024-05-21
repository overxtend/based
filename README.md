# Developer transactions on base

Deploying a simple smart contract on Ethereum's Layer 1 (L1) and Layer 2 (L2) networks using Remix is a great way to learn about smart contract development and deployment without the need for extensive setup. Here’s a step-by-step guide on how to achieve this:

## Step 1
### Setting Up Remix IDE

**Access Remix:** Open your web browser and go to Remix Ethereum IDE https://remix.ethereum.org/. Remix is an open-source web application that requires no installations.

## Step 2
### Writing the Smart Contract

**Create a New File:** In the Remix IDE, create a new file by clicking on the “File explorers” icon and then the “Create New File” icon. Name it SimpleStorage.sol.
**Write the Contract:** Enter the following Solidity code:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    uint storedData;

    function set(uint x) public {
        storedData = x;
    }

    function get() public view returns (uint) {
        return storedData;
    }
}
```
This contract has two functions: set to _store_ an integer and _get_ to retrieve it.

![image](https://github.com/overxtend/based/assets/19212595/07ce53cb-7bcc-402d-8633-c85a0bbf9a14)

## Step 3
### Compiling the Contract
**Compile the Contract:** Click on the “Solidity compiler” icon and then click “Compile SimpleStorage.sol”. Ensure you select the correct compiler version that matches the pragma statement in your contract.\ Follow the process in the image.

![image](https://github.com/overxtend/based/assets/19212595/2432b695-468e-4e90-a0e3-026b60f5abee)

## Step 4
### Deploying to EVM compatible chain (Mainnet or Testnet)

**Connect to MetaMask:** Ensure MetaMask is installed in your browser and logged in. Select a testnet like Rinkeby or Goerli for deployment. Avoid deploying on the mainnet as it will require real Ether.\
**Deploy the Contract:** Switch to the “Deploy & run transactions” panel.\
**Environment:** Select “Injected Web3” which uses MetaMask.\
**Account:** Choose your account in MetaMask.\
**Contract:** Select “SimpleStorage - SimpleStorage.sol”.\
Click “Deploy”.\
**Confirm the Transaction:** MetaMask will prompt you to confirm the transaction. Review and confirm to deploy the contract. You must be connected to Base sepolia network\

![image](https://github.com/overxtend/based/assets/19212595/7f5dcf97-7ce4-4547-bae0-60058fe44226)

![image](https://github.com/overxtend/based/assets/19212595/e5b9f733-4761-44e6-b157-358798dabe95)

## Step 6
### Interacting with the Contract
After deployment, you can interact with your contract:

**Set a Value:** Under “Deployed Contracts”, find your contract, enter a value in set function, and confirm the transaction.\
**Get the Stored Value:** Click the get function to see the stored value without any gas fee, as it's a view function.

![image](https://github.com/overxtend/based/assets/19212595/57cdab10-f58f-4187-b2db-45bf709580dd)


### STAY SAFU

_This code and accompanying tutorial are provided solely for educational purposes. They are intended to demonstrate basic concepts of smart contract development and deployment on Ethereum-compatible blockchains using Remix IDE. The code is provided "as is" without any guarantees, representations, or warranties, either express or implied, regarding its safety, correctness, or performance. It has not been audited, and there is no assurance it will work as intended. Users may experience delays, failures, errors, omissions, or loss of transmitted information. The contents of this tutorial should not be construed as investment advice or legal advice for any particular facts or circumstances. This tutorial is not intended to replace competent legal or financial counsel. Users are strongly advised to seek professional advice from a reputable attorney or financial advisor in their jurisdiction concerning any questions or concerns they may have. You have full liability for any use of the information provided in this tutorial. Users should proceed with caution and use this tutorial at their own risk._



