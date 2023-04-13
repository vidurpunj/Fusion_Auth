[#ftl/]
[#-- @ftlvariable name="applications" type="java.util.List<io.fusionauth.domain.Application>" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "_macros.ftl" as applicationMacros/]

[@layout.html]
  [@layout.head]
    <script>
      Prime.Document.onReady(function() {
        new FusionAuth.UI.Listing(Prime.Document.queryById('application-table'))
            .initialize();
      });
    </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" includeSave=false includeCancel=false includeAdd=true breadcrumbs={"/admin/application/": "applications"}]
      [@button.iconLink href="inactive/" color="gray" tooltipKey="view-deactivated" icon="cube"/]
    [/@layout.pageHeader]
    [@layout.main]
      [@panel.full displayTotal=applications?size]
        [@applicationMacros.applicationsTable false/]
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]