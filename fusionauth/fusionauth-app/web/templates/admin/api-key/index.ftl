[#ftl/]
[#-- @ftlvariable name="apiKeys" type="java.util.List<io.fusionauth.domain.APIKey>" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "_macros.ftl" as apiMacros/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.APIKeys();
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" includeSave=false includeCancel=false includeAdd=true breadcrumbs={"": "settings", "/admin/api-key/": "api-authentication-keys"}/]
    [@layout.main]
      [@panel.full displayTotal=(apiKeys![])?size]
        [@apiMacros.apiKeysTable/]
      [/@panel.full]
    [/@layout.main]
    [#-- Used for API key reveals --]
    [@control.form id="api-key-reveal-form" action="${request.contextPath}/ajax/api-key/reveal" method="POST" class="inline-block"]
      [@control.hidden name="apiKeyId"/]
    [/@control.form]
  [/@layout.body]
[/@layout.html]
