
About the Bazaar
================
This project was one of the suggested project ideas as given in the course outline for the ConsenSys Academy's 2018 Developer Program. The brief was to build a decentralized Dapp on the Ethereum blockchain. I have chosen to name the marketplace ‘Bazaar’ and the stores within the bazaar are called stores. 
The address that deploys the marketplace contract will be the first admin of the of the bazaar. There will be three types of account holders as was suggested in the course outline – Admins, Store Owners and the shoppers. 
Admins are able to approve shop owner requests. Store owners are able to create stores and add items that can be sold for funds (Ether). When items are sold, quantity of items held is reduced. Also, the funds that the store owners have made is held in the store and they can withdraw it. Lastly, if a user is neither an admin nor store owner, then that user is a shopper. Shoppers can browse through stores and purchase items with funds(ether). 

Setup
-----
In order to run this project, you will need node and npm installed. You will also need to have Git and the Ethereum specific tools such as Truffle (needed in order to deploy the smart contracts onto the blockchain) and Metamask (online wallet) set up. Should you be missing any of these, please install them following the appropriate documentation on their respective websites.

In case you don’t already have it installed, you will also need to install the Open Zeppelin dependencies so that the contracts can read the libraries. Please run the following commands to do so:

`npm install openzeppelin-solidity`

Lastly, you will need to install Ganache to run a local development blockchain. As it is a simple install, I have included the instructions to do so below. Please run the following commands:

npm install -g ganache-cli
npm install -g truffle

Running a Local Blockchain
--------------------------
Once ganache-cli is installed, you can simply run the ganache-cli command to start the local blockchain. 
Note: Feel free to use Ganache if you prefer using an interface.

`Command to start`

`ganache-cli`

Starting the Project Locally
----------------------------
If you haven't already, you'll need to clone this repo in the location you would like to store it in.

`git clone https://github.com/dev-bootcamp-2019/final-project-Namanm16.git`

`cd final_project`

Now you will need to compile and migrate the smart contracts using truffle. Keep in mind that it is required to have ganache-cli running in a separate console.

`truffle compile`

`truffle migrate`


Setting up MetaMask
-------------------
To configure MetaMask please import the mnemonic that was generated from ganache-cli.
You will also need to change the network so that it is pointing to localhost:8545 instead of pointing to the test or main nets.

Testing
-------
The tests that cover the solidity smart contracts are located at ./test To run the tests, simply run truffle test.
There are 5 tests each for the Bazaar.sol and Store.sol contracts.
Note: ganache-cli will need to be running in order for the tests to run


Notes
-----
As you will see that from the very simple code that I have presented to you I am very new to developing and like most of us, especially to Ethereum development. I have not added the extra frills (uport integration, code in viper etc) to this project as can be expected from more experienced developers. However, I have learned a lot from this project and the learning curve has been steep. The truffle suite is a fantastic tool which helped learning the ethereum development process become a lot smoother. 

Possible Issues
---------------
MetaMask
--------
MetaMask has a reset option should the transaction nonce not match- which can be handy if the state of your local blockchain isn't what you're expecting.

