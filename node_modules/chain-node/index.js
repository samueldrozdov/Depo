var request = require('request');
var fs = require("fs");
var path = require("path");

var URL = "https://api.chain.com";
var PEM = fs.readFileSync(path.join(__dirname, "./chain.pem"));

module.exports = {
  getKey: function() {
    return this.key || 'GUEST-TOKEN';
  },
  getApiKeyId: function() {
    return this.apiKeyId || this.getKey();
  },
  getApiKeySecret: function() {
    return this.apiKeySecret;
  },
  getAuth: function() {
    return {user: this.getApiKeyId(), pass: this.getApiKeySecret()};
  },
  getVersion: function() {
    return this.version || 'v2';
  },
  getBlockChain: function() {
    return this.blockChain || 'bitcoin';
  },
  getBaseURL: function() {
    return URL + '/' + this.getVersion() + '/' + this.getBlockChain();
  },
  getNotificationsURL: function() {
    return URL + '/' + this.getVersion() + '/notifications';
  },
  getAddress: function(address, cb) {
    request({
      method: 'GET',
      uri: this.getBaseURL() + '/addresses/' + address,
      strictSSL: true,
      cert: PEM,
      auth: this.getAuth(),
    }, function(err, msg, resp) {
      cb(err, JSON.parse(resp));
    });
  },
  getAddresses: function(addresses, cb) {
    this.getAddress(addresses.join(','), cb);
  },
  getAddressTransactions: function(address, options, cb) {
    options = options || {};
    if (typeof(options) == 'function') {
        cb = options;
        options = {};
    }
    request({
      method: 'GET',
      uri: this.getBaseURL() + '/addresses/' + address + '/transactions',
      qs: options,
      strictSSL: true,
      cert: PEM,
      auth: this.getAuth(),
    }, function(err, msg, resp) {
      cb(err, JSON.parse(resp));
    });
  },
  getAddressesTransactions: function(addresses, options, cb) {
    this.getAddressTransactions(addresses.join(','), options, cb);
  },
  getAddressUnspents: function(address, cb) {
    request({
      method: 'GET',
      uri: this.getBaseURL() + '/addresses/' + address + '/unspents',
      strictSSL: true,
      cert: PEM,
      auth: this.getAuth(),
    }, function(err, msg, resp) {
      cb(err, JSON.parse(resp));
    });
  },
  getAddressesUnspents: function(addresses, cb) {
    this.getAddressUnspents(addresses.join(','), cb);
  },
  getAddressOpReturns: function(address, cb) {
    request({
      method: 'GET',
      uri: this.getBaseURL() + '/addresses/' + address + '/op-returns',
      strictSSL: true,
      cert: PEM,
      auth: this.getAuth(),
    }, function(err, msg, resp) {
      cb(err, JSON.parse(resp));
    });
  },
  getTransaction: function(hash, cb) {
    request({
      method: 'GET',
      uri: this.getBaseURL() + '/transactions/' + hash,
      strictSSL: true,
      cert: PEM,
      auth: this.getAuth(),
    }, function(err, msg, resp) {
      cb(err, JSON.parse(resp));
    });
  },
  getTransactionOpReturn: function(hash, cb) {
    request({
      method: 'GET',
      uri: this.getBaseURL() + '/transactions/' + hash + '/op-return',
      strictSSL: true,
      cert: PEM,
      auth: this.getAuth(),
    }, function(err, msg, resp) {
      cb(err, JSON.parse(resp));
    });
  },
  sendTransaction: function(hex, cb) {
    request({
      method: 'PUT',
      uri: this.getBaseURL() + '/transactions',
      strictSSL: true,
      cert: PEM,
      auth: this.getAuth(),
      json: {hex: hex},
    }, function(err, msg, resp) {
      cb(err, resp);
    });
  },
  getBlock: function(hashOrHeight, cb) {
    request({
      method: 'GET',
      uri: this.getBaseURL() + '/blocks/' + hashOrHeight,
      strictSSL: true,
      cert: PEM,
      auth: this.getAuth(),
    }, function(err, msg, resp) {
      cb(err, JSON.parse(resp));
    });
  },
  getLatestBlock: function(cb) {
    request({
      method: 'GET',
      uri: this.getBaseURL() + '/blocks/latest',
      strictSSL: true,
      cert: PEM,
      auth: this.getAuth(),
    }, function(err, msg, resp) {
      cb(err, JSON.parse(resp));
    });
  },
  getBlockOpReturns: function(hashOrHeight, cb) {
    request({
      method: 'GET',
      uri: this.getBaseURL() + '/blocks/' + hashOrHeight + '/op-returns',
      strictSSL: true,
      cert: PEM,
      auth: this.getAuth(),
    }, function(err, msg, resp) {
      cb(err, JSON.parse(resp));
    });
  },
  createNotification: function(args, cb) {
    request({
      method: 'POST',
      uri: this.getNotificationsURL(),
      strictSSL: true,
      cert: PEM,
      auth: this.getAuth(),
      json: args,
    }, function(err, msg, resp) {
      cb(err, resp);
    });
  },
  listNotifications: function(cb) {
    request({
      method: 'GET',
      uri: this.getNotificationsURL(),
      strictSSL: true,
      cert: PEM,
      auth: this.getAuth(),
    }, function(err, msg, resp) {
      cb(err, JSON.parse(resp));
    });
  },
  deleteNotification: function(id, cb) {
    request({
      method: 'DELETE',
      uri: this.getNotificationsURL() + '/' + id,
      strictSSL: true,
      cert: PEM,
      auth: this.getAuth()
    }, function(err, msg, resp) {
      cb(err, resp);
    });
  }
};
