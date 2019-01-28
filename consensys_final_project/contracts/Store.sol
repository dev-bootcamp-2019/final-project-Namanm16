pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";


/**
 * @title Store
 * @dev This contract contains the required functions to manage the operations of the store.
 */
contract Store {
  using SafeMath for uint;

  address payable public owner;
  string public name;
  string public description;
  mapping (uint => Item) public items;
  uint public newestItemSku;
  bool public circuitBreak = false;

  /// @dev This struct called Item contains the properties of an item.
  struct Item {
    uint sku;
    uint quantity;
    uint price;
    string name;
    string description;
  }
  
  /**
     * All applicable events.
     */
  event NewItemAdded(string name, string description, uint indexed sku, uint price);
  event StockQuantityUpdated(uint indexed sku, uint newStockQuantity);
  event PurchaseMade(uint indexed sku, uint quantity);
  event ContractStateToggled(bool circuitBreak);

  /// @dev This modifier helps to revert a function if it is called by any account that is not the owner.
  modifier isOwner() {
    require(
      msg.sender == owner,
      "You don't have the authority to take this action.");
    _;
  }
  
   /// @dev This modifier helps to revert a function if the string length is more than 32 bytes.
  modifier stringLengthOkay(string memory str) {
    require(bytes(str).length <= 32);
    _;
  }

   /// @dev This modifier helps to revert a function if the sku does not exist.
  modifier skuExists(uint sku) {
    require(
      newestItemSku.sub(sku) >= 0,
      "Item does not exist.");
    _;
  }
  
  /// @dev This modifier helps to revert a function if there isn't enough quantity of the sku.
  modifier enoughQuantity(uint sku, uint quantity) {
    require(
      items[sku].quantity.sub(quantity) >= 0,
      "Not enough quantity left.");
    _;
  }
  
  /// @dev This modifier helps to revert a function if there isn't enough funds sent.
  modifier enoughFundsSent(uint sku, uint quantity) {
      require(
        msg.value >= items[sku].price.mul(quantity),
        "Insufficient funds provided.");

      _;

      if (msg.value > items[sku].price.mul(quantity)) {
        msg.sender.transfer(msg.value.sub(items[sku].price.mul(quantity)));
      }
  }

  modifier applyCircuitBreak {
    if (!circuitBreak) {
      _;
    }
  }


  constructor(address payable sender, string memory storeName, string memory storeDescription) 
    public
    stringLengthOkay(storeName)
    stringLengthOkay(storeDescription) 
    {
    owner = sender;
    name = storeName;
    description = storeDescription;
    newestItemSku = 0;
  }

  /** @dev Owner can toggle contract in case of emergency.
    */
  function toggleContractActive() 
    public
    isOwner {
      circuitBreak = !circuitBreak;
      emit ContractStateToggled(circuitBreak);
  }

  /** @dev Owner can withdraw any funds the store has earned by selling items.
    */
  function withdraw() public payable isOwner {
    owner.transfer(address(this).balance);
  }

  /** @dev Owner can add items to his/her store to sell.
    * @param newItemName The name of the item.
    * @param newItemDescription The description of the item.
    * @param newItemPrice The price of the item.
    */
  function addNewItem(string memory newItemName, string memory newItemDescription, uint newItemPrice) 
    public
    isOwner
    stringLengthOkay(newItemName)
    stringLengthOkay(newItemDescription) 
    {
    Item memory newItem = Item({
      sku: newestItemSku.add(1), 
      quantity: 0, 
      price: newItemPrice,
      name: newItemName, 
      description: newItemDescription
    });

    items[newestItemSku.add(1)] = newItem;
    newestItemSku = newestItemSku.add(1);
    emit NewItemAdded(newItem.name, newItem.description, newItem.sku, newItem.price);
  }

  /** @dev Owner can update the quantity for a given item.
    * @param sku The sku of the item.
    * @param newStockQuantity The updated quantity count of the item.
    */
  function updateStockQuantity(uint sku, uint newStockQuantity) 
    public
    skuExists(sku) 
    isOwner {

    items[sku].quantity = newStockQuantity;
    emit StockQuantityUpdated(sku, newStockQuantity);
  }

  /** @dev Shoppers call this to purchase a given item from the store.
    * @param sku The sku of the item.
    * @param quantity The number of quantity of the item the user is buying.
    */
  function purchaseItem(uint sku, uint quantity) 
    public 
    payable
    skuExists(sku)
    enoughQuantity(sku, quantity)
    enoughFundsSent(sku, quantity)
    applyCircuitBreak {

    items[sku].quantity = items[sku].quantity.sub(quantity);
    emit PurchaseMade(sku, quantity);
  }
  /** @dev Default payable function.
    */
  function ()external payable {}
}