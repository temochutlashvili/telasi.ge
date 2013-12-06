/**
 * Telasi charge calculator.
 *
 * (c) 2013 Dimitri Kurashvili (dimakura@gmail.com)
 */

Ember.TextField.reopen({
  attributeBindings: ['accept', 'autocomplete', 'autofocus', 'name', 'required']
});

window.App = Ember.Application.create({
  rootElement: '#calculator',
  api_root: 'http://localhost:3000/api'
});

App.step_tariffs = {
  '100': [0.1348030, 0.160008, 0.176976],
  '101': [0.1142400, 0.135600, 0.149980],
  '200': [0.0994000, 0.124600, 0.176976],
  '201': [0.0842400, 0.105600, 0.149980],
  '300': [0.0948012, 0.124600, 0.176976],
  '301': [0.0803400, 0.149980, 0.105600],
};

App.Router.map(function () {
  this.resource('calculator', { path: '/' });
});

var x;

App.CalculatorController = Ember.Controller.extend({
  accnumb: null,
  customer: null,
  account: null,
  charge: 100,
  period: 30,
  accountNumberChanged: function() {
    Ember.run.once(this, function() {
      var self = this;
      var accnumb = self.get('accnumb');
      $.get(App.api_root + '/customers/tariffs', {accnumb: accnumb}, function(data) {
        if (!data['error'] && !data['errors']) {
          var customer = Ember.Object.create({id: data['id'], name: data['name'], number: data['number'], address: data['address']});
          var d_accounts = data['accounts'];
          var accounts = [];
          for (var i = 0, l = d_accounts.length; i < l; i++) {
            var d_account = d_accounts[i];
            var account = Ember.Object.create({id: d_account['id'], number: d_account['number'], meter: d_account['meter'], address: d_account['address']});
            var d_tariff = d_account['tariff'];
            var tariff = Ember.Object.create({id: d_tariff['id'], name: d_tariff['name'], amount: d_tariff['amount']});
            account.set('tariff', tariff);
            accounts.push(account);
          }
          customer.set('accounts', accounts);
          self.set('customer', customer);
          self.set('account', accounts[0]);
        } else {
          self.set('customer', null);
          self.set('account', null);
        }
      });
    });
  }.observes('accnumb'),
  isStepTariff: function() {
    var account = this.get('account');
    if (account) {
      return !!App.step_tariffs[account.get('tariff').id]
    }
    return false;
  }.property('account'),
  tariff: function() {
    var tariffValue = 0;
    var account = this.get('account');
    if (account) {
      var tariff = account.get('tariff');
      var stepTariff = App.step_tariffs[tariff.id];
      if (stepTariff) {
        var charge = this.get('charge');
        var days = this.get('period');
        if (charge > 0 && days > 0) {
          var perDay = charge/days;
          var step;
          if (perDay < 101/30) { step = 1; }
          else if (perDay < 301/30) { step = 2; }
          else { step = 3; }
          tariffValue = stepTariff[step - 1];
        }
      } else {
        tariffValue = Number(tariff.get('amount'));
      }
    }
    return tariffValue.toFixed(6);
  }.property('charge', 'period', 'account'),
  result: function() {
    return (this.get('tariff') * this.get('charge')).toFixed(2);
  }.property('charge', 'period', 'account'),
});
