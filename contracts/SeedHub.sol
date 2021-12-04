// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SeedHub is Ownable {

  event NewUserAdded(address NewUser, uint userTokenBalance);
  
  // uint public userLotId; % 1000000
  // address user;

  // mapping (address => SeedLot) userSeedLots;
  
  // mapping for all registered users
  mapping(address => bool) public verifiedUsers;
  mapping(address => UserInfo[]) public userBase;
  UserInfo[] public usersBase;

  mapping(address => SeedLot[]) public userSeedLots;
  SeedLot[] public seedLots;

  // Still want a token balance of the user

  struct SeedLot {
    uint shelfLife;
    uint lotGrams;
    uint expiryDate;
    string seedClass;
    string variety;
    address owner;
  }

  // We're going to KYC the user
  struct UserInfo {
      address user;
      uint tokenBalance;
  }
  
  modifier verifiedUser(address _user) {
    require(verifiedUsers[msg.sender] == true, "Caught, mister. We pinpoint potential trouble-makers...And neutralize them!");
    _;
  }

  function addUser(address _user, uint _tokenBalance) internal onlyOwner returns(bool) { 
      UserInfo memory userInfo = UserInfo ({
        user: _user,
        tokenBalance: _tokenBalance
      });
      usersBase.push(userInfo);
      verifiedUsers[_user] = true;
      emit NewUserAdded(_user, _tokenBalance);
      return verifiedUsers[_user];
        
  } 
    // 
  function fetchUserBase() external view returns (UserInfo[] memory) {
    return usersBase;
  }
  
  // see code way futher down for setting expiry date
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

  function fetchSeedLots() external view returns (SeedLot[] memory) {
    return seedLots;
}

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
}
  // Don't I need this constructor function???
  // Or does this run automatically in the other contract?
  // constructor() public Ownable() {} 
 
  // function addNewUser(address _user)
  //      public onlyOwner {
  //      userBase[_user] = true;
  // }
// pragma solidity >=0.4.22 <0.9.0;

// // import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

// // contract MyToken is ERC20, Ownable {
// //     constructor() ERC20("MyToken", "MTK") {}

// //     function mint(address to, uint256 amount) public onlyOwner {
// //         _mint(to, amount);
// //     }
// // }

// contract SeedHub is Ownable{

//     // contract SeedHub {
//     /// event

//     // WHAT IS IN STORAGE PAUL?????
    
//     // uint16 public lotId; // should produce a short memorable number hashed mapped to user address
//     // address internal owner;    
//     // address public user;
//     // string public seedClass;

//     // mapping(uint => bool) internal newVarieties; // confirm variety is added, though maybe can loop and check with "" => bool in an array???
//     // mapping(address => bool) internal userBase; // precondition:  validated suppliers mapping/user must be verified. We can check through this
//     mapping(address => uint16) private lots; // to track user activity. This doesn't wotk, I think
//     mapping (address => uint) public accountBalance; // to track all users' balances
//     // mapping(string => Seed) public seedClass; // a. to first track seedClass e.g. tomato
//      // b. to secondly track variety of that class e.g. 'Roma' (tomato)
//    // As with the mapping, surely we need to store and retrieve these data sets together class=>variety
//     // mapping(string => (string => Seed)) classVarieties;  need to can do this in one fail swoop
//     // string public variety;
//     mapping(string => Seed) varieties;
//    // so below is an array should let us store variety in a class set. I know this is wrong but it's a start
//     Seed[] public VarietySets;
//     // SeedClass[] public VarietySets; above array should be this
//     SeedBank[] public ClassSets;

//     // SeedClass[Variety[]] public seedClasses; // need to tame these and not have them flying all over the show
//     // enum State { Deposited, Stored, Intransit, Approved, Withdrawn}
//     /// State state type would eventually be added to LotId struct

//     /// can I use bytes for a lot of these values e.g. lotId
//     /// and also string names converted to bytes for storage
//     /// by hashing them?
//     struct Seed {
//         uint16 shelflife;
//         uint16 gramToTokenValue;
//         uint8 balanceToken;
//         uint24 balanceGrams;
//         string seedClass;
//         string variety;  
//         uint24 maxStockLimit;
//         uint24 minStockLimit;      
//     }

    
//     // /// what about string to bytes?
//     // /// data to be added in front end 
//     // /// LOT ID NEEDS TO BE HASHED BUT WHITTLED DOWN to 6 DIGITS or so
//     // abi.encodePacked(...) returns (bytes memory): Performs packed encoding of the given
//     /// arguments. n.b. this encoding can be ambiguous!
//     // /// see CryptoZombies dnaModulus stuff % ** 16 etc.....
//     struct LotId {
//         uint16 lotGrams;
//         uint16 expiryDate;   //NOW GET LOT ID!!! :)
//         string seedClass;
//         string variety;
//         address _address;
//     }

