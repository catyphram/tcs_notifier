(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
templates['popup'] = template({"1":function(depth0,helpers,partials,data) {
  var stack1, functionType="function", escapeExpression=this.escapeExpression;
  return "\n		<tr><td><div>\n			<h4>"
    + escapeExpression(((stack1 = (depth0 && depth0.title)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "</h4>\n			<p>Datum: "
    + escapeExpression(((stack1 = (depth0 && depth0.date)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "</p>\n			<p>Anzahl Abonnenten: "
    + escapeExpression(((stack1 = (depth0 && depth0.subscriber)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "</p>\n		</div></td></tr>\n	";
},"compiler":[5,">= 2.0.0"],"main":function(depth0,helpers,partials,data) {
  var stack1, helper, functionType="function", escapeExpression=this.escapeExpression, buffer = "<table class=\"table table-hover table-striped\">\n	";
  stack1 = helpers.each.call(depth0, ((stack1 = (depth0 && depth0.data)),stack1 == null || stack1 === false ? stack1 : stack1.items), {"name":"each","hash":{},"fn":this.program(1, data),"inverse":this.noop,"data":data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  return buffer + "\n</table>\n<div style=\"text-align:center\"><a class=\"btn btn-primary\" href=\""
    + escapeExpression(((helper = helpers.buttonURL || (depth0 && depth0.buttonURL)),(typeof helper === functionType ? helper.call(depth0, {"name":"buttonURL","hash":{},"data":data}) : helper)))
    + "\" target=\"_blank\">Zur Aktivierung</a></div>";
},"useData":true});
})();