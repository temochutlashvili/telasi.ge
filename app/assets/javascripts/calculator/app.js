/**
 * Telasi charge calculator.
 *
 * (c) 2013 Dimitri Kurashvili (dimakura@gmail.com)
 */

window.App = Ember.Application.create({
  rootElement: '#calculator',
  step_tariff: [0.08034, 0.10540, 0.14998],
});

App.Router.map(function () {
  this.resource('calculator', { path: '/' });
});

App.CalculatorController = Ember.Controller.extend({
  charge: 100,
  period: 30,
  withVat: true,
  result: function() {
    var charge = this.get('charge');
    var days = this.get('period');
    var result;
    if (charge > 0 && days > 0) {
      var perDay = charge/days;
      var step;
      if (perDay < 100/30) { step = 1; }
      else if (perDay < 200/30) { step = 2; }
      else { step = 3; }
      var result = App.step_tariff[step - 1] * charge;
      var vat = this.get('withVat');
      if (vat) {
        result = result * 1.18;
      }
    } else {
      result = 0;
    }
    return result.toFixed(2);
  }.property('charge', 'period', 'withVat'),
});
