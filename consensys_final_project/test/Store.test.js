var Store = artifacts.require("./Store.sol");


contract('Store', function(accounts) {
  let contract;

  before(() => Store.new(accounts[0], 'Test Store Name', 'Test Store Description')
    .then(instance => contract = instance));

  /*  
   * This test ensures that the store contract creator
   * is correctly set as the owner of the store.
   * This is important because only owners are allowed to 
   * take specific actions like adding items and withdrawing funds.
   */
  it("should create new store owner correctly.", function() {
    return contract.owner.call()
      .then(owner => assert.equal(owner, accounts[0], "The store contract creator was not set as owner."));
  });

  /*  
   * This test ensures that the store owner can create
   * a new item in the store, and that the item 
   * initializes correctly.
   */
  it("should allow store owners to add new items.", function() {
    return contract.addNewItem.sendTransaction('Test Item 1', 'Test Item 1 Description', 1)
      .then(() => contract.items.call(1))
      .then(item => {
        assert.equal(item[0].toNumber(), 1, "Item's SKU was not correctly set.");
        assert.equal(item[1].toNumber(), 0, "Item's quantity was not initially set to zero.");
        assert.equal(item[2].toNumber(), 1, "Item's price was not correctly set.");
        assert.equal(item[3], "Test Item 1", "Item's name was not correctly set.");
        assert.equal(item[4], "Test Item 1 Description", "Item's description was not correctly set.");
      });
  });

  /*  
   * This test ensures that the store owner can update
   * quantity for an existing item.
   */
  it("should allow store owner to add quantity to an existing item.", function() {
    return contract.updateStockQuantity.sendTransaction(1, 5)
      .then(() => contract.items.call(1))
      .then(item => {
        assert.equal(item[1].toNumber(), 5, "Item's quantity was not updated correctly.");
      });
  });

  /*  
   * This test ensures that the store owner can update
   * quantity for an existing item.
   */
  it("should allow a shopper to purchase a item from the store, and item balance reduces by respective amount.", function() {
    return contract.purchaseItem.sendTransaction(1, 5, {value: 5})
      .then(() => contract.items.call(1))
      .then(item => {
        assert.equal(item[1].toNumber(), 0, "Item's quantity was not updated after a sale correctly.");
      });
  });

  /*  
   * This test ensures that the store owner can withdraw
   * funds from the store upon successful sale.
   */
  it("should allow a store owner to withdraw funds after a sale.", function() {
    var ownerBalanceBefore = web3.eth.getBalance(accounts[0]).toNumber();
    var contractBalanceBefore = web3.eth.getBalance(contract.address).toNumber();

    return contract.withdraw.sendTransaction({from: accounts[0]})
      .then(() => assert.equal(ownerBalanceBefore - contractBalanceBefore, ownerBalanceBefore, "Contract balance did not successfully transfer to owner."));
  });



});