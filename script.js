const web3 = new Web3(Web3.givenProvider)

const header = document.querySelector("header")
// Notice how we grabbed our form as a variable here?
const form = document.querySelector("form")

const connectUser = async () => {
  // We need to wait for this, it won't give us anything yet
  // If we had any information relying on it, then it would be null
  // And React would yell at us here
  await window.ethereum.request({ method: "eth_requestAccounts" })
}

// If there's an eth provider
if (window.ethereum) {
  // So we console.log the provider here
  // Commenting this out to give us space in the console
  // console.log(web3)
  // Create this button
  let connectButton = document.createElement('button')
  // The content of the button should be connect
  connectButton.innerHTML = "Connect"
  // This one's a bit fucky, have to touch up on my vanillajs syntax for this
  // But it would register a click
  connectButton.addEventListener("click", connectUser);
  // And we're saying add it inside the header element
  header.appendChild(connectButton)

  
 } else {
  // Else if there's no eth provider
  let metamaskButton = document.createElement('a')
  // Create an anchor tag, which will create a link
  metamaskButton.innerHTML = "Install MetaMask"
  // The href is a hyperlink that will take us directly to metamask to install
  metamaskButton.href = "https://metamask.io/"
  // Then we'lll add it inside the header element
  header.appendChild(metamaskButton)

  // Some apps will restrict you to a landing page or a smaller modal saying you need to install metamask
  // Because some data might rely on a users connection
  // For me, I have it resricted to showing a form to approve a spend limit
  // But even then, I gave the *disabled* attribute
  // So that way if you don't have metamask, and are not connected, you can't do anything
  let fieldSet = form.querySelector('fieldset')
  fieldSet.disabled = true
}

// On line 4 we grab our form as a variable Line 19 in the html?
form.addEventListener('submit', e => {
  // The natural behavior of a form is to submit whatever is in it
  // The default behavior -> means without this, it refreshes
  // As it submits. But we don't want it to refresh, because we haven't
  // Done anything with it.
  e.preventDefault()
  // So if you click, you'll see the screen does not flicker, indicating
  // a refresh, and you can see also that as many times as you click
  // the console log will output 'click'
  console.log('click')
  // So now we want to get what's the current value of an input.
  console.log(e)
  // ^ This returns SubmitEvent { isTrusted: [Getter] }
  // 'submit', e <= see how we fed that event listener these params?
  // It's saying the event emitted was a submit
  // console.log(e.target)
  // ^ Console logs 
  // HTMLFormElement {
  // 0: HTMLFieldSetElement {},
  // 1: HTMLInputElement {},
  // 2: HTMLInputElement {},
  // 3: HTMLInputElement {},
  // 4: HTMLInputElement {} }
  // See how it's an object with 5 html elements, if you look at our form, there are 5 elements, the first one being the fieldset it's wrapped around, the last four being inputs.
  // Now remember how we gave everything a name?
  // console.log(e.target.seedName)
  // You might have a typo here v
 
  // Returns HTMLInputElement {}
  // And now we want to get what's inside it
  // console.log(e.target.seedName.value)
  // Throw something inside the seed name input then click submit
  // Now console log their value here

  // Now this doesn't really give us anything right, it tells us in the console what the values are, but we can't really call a function with this.
  // What we need to do is create an object.
  // I haven't gotten to creating a function, but for arguments sake we can just create an object here to console.log

  // Start of our object
  const seedData = {
    // Follow my lead here
    name: e.target.seedName.value,
    // And try to type out the rest yourself. 
    variety: e.target.seedVariety.value,
    weight: e.target.seedWeightGrams.value
    // can't be in here as this is an object
  }
  console.log(seedData)
}) 
// this will fire back as empty as it's out of scope of our function
                                      // ^%$*&^(*^&%(^&%^(&$^&(^(&%(&*^)*&^&*(%)&)*^%)*&^)&*^)(^)^&)       
                                      // **********@@@@ FUNCTION &*&*& !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// So this is the logic for your form to deposit seeds-- once you get the function for solidity ironed out
// Why don't we ask for: window.addEventListener('load', function(event)) {

  // const seedBase = (seedData) => {
  //       create user class with this.seedName for seedName, 
  //   this.seedVariety for users seed variety, and this.Weight for the users weight.
  // } 
  