// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SeedHub is Ownable {

  // event lets front end see new user and their balance
  // event NewUserAdded(address NewUser, uint userTokenBalance);
  
  // uint public userLotId; % 1000000
  
  // differentiates owner's (deployer) address from message sender(user)
  // address owner = _owner;
  // differentiates user from owner
  // address user = msg.sender;
  // mapping so our functions can verify if user exists otherwise we send them to contract owner
  mapping(address => bool) public verifiedUsers;
  // mapping lets functions access user to their token balance/seedLots
  mapping(address => UserInfo[]) public userBase;
  //array to store ALL users' structs. There must be an efficient method. This isn't it.. 
  UserInfo[] public usersInfo;
  //mapping user to seedLots they have. Again, we can tighten all of this by reorganising struct members
  mapping(address => SeedLot[]) public userSeedLots;
  //array of all seedLot structs. 
  SeedLot[] public seedLots;
  // we need an data structure to store i)varieties ii)seedClasses
  //(nested array?? but this is so potentially storage consuming and gas intensive 
  // to push/shift to keep storage at a minimum)

// @ dev GET ALL STRINGS TURNED TO BYTES
  
  // struct with all info about a deposit
  // Still want a token balance of the user
  // I need an explainer on 'owner'
  struct SeedLot {
    uint shelfLife;
    uint lotGrams;
    uint expiryDate;
    string seedClass;
    string variety;
    address owner;
  }

  // struct keeps track of user activity (need a data structure e.g. array) which we 
  // still need to add, although we could do address/balance in a mapping
  // we should call it !!!!!!~~~~USER LOT~~~!!!!!!
  // We're going to KYC the user
  struct UserInfo {
      address user;
      uint tokenBalance;
  }
  
  // @notice function to let user deposit seeds and get paid tokens
  // @params lotGram(weight of user deposit), seedClass, variety (of said seedClass)
  // @params newTokenBalance (updated user token balance) 
  // @params need verifiedUser modifier
  // @dev add 3 param values to SeedLot and push to seedLots array
  // @dev map caller address 
  // @dev call payment transfer function
  // function userDeposit(uint _lotGram, string memory _seedClass, string memory _variety)
  //   public payable verifiedUser returns (uint _newTokenBalance) 
  //    getter function fetchSeedLots is already called below
  //    require(allowed userSeedDeposit = maxStockLimit - balanceGrams / 10 
  //    e.g. (25000 - 14000) / 10 = 1100 
  //    SeedLot _pointer = addToLot {
  //    need to add 3 values to a struct of 6 values from msg.sender
  //    _pointer._lotGram
  //    _pointer._seedclass etc etc
  //    }
  //    reentrancy: do following in correct order
  //    work out user's payment and transfer msg.value to their account
  //    from owner (I guess this is possibily an easy way??)
  //    update their struct with new tokenBalance;  
  //    push addToLot to UserInfo struct
  //    emit depositSuccess(newTokenBalance, _lotGram, _seedClass, variety)
  //    move up => event  depositSuccess(uint newTokenBalance, uint _lotGram, string indexed _seedClass, string indexed _variety)

  // @notice user withdraws seedLot and tokens are deducted from their balance
  // @params lotGram(weight of user deposit), seedClass, variety (of said seedClass)
  // @params newTokenBalance (updated user token balance) 
  // @params need verifiedUser modifier
  // @dev grab appropriate SeedLot, update above 3 params, and deduct tokens from user balance
  // @dev call payment transfer function
  // function userWithdraw(uint _lotGram, string memory _seedClass, string memory _variety) 
  //   public payable verifiedUser returns (uint _newTokenBalance) 


    



  
  // modifier checks if user is in verifiedUsers mapping to 
  // restrict user access to only some functions 
  // modifier verifiedUser(address _user) {
  //   require(verifiedUsers[msg.sender] == true, "Caught, mister. We pinpoint potential trouble-makers...And neutralize them!");
  //   _;
  // }

     // @notice internal function called by onlyOwner to add new user 
  // @params add new user and newly allocated tokens to userInfo struct
  // and usersBase array, accessible through userBase mapping (careful of spellings)
  // returns bool for verifiedUser mapping to be used with verifiedUser modifier
  function addUser(address _user, uint _tokenBalance) external onlyOwner returns(bool) { 
      UserInfo memory newUser = UserInfo ({
        user: _user,
        tokenBalance: _tokenBalance
      });
      usersInfo[_user].push(newUser);
      verifiedUsers[_user] = true;
      // emit NewUserAdded(_user, _tokenBalance);
      return verifiedUsers[_user] = true;
  } 
  
  // @notice view getter function to grab userBase for setter addUser() function above 
  // @params allows UserInfo[] struct cos it's memory, not storage
  function fetchUserBase() external view returns (UserInfo[] memory) {
     return usersInfo;
  }
    
  // @notice so onlyOwner can add a new seedLot to seedLots array  
  // @params shelflife(of this variety), lotGrams(deposit weight), expiryDate(of this lot)
  // @params seedClass (e.g. tomato), variety(e.g. 'Roma'), owner(contract deployer)
  // @dev I thought I need to define onlyOwner modifier from inherited 'Ownable.sol' contract,
  // @dev but if I use it says caller is not owner and Ownable.OwnershipTransferred() was called
  // @dev puses new seedLot struct to seedLots array
  // @dev maps 'caller' address to this seedLot in userSeedLots mapping
  // see code way futher down for setting expiry date
  
  // SHOULD BE ONLY OWNDER FUNCTION!!!!!!! or is it not cos 'owner' is function call from 'Ownable.sol'??
  function addSeed(
    uint _shelfLife,
    uint _lotGrams,
    uint _expiryDate,
    string memory _seedClass,
    string memory _variety
  ) external {

    SeedLot memory seedLot = SeedLot({
      shelfLife: _shelfLife,
      lotGrams: _lotGrams,
      expiryDate: _expiryDate,
      seedClass: _seedClass,
      variety: _variety,
      owner: msg.sender
    });
    
    seedLots.push(seedLot);
    userSeedLots[msg.sender].push(seedLot);
  }

  // @notice getter function to grab a SeedLot[] struct so we can put it in seedLots array
  // @dev returns seedLots array to use in addSeed function above
  function fetchSeedLots() external view returns (SeedLot[] memory) {
    return seedLots;
}
  
}

