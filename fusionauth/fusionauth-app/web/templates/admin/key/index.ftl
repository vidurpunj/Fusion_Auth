[#ftl/]
[#-- @ftlvariable name="keys" type="java.util.List<io.fusionauth.domain.Key>" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.Keys();
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" breadcrumbs={"": "settings", "/admin/key/": "key-master"}]
    <div id="key-actions" class="split-button" data-local-storage-key="keys-split-button">
      <a class="gray button item" href="#"><i class="fa fa-spinner fa-pulse"></i> [@message.print key="loading"/]</a>
      <button type="button" class="gray button square" aria-haspopup="true" aria-expanded="false">
        <span class="sr-only">[@message.print key="toggle-dropdown"/]</span>
      </button>
      <div class="menu">

        [#-- Import --]
        <a id="import-public" class="item" href="/ajax/key/import?t=public">
          <i class="green-text fa fa-upload"></i>  <span>[@message.print key="import-public"/]</span>
        </a>
        <a id="import-certificate" class="item" href="/ajax/key/import?t=certificate">
          <i class="green-text fa fa-upload"></i> <span>[@message.print key="import-certificate"/]</span>
        </a>
        <a id="import-certificate-rsa-pair" class="item" href="/ajax/key/import?t=certificate-rsa-pair">
          <i class="green-text fa fa-upload"></i> <span>[@message.print key="import-certificate-rsa-pair"/]</span>
        </a>
        <a id="import-certificate-ec-pair" class="item" href="/ajax/key/import?t=certificate-ec-pair">
          <i class="green-text fa fa-upload"></i> <span>[@message.print key="import-certificate-ec-pair"/]</span>
        </a>
        <a id="import-rsa" class="item" href="/ajax/key/import?t=rsa-pair">
          <i class="green-text fa fa-upload"></i> <span>[@message.print key="import-rsa"/]</span>
        </a>
        <a id="import-ec" class="item" href="/ajax/key/import?t=ec-pair">
          <i class="green-text fa fa-upload"></i> <span>[@message.print key="import-ec"/]</span>
        </a>
        <a id="import-hmac" class="item" href="/ajax/key/import?t=rsa-private">
          <i class="green-text fa fa-upload"></i> <span>[@message.print key="import-rsa-private"/]</span>
        </a>
        <a id="import-hmac" class="item" href="/ajax/key/import?t=ec-private">
          <i class="green-text fa fa-upload"></i> <span>[@message.print key="import-ec-private"/]</span>
        </a>
        <a id="import-hmac" class="item" href="/ajax/key/import?t=hmac">
          <i class="green-text fa fa-upload"></i> <span>[@message.print key="import-hmac"/]</span>
        </a>

        [#-- Generate --]
        <a id="generate-rsa" class="item" href="/ajax/key/generate/RSA">
          <i class="blue-text fa fa-refresh"></i> <span>[@message.print key="generate-rsa"/]</span>
        </a>
        <a id="generate-ec" class="item default" href="/ajax/key/generate/EC">
          <i class="blue-text fa fa-refresh"></i><span> [@message.print key="generate-ec"/]</span>
        </a>
        <a id="generate-hmac" class="item" href="/ajax/key/generate/HMAC">
          <i class="blue-text fa fa-refresh"></i> <span>[@message.print key="generate-hmac"/]</span>
        </a>
      </div>
    </div>
    [/@layout.pageHeader]

    [@layout.main]
      [@panel.full displayTotal=(keys![])?size displayTotalItemsKey="keys"]
        <table class="hover">
          <thead>
          <tr>
            <th class="hide-on-mobile"><a href="#">[@message.print key="id"/]</a></th>
            <th><a href="#">[@message.print key="name"/]</a></th>
            <th class="hide-on-mobile"><a href="#">[@message.print key="type"/]</a></th>
            <th><a href="#">[@message.print key="algorithm"/]</a></th>
            <th class="hide-on-mobile"><a href="#">[@message.print key="expiration"/]</a></th>
            <th data-sortable="false" class="action">[@message.print key="action"/]</th>
          </tr>
          </thead>
          <tbody>
            [#list keys![] as key]
              [#assign shadowKey = fusionAuth.statics['io.fusionauth.api.service.system.KeyService'].ClientSecretShadowKeys.contains(key.id)/]
              <tr>
                <td class="hide-on-mobile">${properties.display(key, "id")}</td>
                <td>${properties.display(key, "name")}</td>
                <td class="hide-on-mobile">[@message.print key=key.type.name()/]</td>
                <td>${properties.display(key, "algorithm")}</td>
                <td class="hide-on-mobile">${properties.displayZonedDateTime(key, "expirationInstant", "date-format", true)}</td>
                <td class="action">
                  [#if !shadowKey]
                    [@button.action href="edit/${key.id}" icon="edit" key="edit" color="blue"/]
                  [/#if]
                  [@button.action href="/ajax/key/view/${key.id}" icon="search" key="view" ajaxView=true ajaxWideDialog=true color="green" resizeDialog=true/]
                  [#-- Show the download button for EC or RSA keys that have a public key of some sort. --]
                  [#if key.type != "HMAC" && (key.publicKey?? || key.certificate??)]
                  [@button.action href="/admin/key/download/${key.id}" icon="download" key="download" color="purple"/]
                  [/#if]
                  [#if !shadowKey]
                  [@button.action href="/ajax/key/delete/${key.id}" icon="trash" key="delete" ajaxForm=true color="red"/]
                  [/#if]
                </td>
              </tr>
            [#else]
              <tr>
                <td colspan="3">[@message.print key="no-keys"/]</td>
              </tr>
            [/#list]
          </tbody>
        </table>
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
