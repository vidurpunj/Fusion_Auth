[#ftl/]
[#-- @ftlvariable name="groups" type="java.util.List<io.fusionauth.domain.Group>"--]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "_macros.ftl" as groupMacros/]

[@layout.html]
  [@layout.head]
    <script>
      Prime.Document.onReady(function() {
        new FusionAuth.UI.Listing(Prime.Document.queryFirst('table'))
            .initialize();
      });
    </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" includeSave=false includeCancel=false includeAdd=true breadcrumbs={"/admin/group/": "groups"}/]
    [@layout.main]
      [@panel.full displayTotal=(groups![])?size]
        [@groupMacros.groupsTable/]
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]