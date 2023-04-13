/*
 * Copyright (c) 2021, FusionAuth, All Rights Reserved
 */
'use strict';
var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles advanced AJAX entity search tab.
 *
 * @constructor
 */
FusionAuth.Admin.AdvancedEntitySearch = function(form) {
  Prime.Utils.bindAll(this);

  var resultDiv = Prime.Document.queryById('advanced-search-results');
  var container = resultDiv.queryUp('.panel');
  this.ajaxSearch = new FusionAuth.Admin.AJAXSearchForm()
      .withContainer(container)
      .withDefaultSearchCriteria({
        's.sortFields[0].name': 'name',
        's.sortFields[0].order': 'asc',
        's.sortFields[1].name': 'typeId',
        's.sortFields[1].order': 'asc'
      })
      .withForm(form)
      .withFormResetCallback(this._formResetPrepare)
      .withFormSubmitCallback(this._formSubmitPrepare)
      .withResultDiv(resultDiv)
      .withStorageKey(FusionAuth.Admin.AdvancedEntitySearch.STORAGE_KEY)
      .initialize();

  this.tenantSelect = form.queryFirst('select[name="s.tenantId"]');

  this.entityTypeSelect = form.queryFirst('select[name="s.typeId"]');
  this.anyEntitTypeOption = this.entityTypeSelect.queryFirst('option').getOuterHTML();

  if (this.ajaxSearch.searchCriteria['s.typeId']) {
    this.entityTypeSelect.setSelectedValues(this.ajaxSearch.searchCriteria['s.typeId']);
  }
  if (this.ajaxSearch.searchCriteria['s.tenantId']) {
    this.tenantSelect.setSelectedValues(this.ajaxSearch.searchCriteria['s.tenantId']);
  }

  this.ajaxSearch.search();
};

FusionAuth.Admin.AdvancedEntitySearch.STORAGE_KEY = 'io.fusionauth.entity.advancedSearch';
