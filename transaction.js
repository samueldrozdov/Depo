var chain = require('chain-node');
var bitcoin = require('bitcoinjs-lib');

// The Chain API will never accept your private key.
// Keep the private key stored in a safe place alongside
// your program.  
var key = new bitcoin.ECKey.fromWIF("Your private key in WIF format.")
var txn = new bitcoin.Transaction()
// We use a previous transaction where our private key
// can authorize the use of its output at index 1.
txn.addInput("Previous transaction hash.", 1);
// Specify the address hash of where our bitcoin should go.
// We are sending 10,000 Satoshi to a friend.
txn.addOutput("n2Q1BDERQ7voY4uzUYUQZNdHUsFwfw59ze", 10000)
// Assume we have 100,000 Satoshi to use as a part of our
// Previous transactions has at index 1.
// Then we are making change for ourselves and leaving 10,000
// Satoshi as a mining fee.
txn.addOutput("moXoEC6RoMhdmqgtJxh5zWY5RDvXNpPE7t", 80000)
// Finally we sign our transaction using a private key that is
// stored safely along side this program. The Chain API will
// never read your private key.
txn.sign(0, key)
 
console.log('YESSSSS');
// Once we have created the transaction. Sending it to
// the Chain API is as simple as a single function call.
chain.sendTransaction(txn.serializeHex(), function(err, resp) {
  console.log('Error: ' + err);
  console.log('Resp: ' + resp.message);
});