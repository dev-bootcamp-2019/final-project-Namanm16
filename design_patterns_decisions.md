Design Patterns Decisions
=========================
Here are the design patterns that I have implemented in my smart contracts:

Smart Contract Design Decisions
-------------------------------
My dapp consists of two smart contracts:

1. Bazaar Contract

2. Store Contract

Bazaar Contract
---------------
The Bazaar smart contract contains the information about the admins, store owners, and shoppers in this bazaar. This is also where new store contracts are deployed and where information about the Store contract is located. Storage variables use mappings instead of arrays in order to reduce loops over arbitrary length arrays.

Store Contract
--------------
Each store created in the bazaar is its own Store contract instance. This makes sense due to stores having to hold Ether, and have special properties related to store ownership. This way, each instance is responsible for holding its own ether, which reduces the amount of ether stored in a given contract.

Circuit Breaker
---------------
A circuit breaker has been included in the store contract since that is where users send funds(ether).

Library Usage
-------------
I have used the SafeMath library from OpenZeppelin's OpenZeppelin Solidity library, which contains secure, community-audited smart contract security patterns. This was done to prevent integer overflow attack and to include math in the Store contract.


