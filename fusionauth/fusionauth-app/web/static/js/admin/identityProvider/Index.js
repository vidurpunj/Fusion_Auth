/*
 * Copyright (c) 2018-2019, FusionAuth, All Rights Reserved
 */

FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};
FusionAuth.Admin.IdentityProvider = FusionAuth.Admin.IdentityProvider || {};

/**
 * @constructor
 */
FusionAuth.Admin.IdentityProvider.Index = function() {
  Prime.Utils.bindAll(this);
  new FusionAuth.UI.Listing(Prime.Document.queryById('identity-providers-table'))
      .initialize();
};

FusionAuth.Admin.IdentityProvider.Index.constructor = FusionAuth.Admin.IdentityProvider.Index;
FusionAuth.Admin.IdentityProvider.Index.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

};

