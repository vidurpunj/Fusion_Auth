/*
 * Copyright (c) 2021, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.OAuth2 = FusionAuth.OAuth2 || {};

/**
 * @constructor
 */
FusionAuth.OAuth2.Captcha = function() {
  Prime.Utils.bindAll(this);

  var scriptElement = Prime.Document.queryFirst('script[data-captcha-method]');
  this.data = scriptElement.getDataSet();

  Prime.Document.query('input[name="captcha_token"]').each(function(input) {
    input.queryUp('form').addEventListener('submit', this._handleFormSubmit);
  }.bind(this));
};

FusionAuth.OAuth2.Captcha.constructor = FusionAuth.OAuth2.Captcha;
FusionAuth.OAuth2.Captcha.prototype = {
  _handleFormSubmit: function(event) {
    Prime.Utils.stopEvent(event);

    var form = new Prime.Document.Element(event.target);
    var tokenInput = form.queryFirst('input[name="captcha_token"]');
    var siteKey = this.data.siteKey;

    if (this.data.captchaMethod === 'GoogleRecaptchaV2') {
      try {
        var token = grecaptcha.getResponse();
        tokenInput.setValue(token);
      } catch (e) {
        // Ignore grecaptcha.getResponse errors
      }
      form.domElement.submit();
    } else if (this.data.captchaMethod === 'GoogleRecaptchaV3') {
      grecaptcha.ready(function() {
        // reCaptcha tokens expire after 2 minutes, so we need to call execute inside the submit click
        grecaptcha.execute(siteKey, {action: 'submit'})
                  .then(function(token) {
                    tokenInput.setValue(token);
                    form.domElement.submit();
                  });
      });
    } else if (this.data.captchaMethod === 'HCaptcha' || this.data.captchaMethod === 'HCaptchaEnterprise') {
      try {
        var token = hcaptcha.getResponse();
        tokenInput.setValue(token);
      } catch (e) {
        // Ignore hcaptcha.getResponse errors
      }
      form.domElement.submit();
    } else {
      form.domElement.submit();
    }
  }
};