// @notice altenative to above fetchSeedLots getter. 
// @notice Apparantly the following view getter function lets us  
// @dev build and loop over an array in memory which is compute intensive but gas cheap
// @dev and doesn't involve  unneeded storage to blockchain. It needs work
// function fetchSeedLots(address _owner) external view returns (SeedLot[] memory) {
//   SeedLot[] memory result = new SeedLot[](userSeedLots[_owner]);
//   uint counter = 0;
//   for (uint i = 0; i < seedLots.length; i++) {
//     if (userSeedLots[i] == _owner) {
//       result[counter] = i; 
//       counter++;
//     }
//   }
//   return result;
// }

// @notice to make sure user deposit weight is within the allowed parameters
// @params lotGram(user's weight deposit)
// @dev checks lotGram against the below stockLimit algorithm
//     modifier noGLut(lotGrams) owner {
//         require(lotGrams =< ((maxStockLimit - balanceGrams) / depositDivisorArg e.g.  10);
//         _;
//     } 

// @notice make sure user doesn't withdraw more than is allowed
// @params lotGram(user's weight withdrawl)
// @dev checks lotGram againnst below stockLimit algorithm      
// modifier noPlunder(lotGrams) owner {
//         require(lotGrams =< ((minStockLimit - balanceGrams) / depositDivisorArg e.g. 10);
//         _;
//     } 

// @notice modifier for user deposit function
// @dev puts a timelock restriction on user deposit frequency
//   modifier dontTakeThePiss() {
//         require(user hasnt deposited =< time period against weight of previous deposits
//            like coolOffPeriod in cryptozombies);
//         _;
//   } 

// Don't I need this constructor function???
// Or does this run automatically in the other contract?
// constructor() public Ownable() {} 
 
// pragma solidity >=0.4.22 <0.9.0;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

// contract MyToken is ERC20, Ownable {
// constructor() ERC20("MyToken", "MTK") {}

// function mint(address to, uint256 amount) public onlyOwner {
//         _mint(to, amount);
// }
// }

// contract SeedHub is Ownable{

// contract SeedHub {
/// event

// WHAT IS IN STORAGE PAUL?????

// uint16 public lotId; // should produce a short memorable number hashed mapped to user address
// address internal owner;    
// address public user;
// string public seedClass;