//     // we need a way to map to user's lots/activity
//     // we can't have an endless database of userLots on chain!!!
//     struct UserInfo {
//         address user;
//         uint tokenBalance;
//     }

//     event NewVariety(string indexed message);

//      modifier knowYourSupplier(address) owner {
//         require(userBase[msg.sender] != 0, "go and sort some KYC out, dickhead"); 
//             _;
//        }
    
//     modifier dontTakeThePiss() {
//         require(user hasnt deposited =< six months);
//         _;
//     } 
//     modifier noGLut(lotGrams) owner {
//         require(lotGrams =< ((maxStockLimit - balanceGrams) / 10);
//         _;
//     } 

//      modifier noPlunder(lotGrams) owner {
//         require(lotGrams =< ((minStockLimit - balanceGrams) / 10);
//         _;
//     } 

//     modifier userKYCed(user) {
//         require(userBase.address == true, "Please apply for KYC through admin");
//         _;
//     } 
 
//      / the addNewSeed function is called by contract owner(s i.e. evt multisig) only
//     / so do we probably do not need an address as a param
//     function setNewSeed(
//         uint16 _shelflife,
//         uint16 _gramToTokenValue,
//         uint8 _balanceToken,
//         string memory class,
//         string memory _variety,
//         uint24 weight,
//         uint24 _maxStockLimit,
//         uint24 _minStockLimit 
//     ) 
//         public
//         // internal 
//         returns (bool) 
//     {
//         // data locattion must be storage, calldata or memory, otherwise it yells
//         Seed storage newVariety = varieties[_variety];
                
//             newVariety.shelflife = _shelflife;
//             newVariety.gramToTokenValue = _gramToTokenValue;
//             newVariety.balanceToken = _balanceToken;
//             newVariety.balanceGrams = weight;
//             newVariety.seedClass = class;
//             newVariety.variety = _variety;
//             newVariety.maxStockLimit = _maxStockLimit;
//             newVariety.minStockLimit = _minStockLimit;
            
//             VarietySets.push(newVariety);
//           emit NewVariety("new variety added");
//           return true;

//         }
//     /// not sure what the following function is for anymore
//     function getVarietySets() public view returns(Seed[] memory) {
//         return VarietySets;
    
//     }
    
//     // function tokenToSeedValue(balanceGrams, maxStockLimit, minStockLimit, balanceToken ) owner/private pure/view {
//     //        Uniswap V1 algo x * y = k Uniswap      
//     // } 
    
//     // function deposit() noGLut(lotGrams){
// 	// 	deposit seed to a seedVariety balance
	
// 	// }
//     // function getSeed()


// 	// function withdraw() noPlunder(lotGrams){
// 	// 	// withdraw seed from seedVariety balance
		
// 	// }

//     // function tokenTx() {
// 		// calculate user token balance and pay/deduct accordingly
	
// 	// }
// 	// function tokenCalculation() private view/pure {
// 	// 	// calculate value of token payment based on deposit to
//     //     // Seed.balanceGrams ratio
	
// 	// }

//     function addNewUser() {
		
	
// 	// }

//         function registerDepositTime() public {
//             registered = now;
// }
//     // function setShelflife() public returns (uint _numWeeks) {
//             // require (newVariety.shelflife > (now + registerDep, "Shelflife surpassed. Please remove lotId from SeedBank")
//             // emit RemoveDeprecatedSeeds()
//             // return (now >= registerDep + _numWeeks)
	
// 	// }
// uint lastUpdated;

// // Set `lastUpdated` to `now`
// function updateTimestamp() public {
//   lastUpdated = now;
// }

// // Will return `true` if 5 minutes have passed since `updateTimestamp` was 
// // called, `false` if 5 minutes have not passed
// function fiveMinutesHavePassed() public view returns (bool) {
//   return (now >= (lastUpdated + 5 minutes));
// }

// }
