[#ftl/]
[#-- @ftlvariable name="availableTypes" type="io.fusionauth.domain.provider.IdentityProviderType[]" --]
[#-- @ftlvariable name="identityProviders" type="java.util.List<io.fusionauth.domain.provider.BaseIdentityProvider>" --]
[#-- @ftlvariable name="requiredCORSConfiguration" type="java.util.Map<String, io.fusionauth.domain.CORSConfiguration>" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/dialog.ftl" as dialog/]
[#import "_macros.ftl" as identityProviderMacros/]

[@layout.html]
  [@layout.head]
    <script src="${request.contextPath}/js/admin/identityProvider/Index.js?version=${version}"></script>
    <script>
      Prime.Document.onReady(function() {
        new FusionAuth.Admin.IdentityProvider.Index();
      });
    </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" breadcrumbs={"": "settings", "/admin/identity-provider/": "identity-providers"}]
      <div id="identity-provider-actions" class="split-button" data-local-storage-key="idp-split-button">
        <a class="gray button item" href="#"><i class="fa fa-spinner fa-pulse"></i> [@message.print key="loading"/]</a>
        <button type="button" class="gray button square" aria-haspopup="true" aria-expanded="false">
          <span class="sr-only">[@message.print key="toggle-dropdown"/]</span>
        </button>
        <style>
        </style>
        <div class="menu">
         [#list availableTypes as type]
         <a id="add-${type}" class="item" href="add/${type}" >
           <img src="${request.contextPath}/images/identityProviders/${type?lower_case}.svg" alt="${message.inline(type?string)}">
           <span>Add [@message.print key="${type?string}"/]</span>
         </a>
         [/#list]
        </div>
      </div>
    [/@layout.pageHeader]
    [@layout.main]

      [#if requiredCORSConfiguration?has_content]
        [@panel.full titleKey="cors-configuration-warning" panelClass="panel orange"]
        <p>[@message.print key="{description}cors-configuration-warning"/]</p>
        [#assign link = "<a href=\"/admin/system-configuration/edit#cors-settings\">CORS filter</a>" /]
        [#-- Use control.message so we can control the escaping of the link --]
        <p>[@control.message key="cors-link" values=[link]/] </p>
        [#list requiredCORSConfiguration as name, cors]
          <fieldset class="mt-4">
          <legend>${name}</legend>
          [@properties.table]
            [#if cors.allowedHeaders?has_content]
               [@properties.row "corsConfiguration.allowedHeaders" cors.allowedHeaders?join(", ")/]
            [/#if]
            [#if cors.allowedMethods?has_content]
              [@properties.row "corsConfiguration.allowedMethods" cors.allowedMethods?join(", ")/]
            [/#if]
            [#if cors.allowedOrigins?has_content]
              [@properties.row "corsConfiguration.allowedOrigins" cors.allowedOrigins?join(", ")/]
            [/#if]
          [/@properties.table]
          </fieldset>
        [/#list]
        [/@panel.full]
      [/#if]

      [@panel.full displayTotal=(identityProviders![])?size]
        [@identityProviderMacros.identityProvidersTable/]
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]