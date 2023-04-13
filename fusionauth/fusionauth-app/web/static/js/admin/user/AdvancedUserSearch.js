/*
 * Copyright (c) 2018, FusionAuth, All Rights Reserved
 */
'use strict';
var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles advanced AJAX user search tab.
 *
 * @constructor
 */
FusionAuth.Admin.AdvancedUserSearch = function(form, queryString) {
  Prime.Utils.bindAll(this);

  var resultDiv = Prime.Document.queryById('advanced-search-results');
  var container = resultDiv.queryUp('.panel');
  this.ajaxSearch = new FusionAuth.Admin.AJAXSearchForm()
      .withContainer(container)
      .withDefaultSearchCriteria({
        's.sortFields[0].name': 'login',
        's.sortFields[0].order': 'asc',
        's.sortFields[1].name': 'fullName',
        's.sortFields[1].order': 'asc'
      })
      .withForm(form)
      .withFormResetCallback(this._formResetPrepare)
      .withFormSubmitCallback(this._formSubmitPrepare)
      .withResultDiv(resultDiv)
      .withStorageKey(FusionAuth.Admin.AdvancedUserSearch.STORAGE_KEY)
      .initialize(queryString);

  this.tenantSelect = form.queryFirst('select[name="tenantId"]');
  if (this.tenantSelect !== null) {
    this.tenantSelect.addEventListener('change', this._handleTenantChange);
  }

  this.applicationSelect = form.queryFirst('select[name="applicationId"]').addEventListener('change', this._handleApplicationChange);
  this.anyApplicationOption = this.applicationSelect.queryFirst('option').getOuterHTML();

  this.roleSelect = form.queryFirst('select[name="role"]');
  this.anyRoleOption = this.roleSelect.queryFirst('option').getOuterHTML();

  this.groupSelect = form.queryFirst('select[name="groupId"]');
  if (this.groupSelect !== null) {
    this.anyGroupOption = this.groupSelect.queryFirst('option').getOuterHTML();
  }

  this.selectedRole = null;

  // See _handleRolesRequestSuccess, set the role so we know it should be selected after we
  // retrieve the applications
  if (this.ajaxSearch.searchCriteria['role']) {
    this.selectedRole = this.ajaxSearch.searchCriteria['role'];
  }
  if (this.ajaxSearch.searchCriteria['applicationId']) {
    this._handleApplicationChange();
  }

  this.ajaxSearch.search();
};

FusionAuth.Admin.AdvancedUserSearch.constructor = FusionAuth.Admin.AdvancedUserSearch;
FusionAuth.Admin.AdvancedUserSearch.STORAGE_KEY = 'io.fusionauth.advancedUserSearch';
FusionAuth.Admin.AdvancedUserSearch.prototype = {
  _handleApplicationChange: function() {
    var applicationId = this.applicationSelect.getValue();
    if (applicationId === '') {
      this.roleSelect.setHTML(this.anyRoleOption);
      return;
    }

    new Prime.Ajax.Request('/ajax/application/roles/' + this.applicationSelect.getValue() + '?render=options', 'GET')
        .withSuccessHandler(this._handleRolesRequestSuccess)
        .withErrorHandler(this._handleAJAXError)
        .go();
  },

  _handleApplicationRequestSuccess: function(xhr) {
    // Attempt to preserve the selected application if it still exists in the AJAX response
    this.selectedApplication = this.applicationSelect.getSelectedValues()[0];
    this.applicationSelect.setHTML(this.anyApplicationOption + xhr.responseText);
    if (this.selectedApplication !== "") {
      var selected = this.applicationSelect.queryFirst('option[value="' + this.selectedApplication + '"]');
      if (selected != null) {
        selected.setAttribute('selected', 'selected');
      }
    }

    this.applicationSelect.fireEvent('change');
  },

  _handleGroupRequestSuccess: function(xhr) {
    // Attempt to preserve the selected groupGroupAction.java if it still exists in the AJAX response
    this.selectedGroup = this.groupSelect.getSelectedValues()[0];
    this.groupSelect.setHTML(this.anyGroupOption + xhr.responseText);
    if (this.selectedGroup !== "") {
      var selected = this.groupSelect.queryFirst('option[value="' + this.selectedGroup + '"]');
      if (selected != null) {
        selected.setAttribute('selected', 'selected');
      }
    }
  },

  _handleRolesRequestSuccess: function(xhr) {
    // Attempt to preserve the selected application role if it still exists in the AJAX response
    this.selectedRole = this.roleSelect.getSelectedValues()[0] || this.selectedRole;
    this.roleSelect.setHTML(this.anyRoleOption + xhr.responseText);
    if (this.selectedRole !== "") {
      var selected = this.roleSelect.queryFirst('option[value="' + this.selectedRole + '"]');
      if (selected !== null) {
        selected.setAttribute('selected', 'selected');
      }
    }
  },

  /**
   * When the tenant selector changes, retrieve applications for that tenant.
   * @private
   */
  _handleTenantChange: function() {
    var tenantId = this.tenantSelect.getValue();
    new Prime.Ajax.Request('/ajax/application?tenantId=' + tenantId, 'GET')
        .withSuccessHandler(this._handleApplicationRequestSuccess)
        .withErrorHandler(this._handleAJAXError)
        .go();

    new Prime.Ajax.Request('/ajax/group?tenantId=' + tenantId, 'GET')
        .withSuccessHandler(this._handleGroupRequestSuccess)
        .withErrorHandler(this._handleAJAXError)
        .go();
  }
};