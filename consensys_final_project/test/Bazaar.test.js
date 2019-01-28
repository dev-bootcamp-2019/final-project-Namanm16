var Bazaar = artifacts.require("./Bazaar.sol");

contract('Bazaar', function(accounts) {

  /*  
   * This test ensures that the bazaar contract creator
   * is correctly set as the first admin on the bazaar.
   * This is important because only admins are allowed to 
   * take specific actions like add store owners from requests.
   */
  it("should set the bazaar admin correctly.", function() {
    return Bazaar.deployed()
      .then(instance => instance.admins.call(accounts[0]))
      .then(onlyAdmin => assert.equal(onlyAdmin, true, "The bazaar contract creator was not set as an admin."));
  });

  /*  
   * This test ensures that shoppers are able to request
   * to become a store owner, and that admins will be able to
   * view those requests.
   */
  it("should add a store owner request.", function() {
    let bazaarInstance;
    return Bazaar.deployed().then(instance => {
      bazaarInstance = instance;
      return bazaarInstance.addStoreOwnerRequest.sendTransaction({from: accounts[1]});
    })
    .then(() => bazaarInstance.storeOwnerRequests.call(0))
    .then(request => {
      assert.equal(request, accounts[1], "The store owner request address was not stored correctly.");
    });
  });

  /*  
   * This test ensures that admins are able to process requests
   * for shoppers to become store owners.
   */
  it("should add a store owner from a request.", function() {
    let bazaarInstance;

    return Bazaar.deployed()
      .then(instance => {
        bazaarInstance = instance;
      })
      .then(() => bazaarInstance.addStoreOwner.sendTransaction(0, accounts[1], {from: accounts[0]}))
      .then(() => bazaarInstance.storeOwners.call(accounts[1]))
      .then(onlyStoreOwner => {
        assert.equal(onlyStoreOwner, true, "The store owner was not added correctly.");
      });
  });

  /*  
   * This test ensures that the various types of users are correctly identified
   * in order to display the appropriate view in the UI.
   */
  it("should correctly identify an address as an admin.", function() {
    let bazaarInstance;

    return Bazaar.deployed()
      .then(instance => {
        bazaarInstance = instance;
      })
      .then(() => bazaarInstance.getUserType.call({from: accounts[0]}))
      .then(accountType => assert.equal(accountType, 'admin', "Admin address not identified correctly."));
  });

  /*  
   * This test ensures that the various types of users are correctly identified
   * in order to display the appropriate view in the UI.
   */
  it("should correctly identify an address as a store owner.", function() {
    let bazaarInstance;

    return Bazaar.deployed()
      .then(instance => {
        bazaarInstance = instance;
      })
      .then(() => bazaarInstance.getUserType.call({from: accounts[1]}))
      .then(accountType => assert.equal(accountType, 'storeOwner', "Store Owner address not identified correctly."));
  });

  

});