  // test that the owner IS actually the owner!!
  // test that tokens can't be stolen!!!!
  // test that user is verified
  // test that deposit amount does not exceed maximum deposit
  // test that withdrawl amount does not exceed maximum withdrawl
  // test that payment is successfull
  // test that user/or other external contract can't invoke addSeed function
  // test that user/other external contract can't invoke addUser function
  // test that expiry date is not less than shelf life minus now/block.timestamp
// USE EVENTS OR DEBUGGER to sort of CONSOLE LOG stuff

// converts num, string, HEX string => returns an object BNjs instance
let BN = web3.utils.BN;
let SeedHub = artifacts.require("SeedHub");
const timestamp = require("unix-timestamp");

contract("SeedHub", function (accounts) {
  it("should assert true. Contract deployed successfully", async () => {
      await SeedHub.deployed();
      return assert.isTrue(true);
  });
  it("should confirm inheritance from Ownable.sol creating SeedHub owner", async () => {
     await instance.owner(), owner;  // how on earth can it leave owner unwrapped like this???
     return assert.strictEqual();
  });

  
  const [owner, newbie] = accounts;
  const emptyAddress = "0x0000000000000000000000000000000000000000";
  
  const shelfLife = 200;
  const lotGrams = 10000;
  const expiryDate = timestamp.fromDate("2030-12-31");
  const seedClass = "lampshade";
  const variety = "standing";
  const tokenBalance = 26; 
  let instance;
  
  beforeEach(async () => {
    instance = await SeedHub.new();
  });
  
  describe("Add seed", () => {
    it("owner should successfully add a seed", async () => {
      // I'm dubious about how easily we can throw in 'owner' everywhere in these tests
        await instance.addSeed(shelfLife, lotGrams, expiryDate, seedClass, variety,  { from: accounts[0] });

        const seed = await instance.fetchSeedLots();

        assert(seed.length === 1, "seed wasn't added");
      })
    })

    describe("Add User", () => {
      it("owner should successfully add a new user to verified users", async () => {
        // await instance.addUser(accounts[2], tokenBalance); this also works with  no other changes
        // await instance.addUser(newbie, tokenBalance, { from: owner }); these all work. How's that possible??
        await instance.addUser(accounts[2], tokenBalance, {from: accounts[0]} );
        const user = await instance.fetchUserBase();

        assert(user.length === 1, "user didn't show up after all");
      })
    })

    // describe("User Transaction", () => {
    //   it("should successfully let a /*verified*/ user make a seed deposit or withdrawl", async () => {
    //     await instance.userDeposit(lotGrams, seedClass, variety, { from: newbie} );
    //     const txSuccess = seedLots.length; 
    //     assert(seedLots.length =+ 1, "deposit was not successful")
    //   })
    // })

  });
