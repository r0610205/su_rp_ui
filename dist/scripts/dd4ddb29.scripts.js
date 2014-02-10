(function(){"use strict";angular.module("suApp",["restangular","ui.bootstrap","ngCookies","ngResource","ngSanitize","ngRoute"]).config(["RestangularProvider",function(a){var b;return b=void 0,a.setBaseUrl("https://gbg.raterpro.com"),a.setDefaultHttpFields({withCredentials:!0}),a.addResponseInterceptor(function(c,d,e,f,g){switch(b=g.headers("x-csrf-token"),b&&a.setDefaultHeaders({"X-CSRF-Token":b}),console.log("token",b),d){case"getList":return c.items;default:return c}}),a.setMethodOverriders(["put","patch"]),a.setFullResponse(!0),a.setRequestSuffix(".json")}]).config(["$routeProvider",function(a){return a.when("/signin",{templateUrl:"signin.html",controller:"SigninCtrl"}).when("/export",{templateUrl:"projects.html",controller:"ExportCtrl"}).otherwise({redirectTo:"/export"})}])}).call(this),angular.module("suApp").run(["$templateCache",function(a){"use strict";a.put("main.html",'<div class="header">\n  <ul class="nav nav-pills pull-right">\n    <li class="active"><a ng-href="#">Home</a></li>\n    <li><a ng-href="#">About</a></li>\n    <li><a ng-href="#">Contact</a></li>\n  </ul>\n  <ul class="nav nav-pills pull-right">\n    <li class="dropdown">\n      <a class="dropdown-toggle">\n        <p><i class="fa fa-camera-retro fa-2x"></i> Click me to see some awesome things!</p>\n      </a>\n      <ul class="dropdown-menu">\n        <li ng-repeat="thing in awesomeThings">\n          <a>{{thing}}</a>\n        </li>\n      </ul>\n    </li>\n  </ul>\n  <h3 class="text-muted">su_raterpro 1</h3>\n</div>\n\n<div class="jumbotron">\n  <h1>\'Allo, \'Allo!</h1>\n  <p class="lead">\n    <img src="images/yeoman.png" alt="I\'m Yeoman"><br>\n    Always a pleasure scaffolding your apps.\n  </p>\n  <p><a class="btn btn-lg btn-success" ng-href="#">Splendid!</a></p>\n</div>\n\n<div class="row marketing">\n  <h4>HTML5 Boilerplate</h4>\n  <p>\n    HTML5 Boilerplate is a professional front-end template for building fast, robust, and adaptable web apps or sites.\n  </p>\n\n  <h4>Angular</h4>\n  <p>\n    AngularJS is a toolset for building the framework most suited to your application development.\n  </p>\n\n  <h4>Karma</h4>\n  <p>Spectacular Test Runner for JavaScript.</p>\n</div>\n'),a.put("projects.html",'<div>\n<h1>Projects</h1>\n</div>\n\n<ul>\n    <li ng-repeat="project in projects">\n      {{project.name}}      \n    </li>\n  </ul>'),a.put("signin.html",'<form class="form-signin" role="form" \n  name="signin_form" \n  ng-submit="signin()">\n\n  <h2 class="form-signin-heading">Please sign in</h2>\n  \n  <input class="form-control" placeholder="Account" \n    type="account"\n    ng-model=\'user.account\'\n    ng-required=\'true\' \n    required \n    autofocus\n  >\n  <input class="form-control" placeholder="Email address" \n    type="email" \n    ng-model=\'user.email\'\n    ng-required=\'true\'\n    required\n  >\n  <input class="form-control" placeholder="Password"\n    type="password" \n    ng-model=\'user.password\' \n    ng-required=\'true\'\n    required\n  >\n  \n  <button class="btn btn-lg btn-primary btn-block" \n    type="submit"\n    ng-disabled="signin_form.$invalid || !connection.established || connection.errors">\n\n    <!-- signin_form.$invalid ||  -->\n\n    Sign in\n  </button>\n\n    <span class="status-bar label" \n      ng-class="{\n          \'label-default\': !connection.established,\n          \'label-success\': connection.established,\n          \'label-danger\': connection.errors\n        }"\n      >\n      <i class="fa" \n        ng-class="{\n          \'fa-spinner\': !connection.established,\n          \'fa-spin\': !connection.established\n        }"></i>\n      {{connection.status}}\n    </span>\n\n\n</form>')}]),function(){"use strict";angular.module("suApp").service("Messages",function(){return{connection:{inProcess:"Verifying connection to RaterPRO",verified:"Connection Verified",generalError:"Connection Error",authorized:"Connection Authorized",authenticationError:"Connection Error",error:"Test"}}})}.call(this),function(){"use strict";angular.module("suApp").service("Utils",function(){})}.call(this),function(){"use strict";angular.module("suApp").controller("SigninCtrl",["$scope","$location","$http","Restangular","Messages",function(a,b,c,d,e){var f;return a.connection={status:e.connection.inProcess,established:!1,errors:!1,authorized:!1},f=d.oneUrl("signin"),f.get().then(function(b){return console.log("get then",b),_.extend(a.connection,{established:!0,status:e.connection.verified})},function(){return _.extend(a.connection,{status:e.connection.generalError,errors:!0})}),a.signin=function(){return d.all("signin").post({user:a.user}).then(function(){return _.extend(a.connection,{established:!0,status:e.connection.authorized}),b.path("/export")},function(){return _.extend(a.connection,{status:e.connection.authenticationError})})}}])}.call(this),function(){"use strict";angular.module("suApp").controller("NavbarCtrl",["$scope",function(a){return a.isCollapsed=!0}])}.call(this),function(){"use strict";angular.module("suApp").controller("ExportCtrl",["$scope","$location","$http","Restangular","Messages",function(a,b,c,d,e){var f;return a.connection={status:e.connection.inProcess,established:!1,errors:!1,authorized:!1},f=d.all("projects"),f.getList().then(function(b){return a.projects=b.data,_.extend(a.connection,{established:!0,status:e.connection.verified})},function(c){switch(c.status){case 401:b.path("/signin")}return console.log("errors",c),_.extend(a.connection,{status:e.connection.generalError,errors:!0})})}])}.call(this);