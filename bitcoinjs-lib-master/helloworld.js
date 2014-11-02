var chain = require('chain-node');
var bitcoin = require('bitcoinjs-lib');
var bitcoin = require('./src/index.js')

// The Chain API will never accept your private key.
// Keep the private key stored in a safe place alongside
// your program.
//



privateKey = "044015ed16d308b54d5b213324abb3c3c7e54339b8cbda040fd4f7a1cf2e9c77aff26947bac96f7de1ac327131ea24ff3d8bbba85c9f336873b43c154005e4f678";


wifKey = privateKey.toWIF();
//privateKey = bitcoin.ECKey.makeRandom()
console.log(wifKey)


chain.blockChain = 'testnet3';


//var wif = privateKey.toWIF()
//console.log('wif' + wif);

//key = bitcoin.ECKey.makeRandom()
//console.log(key.toWIF())
//console.log(key.pub.getAddress().toString())


//var key = new bitcoin.ECKey.fromWIF(wif)

var txn = new bitcoin.Transaction()
console.log('part 1');
// We use a previous transaction where our private key
// can authorize the use of its output at index 1.

txn.addInput("3d5f2f60fbd352b949981da4c33438a248f27b26bf8b9ae9ca28fb47175d6459", 1);
console.log('part 2');
// Specify the address hash of where our bitcoin should go.
// We are sending 10,000 Satoshi to a friend.

txn.addOutput("n2Q1BDERQ7voY4uzUYUQZNdHUsFwfw59ze", 10000)
console.log('part 3');
// Assume we have 100,000 Satoshi to use as a part of our
// Previous transactions has at index 1.
// Then we are making change for ourselves and leaving 10,000
// Satoshi as a mining fee.

txn.addOutput("moXoEC6RoMhdmqgtJxh5zWY5RDvXNpPE7t", 9980000)
// Finally we sign our transaction using a private key that is
// stored safely along side this program. The Chain API will
// never read your private key.
console.log("part 4");

newKey = new bitcoin.ECKey.fromWIF(wifKey)

txn.sign(0, newKey)

console.log('YESSSSS');
// Once we have created the transaction. Sending it to
// the Chain API is as simple as a single function call.
chain.sendTransaction(txn.toHex(), function(err, resp) {
  console.log('Error: ' + err);
  console.log('Resp: ' + resp.message);
});