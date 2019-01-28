pragma solidity ^0.5.0;

import './Store.sol';

/**
 * @title Bazaar
 * @dev This contract contains the required functions to manage the operations of the Bazaar(Marketplace).
 */
contract Bazaar {
  mapping (address => bool) public admins;
  mapping (address => bool) public storeOwners;
  address[] public storeOwnerRequests;
  mapping (address => address[]) public storeAddressesByOwner;

  /**
     * All applicable events.
     */
  event StoreOwnerRequestSent(address storeOwnerRequestAddress);
  event StoreOwnerAdded(address storeOwnerAddress);
  event StoreOwnerRequestsUpdated(address[]);
  event NewStoreCreated(address owner, address store);

  /// @dev This modifier helps to revert a function if it is called by any account that is not an admin.
  modifier onlyAdmin() {
    require(admins[msg.sender] == true);
    _;
  }
  
  /// @dev This modifier helps to revert a function if it is called by any account that is not a store owner.
  modifier onlyStoreOwner() {
    require(storeOwners[msg.sender] == true);
    _;
  }
  /// @dev The constructor adds the owner to the list of admins.
  constructor() public {
    admins[msg.sender] = true;
  }

  /** @dev This function helps get a list of store contract addresses that the msg.sender is the owner of.
    * @return The list of store contract addresses.
    */
  function getStoreAddressesByOwner() public view returns (address[] memory) {
    return storeAddressesByOwner[msg.sender];
  }

  /** @dev This function generates a new store contract with msg.sender as the owner.
    * @param name is the name of the store.
    * @param description is the description of the store.
    */
  function createNewStore(string memory name, string memory description) public onlyStoreOwner {
      
    Store newStore = new Store(msg.sender, name, description);
    storeAddressesByOwner[msg.sender].push(address(newStore));
    emit NewStoreCreated(msg.sender, address(newStore));
  }

  /** @dev This function defines the user category of the msg.sender.
    * @return A string indicating what type of user msg.sender is.
    */
  function getUserType() public view returns (string memory) {
    if (admins[msg.sender] == true) {
      return 'admin';
    }
    else if (storeOwners[msg.sender] == true) {
      return 'storeOwner';
    }
    else {
      return 'shopper';
    }
  }

  /** @dev This function adds a request for msg.sender to become a store owner (pending admin approval).
    */
  function addStoreOwnerRequest() public {
    storeOwnerRequests.push(msg.sender);
    emit StoreOwnerRequestSent(msg.sender);
  }

  /** @dev This function adds a new store owner from the list of requests.
    * @param index is the index in the list of requests of the approved store owner.
    * @param storeOwner is the address of the store owner being approved.
    */
  function addStoreOwner(uint index, address storeOwner) public onlyAdmin {
    require(storeOwnerRequests.length > index);
    require(storeOwnerRequests[index] == storeOwner);
    storeOwners[storeOwner] = true;

    emit StoreOwnerAdded(storeOwner);
  }

  /** @dev This function gets all the store owner requests.
    * @return A list of all the addresses of the open requests.
    */
  function getStoreOwnerRequests() public view returns (address[] memory) {
    return storeOwnerRequests;
  }

  /** @dev This function adds a new admin to the bazaar.
    * @param newAdmin is the address of the new admin to add.
    */
  function addAdmin(address newAdmin) public onlyAdmin {
    admins[newAdmin] = true;
  }

  /** @dev This function allows admins to withdraw any funds sent to the contract.
    */
  function withdraw() public payable onlyAdmin {
    msg.sender.transfer(address(this).balance);
  }

  /** @dev Default payable function.
    */
  function () external payable {}
}