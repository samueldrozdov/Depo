//var chain = require('chain-node');
//var bitcoin = require('bitcoinjs-lib');

// The Chain API will never accept your private key.
// Keep the private key stored in a safe place alongside
// your program.  
//var privateKey = '044015ed16d308b54d5b213324abb3c3c7e54339b8cbda040fd4f7a1cf2e9c77aff26947bac96f7de1ac327131ea24ff3d8bbba85c9f336873b43c154005e4f678';
//var wif = privateKey.toWIF()
//console.log('wif' + wif);

//var key = new bitcoin.ECKey.fromWIF(wif)
//var txn = new bitcoin.Transaction()

// We use a previous transaction where our private key
// can authorize the use of its output at index 1.
//txn.addInput("dedbeb80d4b624f75445897e7f7c39b07861cdaaa2da30ea88499c705ebc893c", 1);
// Specify the address hash of where our bitcoin should go.
// We are sending 10,000 Satoshi to a friend.
//txn.addOutput("n2Q1BDERQ7voY4uzUYUQZNdHUsFwfw59ze", 10000)
// Assume we have 100,000 Satoshi to use as a part of our
// Previous transactions has at index 1.
// Then we are making change for ourselves and leaving 10,000
// Satoshi as a mining fee.
//txn.addOutput("moXoEC6RoMhdmqgtJxh5zWY5RDvXNpPE7t", 80000)
// Finally we sign our transaction using a private key that is
// stored safely along side this program. The Chain API will
// never read your private key.
//txn.sign(0, key)
 
//console.log('YESSSSS');
// Once we have created the transaction. Sending it to
// the Chain API is as simple as a single function call.
//chain.sendTransaction(txn.serializeHex(), function(err, resp) {
 // console.log('Error: ' + err);
//  console.log('Resp: ' + resp.message);
//});

console.log("haha")