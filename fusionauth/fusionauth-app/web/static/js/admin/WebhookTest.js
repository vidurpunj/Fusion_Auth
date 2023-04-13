/*
 * Copyright (c) 2018-2022, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

FusionAuth.Admin.WebhookTest = function() {
  Prime.Utils.bindAll(this);

  this.editors = {};
  Prime.Document.query("textarea").each((function(e) {
    this.editors[e.getId()] = new FusionAuth.UI.TextEditor(e).withOptions({mode: {name: "javascript", json: true}});
  }).bind(this));

  this.select = Prime.Document.queryById("event-type-select").addEventListener("change", this._handleEventTypeSelect);
  this._handleEventTypeSelect();
};

FusionAuth.Admin.WebhookTest.constructor = FusionAuth.Admin.WebhookTest;
FusionAuth.Admin.WebhookTest.prototype = {

  /* ===================================================================================================================
   * Private Methods
   * ===================================================================================================================*/

  _handleEventTypeSelect: function() {
    var divId = this.select.getSelectedValues()[0];

    Prime.Document.query("#form-container > div").hide();
    Prime.Document.query("#form-container > div input,textarea").setDisabled(true);

    Prime.Document.queryById(divId).show().query('input,textarea').setDisabled(false);
    // Take the viewport height and subtract a bit, but don't go smaller than 350. We should really get the style to just
    // auto size for the height of hte panel.
    const editorHeight = Math.max(window.innerHeight - 450, 350);
    this.editors[divId + 'Example'].render().setHeight(editorHeight);
  }
};