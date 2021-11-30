
let BN = web3.utils.BN;
let SeedHub = artifacts.require("SeedHub");
const timestamp = require("unix-timestamp");

contract("SeedHub", function (accounts) {
  const [_owner, user] = accounts;
  const emptyAddress = "0x0000000000000000000000000000000000000000";
  
    const shelfLife = 200;
    const lotGrams = 10000;
    const expiryDate = timestamp.fromDate("2030-12-31");
    const seedClass = "lampshade";
    const variety = "standing";
   
    let instance;
    

  beforeEach(async () => {
    instance = await SeedHub.new();
  });

    describe("Add seed", () => {
      it("should successfully add a seed", async () => {
        await instance.addSeed(shelfLife, lotGrams, expiryDate, seedClass, variety, { from: user });

        const seed = await instance.fetchSeedLots();

        assert(seed.length === 1, "seed wasn't added");
      })
    })

  });