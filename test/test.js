  //while page session is active collect incoming submitions and store them into your destination database
  //seeddata is a passthroug variable because you need a place to store each unique seeddata set somewhere.
    //not sure but lets pretend this database is a wallet or node for holding the storage and in this form more basic in concept
 /* 
  const seedBase = (seedData) => {
    //create user class with this.seedName for seedName, this.seedVariety for users seed variety, and this.Weight for the users weight.
   } 

  const seedData = {
    name: e.target.seedName.value,
    variety: e.target.seedVariety.value,
    weight: e.target.seedWeightGrams.value
  }
 */

/*PSEUDOCODE
1. create an object or constructor or array or class that takes an array of data (a dataset) and adds its as a new object of the class and into an array of objects that consist of the seeddata sets.
ex: a class of user that includes user.seedname user.seedvariety and user.seedweight

seedBase - your static database of data 
  user - a profile template for all incoming users
    user seed - current instance value 
    user variety  ''
    user weight     ''
  setuser function to push current user info to seedbase - a setter function within your seedbase 

  getuser function to access a user in the seedbase 

  edituser function to update a specific logged user set

  deletuser function to remove a user

  because user has attributes you can use the functions to add/modify/remove whole sets or parts of sets since they can be called indivudually

  for this project seedbase might be the final format in which data is organized before its sent to the contract

  if part of the functionality should be to check if user can be updated due to blockchain factors the setter function can have 
  
*/  