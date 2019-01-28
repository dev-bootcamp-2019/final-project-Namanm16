Avoiding Common Attacks
=======================
Smart contract security is not easy. Many attacks on smart contracts have caused millions of dollars of ether lost or stolen. A summary of the safety precautions implemented across Bazaar and Store smart contracts to mitigate the risk of common attack patterns on smart contracts.

Integer Overflow
----------------

The Store contract utilizes Open Zeppelin's SafeMath contract for all uint calculations in order to guard against integer overflow attacks.

Poison Data
-----------

Both the Bazaar and Store contracts accept user inputs of type string. As such, we must guard against long strings as a potential source of poison data. All places that accept string inputs include a modifier that checks the length of the incoming strings.

Pull Over Push
--------------

The Store contract utilizes a pull over push strategy for sending ETH to store owner to mitigate a potential for sending funds to resulting in a fail to prevent purchases from occurring.