// mapping(uint => bool) internal newVarieties; // confirm variety is added, though maybe can loop and check with "" => bool in an array???
// mapping(address => bool) internal userBase; // precondition:  validated suppliers mapping/user must be verified. We can check through this
// mapping(address => uint16) private lots; // to track user activity. This doesn't wotk, I think
// mapping (address => uint) public accountBalance; // to track all users' balances
// mapping(string => Seed) public seedClass; // a. to first track seedClass e.g. tomato
// b. to secondly track variety of that class e.g. 'Roma' (tomato)
// As with the mapping, surely we need to store and retrieve these data sets together class=>variety
// mapping(string => (string => Seed)) classVarieties;  need to can do this in one fail swoop
// string public variety;
// mapping(string => Seed) varieties;
// so below is an array should let us store variety in a class set. I know this is wrong but it's a start
// Seed[] public VarietySets;
// SeedClass[] public VarietySets; above array should be this
// SeedBank[] public ClassSets;

// SeedClass[Variety[]] public seedClasses; // need to tame these and not have them flying all over the show
// enum State { Deposited, Stored, Intransit, Approved, Withdrawn}
// / State state type would eventually be added to LotId struct

// / can I use bytes for a lot of these values e.g. lotId
// / and also string names converted to bytes for storage
// / by hashing them?
// struct Seed {
//     uint16 shelflife;
//     uint16 gramToTokenValue;
//     uint8 balanceToken;
//     uint24 balanceGrams;
//     string seedClass;
//     string variety;  
//     uint24 maxStockLimit;
//     uint24 minStockLimit;      
// }


// / what about string to bytes?
// / data to be added in front end 
// / LOT ID NEEDS TO BE HASHED BUT WHITTLED DOWN to 6 DIGITS or so
//  abi.encodePacked(...) returns (bytes memory): Performs packed encoding of the given
//  arguments. n.b. this encoding can be ambiguous!
// / see CryptoZombies dnaModulus stuff % ** 16 etc.....
//  struct LotId {
//     uint16 lotGrams;
//     uint16 expiryDate;   //NOW GET LOT ID!!! :)
//     string seedClass;
//     string variety;
//     address _address;
// }

// we need a way to map to user's lots/activity
// we can't have an endless database of userLots on chain!!!

// event NewVariety(string indexed message);


// modifier userKYCed(user) {
//     require(userBase.address == true, "Please apply for KYC through admin");
//     _;
// } 

//  the addNewSeed function is called by contract owner(s i.e. evt multisig) only
//  so do we probably do not need an address as a param
// function setNewSeed(
//     uint16 _shelflife,
//     uint16 _gramToTokenValue,
//     uint8 _balanceToken,
//     string memory class,
//     string memory _variety,
//     uint24 weight,
//     uint24 _maxStockLimit,
//     uint24 _minStockLimit 
// ) 
//     public
//     // internal 
//     returns (bool) 
// {
    // data locattion must be storage, calldata or memory, otherwise it yells
//     Seed storage newVariety = varieties[_variety];
            
//         newVariety.shelflife = _shelflife;
//         newVariety.gramToTokenValue = _gramToTokenValue;
//         newVariety.balanceToken = _balanceToken;
//         newVariety.balanceGrams = weight;
//         newVariety.seedClass = class;
//         newVariety.variety = _variety;
//         newVariety.maxStockLimit = _maxStockLimit;
//         newVariety.minStockLimit = _minStockLimit;
        
//         VarietySets.push(newVariety);
//       emit NewVariety("new variety added");
//       return true;

//     }
//  not sure what the following function is for anymore
// function getVarietySets() public view returns(Seed[] memory) {
//     return VarietySets;

// }

// function tokenToSeedValue(balanceGrams, maxStockLimit, minStockLimit, balanceToken ) owner/private pure/view {
//        Uniswap V1 algo x * y = k Uniswap      
// } 

// function deposit() noGLut(lotGrams){
//   	deposit seed to a seedVariety balance

// }
// function getSeed()


// function withdraw() noPlunder(lotGrams){
//    withdraw seed from seedVariety balance

// }

// }
// function tokenCalculation() private view/pure {
//    calculate value of token payment based on deposit to
//      Seed.balanceGrams ratio

// }

// function addNewUser() {
// }

//     function registerDepositTime() public {
//         registered = now;
// }
// function setShelflife() public returns (uint _numWeeks) {
//         require (newVariety.shelflife > (now + registerDep, "Shelflife surpassed. Please remove lotId from SeedBank")
//         emit RemoveDeprecatedSeeds()
//         return (now >= registerDep + _numWeeks)

// }
// uint lastUpdated;

// Set `lastUpdated` to `now`
// function updateTimestamp() public {
// lastUpdated = now;
// }

// Will return `true` if 5 minutes have passed since `updateTimestamp` was 
// called, `false` if 5 minutes have not passed
// function fiveMinutesHavePassed() public view returns (bool) {
// return (now >= (lastUpdated + 5 minutes));
// }

// }
